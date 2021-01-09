
**OPENSSL API 분석**

- SSL_CTX_set_tlsext_servername_callback(ctx, cb)
	* 내부적 define  SSL_CTX_callback_ctrl(ctx,SSL_CTRL_SET_TLSEXT_SERVERNAME_CB, (void (*)(void))cb)
	* SSL_CTX_ctrl(ctx,SSL_CTRL_SET_TLSEXT_SERVERNAME_ARG,0,arg)
	* ctx 는 SSL_CTX 구조체 포인터
	* cb 는 callback
	* 함수
		* SSL_CTRL_SET_MSG_CALLBACK cmd 를 제외하고는 ctx->method->ssl_ctx_callback_ctrl 함수 호출

- SSLv23_method
	* 내부적 define TLS_method
	* TLS_method 는 IMPLEMENT_tls_meth_func 메크로에 의하여 TLS_client_method 함수가 만들어짐
		* static 형식의  TLS_client_method_data 이름의 SSL_METHOD 구조체가 만들어지고 이를 리턴이는 전역에 남음
		* 더 알아보기 위해서는 ssl/methods.c 소스파일 참조
		* 이 구조체에는 아래와 같이 정의됨

static const SSL_METHOD func_name##_data= { \
	version, \
	flags, \
	mask, \
	tls1_new, \
	tls1_clear, \
	tls1_free, \
	s_accept, \					//---------- ossl_statem_accept
	s_connect, \				//---------- ossl_statem_connect
	ssl3_read, \
	ssl3_peek, \
	ssl3_write, \
	ssl3_shutdown, \
	ssl3_renegotiate, \
	ssl3_renegotiate_check, \
	ssl3_read_bytes, \
	ssl3_write_bytes, \
	ssl3_dispatch_alert, \
	ssl3_ctrl, \
	ssl3_ctx_ctrl, \
	ssl3_get_cipher_by_char, \
	ssl3_put_cipher_by_char, \
	ssl3_pending, \
	ssl3_num_ciphers, \
	ssl3_get_cipher, \
	tls1_default_timeout, \
	&enc_data, \				//---------- TLSv1_2_enc_data
	ssl_undefined_void_function, \
	ssl3_callback_ctrl, \
	ssl3_ctx_callback_ctrl, \
};
		- 참고로 위 구조체 정의는 아래와 같다.
struct ssl_method_st {
    int version;
    unsigned flags;
    unsigned long mask;
    int (*ssl_new) (SSL *s);
    int (*ssl_clear) (SSL *s);
    void (*ssl_free) (SSL *s);
    int (*ssl_accept) (SSL *s);
    int (*ssl_connect) (SSL *s);
    int (*ssl_read) (SSL *s, void *buf, size_t len, size_t *readbytes);
    int (*ssl_peek) (SSL *s, void *buf, size_t len, size_t *readbytes);
    int (*ssl_write) (SSL *s, const void *buf, size_t len, size_t *written);
    int (*ssl_shutdown) (SSL *s);
    int (*ssl_renegotiate) (SSL *s);
    int (*ssl_renegotiate_check) (SSL *s, int);
    int (*ssl_read_bytes) (SSL *s, int type, int *recvd_type,
                           unsigned char *buf, size_t len, int peek,
                           size_t *readbytes);
    int (*ssl_write_bytes) (SSL *s, int type, const void *buf_, size_t len,
                            size_t *written);
    int (*ssl_dispatch_alert) (SSL *s);
    long (*ssl_ctrl) (SSL *s, int cmd, long larg, void *parg);
    long (*ssl_ctx_ctrl) (SSL_CTX *ctx, int cmd, long larg, void *parg);
    const SSL_CIPHER *(*get_cipher_by_char) (const unsigned char *ptr);
    int (*put_cipher_by_char) (const SSL_CIPHER *cipher, WPACKET *pkt,
                               size_t *len); 
    size_t (*ssl_pending) (const SSL *s);
    int (*num_ciphers) (void);
    const SSL_CIPHER *(*get_cipher) (unsigned ncipher);
    long (*get_timeout) (void);
    const struct ssl3_enc_method *ssl3_enc; /* Extra SSLv3/TLS stuff */
    int (*ssl_version) (void);
    long (*ssl_callback_ctrl) (SSL *s, int cb_id, void (*fp) (void));
    long (*ssl_ctx_callback_ctrl) (SSL_CTX *s, int cb_id, void (*fp) (void));
};
		- 끝

- SSL_CTX_new( //method// )
	* method 는 위에 설정된 구조체가 들어감 (이는 버전별로 다릅니다.)
	* Nginx 에서는SSLv23_method() 를 사용하는데 이는 위 구조체와 같다.
	* 아래 과정 수행 (한번만 수행이 되도록 한다)
		1. OPENSSL_init_ssl 
			- 내부적으로 위 함수의 option 에 따라 OPENSSL_init_crypto 수행
			- 내부적으로 oss_init_ssl_base 수행 (RUN ONCE)
		2. SSL_get_ex_data_X509_STORE_CTX_idx
			- 이는 아래 코드를 보는게 더 빠를듯

```c
DEFINE_RUN_ONCE_STATIC(ssl_x509_store_ctx_init)
{       
    ssl_x509_store_ctx_idx = X509_STORE_CTX_get_ex_new_index(0,
                                                             "SSL for verify callback",
                                                             NULL, NULL, NULL);
    return ssl_x509_store_ctx_idx >= 0;
}   
    
int SSL_get_ex_data_X509_STORE_CTX_idx(void)
{       

    if (!RUN_ONCE(&ssl_x509_store_ctx_once, ssl_x509_store_ctx_init))   // ssl_x509_store_ctx_init_ossl_
        return -1;
    return ssl_x509_store_ctx_idx;
}
```
		3. SSL_CTX 구조체 생성 후 method 멤버변수에 파라미터로 받은 구조체 삽입
		4. 각종 기본 설정들을 내립니다.
			- verify_mode = SSL_VERIFY_NONE
			- sessions 생성
			- cert_store 에 X509_STORE_new() 로 생성
			...

- SSL_CTX_set_ex_data
	- application 데이터를 OPENSSL Structure 에 Attach 하도록 합니다. 
	
- SSL_CTX_set_read_ahead
	- 기존의 ctx 의 read_ahead 멤버 변수를 리턴하며 새로 입력받은 파라미터의 값을 
	- read_ahead 멤버변수에 넣는다.
	- 내부적으로  SSL_CTX_ctrl 함수 호출하며 파라미터로 SSL_CTRL_SET_READ_AHEAD 가 붙는다

- SSL_CTX_ctrl 
	- SSL_*_ctrl 종류의 함수들 SSL_CTX 나 SSL 겍체를 조작하기 위해서 사용된다.

- SSL_CTX_set_info_callback
	- ctx 의 info_callback 멤버에 해당하는 callback 함수를 삽입
	- SSL 핸드쉐이크 메세지 교환 과정을 알려주는 콜백함수를 세팅합니다. 

- SSL_CTX_set_verify
	- ctx 의 verify_callback 에 mode 와 원하는 콜백함수를 넣어줍니다.

- SSL_CTX_load_verify_locations
	- 내부적으로 X509_STORE_load_locations 함수 호출
	- ctx->cert_store 멤버변수에 저장한다.
	- file 을 읽는 것은  아래 by_file_ctrl 함수를 사용한다
```c
static X509_LOOKUP_METHOD x509_file_lookup = {
    "Load file into cache",
    NULL,                       /* new_item */
    NULL,                       /* free */
    NULL,                       /* init */
    NULL,                       /* shutdown */
    by_file_ctrl,               /* ctrl */
    NULL,                       /* get_by_subject */
    NULL,                       /* get_by_issuer_serial */
    NULL,                       /* get_by_fingerprint */
    NULL,                       /* get_by_alias */
};
```

- SSL_load_client_CA_file
	- CA 인증서를 파싱한 후,  이름을 hash 화 한다. (좀더 봐야함...)

- SSL_CTX_set_client_CA_list
	- 참고로 ssl/ssl_cert.c 에 있다.
	- 내부적으로 set0_CA_list 호출
		- ctx 의 client_ca_names 의 리스트에 있는 것을 모두 해제시키고, 파라미터로 넘어온 name_set 를 ca_list에 세팅한다.

- X509_STORE_load_locations
	- 파라미터 file 의 파일을 로드한다. (디폴트 PEM 형식)
	- directory path 로도 줄 수 있지만 nginx 에서는 사용하지 않음
	

- X509_STORE_new
	* X509_STORE 구조체 동적할당 하여 내부 멤버변수를 할당
	* 멤버 objs 할당 (기존의 있는 것을 비교하면서 할당)
	* 멤버 cache 1로 세팅
	* 멤버 get_cert_methods 에 새로운 X09_LOOKUP 타입의 stack 할당
		...
	* 멤버 reference 를 1로 세팅


- X509_STORE_CTX_get_ex_new_index
	* 내부적 CRYPTO_get_ex_new_index 로 변경되며 파라미터가 CRYPTO_EX_INDEX_X509_STORE_CTX 가 추가됨
	* 마치 CRYPTO prefix 가 붙는 함수가 메인인듯 함 X509 prefix 의 함수들은 wrapper 함수인듯
	* get_and_lock 함수 수행
	* 새로운 ex_data 배열중 index (CRYPTO_EX_INDEX_X509_STORE_CTX) 에 meth 를
	  추가(없다면), 그리고 넘겨받은 파라미터들을 EX_CALLBACK 구조체에 담아 ex_data 의 ip 의 meth 에 설정

- STACK_OF
	- Applications can create and use their own stacks by placing any of the macros descripbed below in a 
	  header file.
	- https://man.openbsd.org/STACK_OF.3
	- https://www.openssl.org/docs/man1.1.0/man3/DEFINE_STACK_OF.html
		- sk_TYPE_push() appends ptr to sk.
		- sk_TYPE_new_null() allocates a new empty stack with no comparison function.
		- sk_TYPE_value() returns element idx in sk.
			 - const TYPE *sk_FUNCNAME_value(STACK_OF(TYPE) *sk, int idx);
		- sk_TYPE_set() sets element idx of sk to ptr replacing the current element.
		- sk_TYPE_num() returns the number of elements in sk or -1 if sk is NULL
		- sk_TYPE_pop_free() frees up all elements of sk and sk itself freefunc() is called on each element to
		                     free it
	- 쉽게 설명하자면, 특정 타입의 배열이라고 볼 수 있다.
	- STACK_OF(test) 는 define 을 통해서 struct stack_st_test 라는 이름으로 변경이 됩니다.
	- DEFINE_STACK_OF(test) 는 SKM_DEFINE_STACK_OF(test, test, test) 라는 것으로 변경이되는데 
	  SKM_DEFINE_STACK_OF 메크로가 조금 특이하다. 아래를 보면 알 수 있다.

```c
# define SKM_DEFINE_STACK_OF(t1, t2, t3) \
    STACK_OF(t1); \                                                                                          
    typedef int (*sk_##t1##_compfunc)(const t3 * const *a, const t3 *const *b); \
    typedef void (*sk_##t1##_freefunc)(t3 *a); \
    typedef t3 * (*sk_##t1##_copyfunc)(const t3 *a); \                                                       
    static ossl_unused ossl_inline int sk_##t1##_num(const STACK_OF(t1) *sk) \                               
    { \                                                                                                      
        return OPENSSL_sk_num((const OPENSSL_STACK *)sk); \                                                  
    } \                                                                                                      
    static ossl_unused ossl_inline t2 *sk_##t1##_value(const STACK_OF(t1) *sk, int idx) \
    { \ 
        return (t2 *)OPENSSL_sk_value((const OPENSSL_STACK *)sk, idx); \                                     
    } \                                                                                                      
    static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_new(sk_##t1##_compfunc compare) \                 
    { \                                                                                                      
        return (STACK_OF(t1) *)OPENSSL_sk_new((OPENSSL_sk_compfunc)compare); \                               
    } \                                                                                                      
    static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_new_null(void) \ 
    { \ 
        return (STACK_OF(t1) *)OPENSSL_sk_new_null(); \                                                      
    } \                                                                                                      
    static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_new_reserve(sk_##t1##_compfunc compare, int n) \ 
    { \ 
        return (STACK_OF(t1) *)OPENSSL_sk_new_reserve((OPENSSL_sk_compfunc)compare, n); \                    
    } \                                                                                                      
    static ossl_unused ossl_inline int sk_##t1##_reserve(STACK_OF(t1) *sk, int n) \                          
    { \                                                                                                      
        return OPENSSL_sk_reserve((OPENSSL_STACK *)sk, n); \                                                 
    } \                                                                                                      
    static ossl_unused ossl_inline void sk_##t1##_free(STACK_OF(t1) *sk) \                                   
    { \                                                                                                      
        OPENSSL_sk_free((OPENSSL_STACK *)sk); \                                                              
    } \                                                                                                      
    static ossl_unused ossl_inline void sk_##t1##_zero(STACK_OF(t1) *sk) \                                   
    { \                                                                                                      
        OPENSSL_sk_zero((OPENSSL_STACK *)sk); \                                                              
    } \                                                                                                      
    static ossl_unused ossl_inline t2 *sk_##t1##_delete(STACK_OF(t1) *sk, int i) \
    { \
        return (t2 *)OPENSSL_sk_delete((OPENSSL_STACK *)sk, i); \                                            
    } \                                                                                                      
    static ossl_unused ossl_inline t2 *sk_##t1##_delete_ptr(STACK_OF(t1) *sk, t2 *ptr) \
    { \ 
        return (t2 *)OPENSSL_sk_delete_ptr((OPENSSL_STACK *)sk, \
                                           (const void *)ptr); \                                             
    } \                                                                                                      
    static ossl_unused ossl_inline int sk_##t1##_push(STACK_OF(t1) *sk, t2 *ptr) \
    { \ 
        return OPENSSL_sk_push((OPENSSL_STACK *)sk, (const void *)ptr); \                                    
    } \                                                                                                      
    static ossl_unused ossl_inline int sk_##t1##_unshift(STACK_OF(t1) *sk, t2 *ptr) \
    { \ 
        return OPENSSL_sk_unshift((OPENSSL_STACK *)sk, (const void *)ptr); \                                 
    } \                                                                                                      
	    static ossl_unused ossl_inline t2 *sk_##t1##_pop(STACK_OF(t1) *sk) \
    { \
        return (t2 *)OPENSSL_sk_pop((OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline t2 *sk_##t1##_shift(STACK_OF(t1) *sk) \
    { \
        return (t2 *)OPENSSL_sk_shift((OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline void sk_##t1##_pop_free(STACK_OF(t1) *sk, sk_##t1##_freefunc freefunc) \
    { \
        OPENSSL_sk_pop_free((OPENSSL_STACK *)sk, (OPENSSL_sk_freefunc)freefunc); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_insert(STACK_OF(t1) *sk, t2 *ptr, int idx) \
    { \
        return OPENSSL_sk_insert((OPENSSL_STACK *)sk, (const void *)ptr, idx); \
    } \
    static ossl_unused ossl_inline t2 *sk_##t1##_set(STACK_OF(t1) *sk, int idx, t2 *ptr) \
    { \
        return (t2 *)OPENSSL_sk_set((OPENSSL_STACK *)sk, idx, (const void *)ptr); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_find(STACK_OF(t1) *sk, t2 *ptr) \
    { \
        return OPENSSL_sk_find((OPENSSL_STACK *)sk, (const void *)ptr); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_find_ex(STACK_OF(t1) *sk, t2 *ptr) \
    { \
        return OPENSSL_sk_find_ex((OPENSSL_STACK *)sk, (const void *)ptr); \
    } \
    static ossl_unused ossl_inline void sk_##t1##_sort(STACK_OF(t1) *sk) \
    { \
        OPENSSL_sk_sort((OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline int sk_##t1##_is_sorted(const STACK_OF(t1) *sk) \
    { \
        return OPENSSL_sk_is_sorted((const OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline STACK_OF(t1) * sk_##t1##_dup(const STACK_OF(t1) *sk) \
    { \
        return (STACK_OF(t1) *)OPENSSL_sk_dup((const OPENSSL_STACK *)sk); \
    } \
    static ossl_unused ossl_inline STACK_OF(t1) *sk_##t1##_deep_copy(const STACK_OF(t1) *sk, \
                                                    sk_##t1##_copyfunc copyfunc, \
                                                    sk_##t1##_freefunc freefunc) \
    { \
        return (STACK_OF(t1) *)OPENSSL_sk_deep_copy((const OPENSSL_STACK *)sk, \
                                            (OPENSSL_sk_copyfunc)copyfunc, \
                                            (OPENSSL_sk_freefunc)freefunc); \
    } \
    static ossl_unused ossl_inline sk_##t1##_compfunc sk_##t1##_set_cmp_func(STACK_OF(t1) *sk, sk_##t1##_compfunc c
ompare) \
    { \
        return (sk_##t1##_compfunc)OPENSSL_sk_set_cmp_func((OPENSSL_STACK *)sk, (OPENSSL_sk_compfunc)compare); \
    }
```
	- 여기서 보면 알수 있듯이, 자동 함수들이 정의된다.
	- st_test_num 예시 함수와 같이 st_XXX_function 과 같이 함수들이 만들어지며, 내부적으로는 openssl/stack.h 에
	  정의된 함수들을 호출하는 wrapper 함수들이다.
	- 실제 정의되는 OPENSSL_STACK 은 아래이다.
```c
struct stack_st {
    int num;
    const void **data;
    int sorted;
    int num_alloc;
    OPENSSL_sk_compfunc comp;
};
```


- get_and_lock 함수 
	* 함수의 파라미터인 class 아래와 같음
	* CRYPTO_EX_INDEX_X509_STOR_CTX는 EX_CALLBACKS 구조체의 ex_data 의 index 로 사용
	* write lock 을 획득
	* 앞서 ex_data 의 해당하는 index 의 메모리 값을 리턴


- SSL_CTX_set_ex_data(SSL_CTX *s, int idx, void *arg)
	* 내부적 CRYPTO_set_ex_data 함수를 호출, 이때 파라미터가 변경
		* CRYPTO_set_ex_data(&s->ex_data

- DEFINE_RUN_ONCE_STATIC(init)
	* 아래 코드 참조
```c
#define DEFINE_RUN_ONCE_STATIC(init)            \
    static int init(void);                     \
    static int init##_ossl_ret_ = 0;            \
    static void init##_ossl_(void)              \
    {                                           \
        init##_ossl_ret_ = init();              \
    }                                           \
    static int init(void)
```

- send_certificate_request
	- SSL 구조체의 verify_mode 가 SSL_VERIFY_PEER 인 경우 그리고 그 외 세부 설정 사항에 대해서 조건을
	  만족한다면 리턴 값을 1을 그렇지 않으면 0을 리턴한다.
	- 1 : 요청한다
	- 0 : 요청하지 않는다.


- SSL_get_changed_async_fds
	- SSL* s 의 waitctx 를 넘겨줘서 내부적으로 ASYNC_WAIT_CTX_get_changed_fds 를 수행한다.

- ASYNC_WAIT_CTX_get_changed_fds 
	- ctx->numadd, ctx->numdel 을 꺼내서 넘겨진 파라미터에 대입
	  처음 불렸을 때에는 대입만 하고 1을 리턴하게된다.
	- ctx 에 add_fds 가 있는 경우, Nginx에서 (QAT) 에서는 자체 memory를 할당
	- ctx 에 del_fds 가 있는 경우, add 와 마찬가지로 자체 메모리 할당.
	- Nginx 에서는 이 함수를 활용하는데 
	  요 함수가 하는 일은 Nginx 에서 fds 가 add 인 것은 ngx_add_async_conn 함수를 써서 추가하고
	  del_fds 인 경우에는 ngx_del_async_conn 함수를 써서 제거하는 작업을 수행한다.
	- ctx->a

- SSL_do_handshake
	- 실제 handshake 를 하게된다.
	- s->handshake_func 이 반드시 설정되어있어야하며, 이는 client mode 냐 server mode 냐에 따라서 다른
	  function 이 할당된다. (s->method->ssl_connect 또는 s->method->ssl_accept)
	- 단, Async 모드인 경우에는 다른 함수가 호출
		- ssl_start_async_job 함수가 호출되며 내부적으로 s->handshake_func 함수가 호출이 된다.

- ssl_start_async_job
	- SSL s의 waitctx 를 새로 할당합니다.
	- 그리고 ASYNC_start_job 함술르 수행합니다.


- X509_STORE
	- is intended to be a consolidated mechanism for holding information about X.509 certificates and CRLs,
	  and constructing and validating chains of certificates terminating in trusted roots. It admits multiple
	  lookup mechanisms and efficient scaling performance with large numbers of certificates, and a great deal
	  of flexibility in how validation and policy checks are performed
	- Once the X509_STORE is suitably configured, X509_STORE_CTX_new() is used to instantiate a single-use
	  X509_STORE_CTX for each chain-building and verification operation.

----------------------------------------------------------------------------------------------------

openssl 구조

* statem
	- SSL 구조체 내에 있는 멤버함수이며, SSL 처리 과정에 대해서 상태정보를 관리한다.
	- 해당 구조체는 아래를 참조

```c
struct ossl_statem_st {
    MSG_FLOW_STATE state;
    WRITE_STATE write_state;
    WORK_STATE write_state_work;
    READ_STATE read_state;
    WORK_STATE read_state_work;
    OSSL_HANDSHAKE_STATE hand_state;
    /* The handshake state requested by an API call (e.g. HelloRequest) */
    OSSL_HANDSHAKE_STATE request_state;
    int in_init;
    int read_state_first_init;
    /* true when we are actually in SSL_accept() or SSL_connect() */
    int in_handshake;
    /*
     * True when are processing a "real" handshake that needs cleaning up (not
     * just a HelloRequest or similar).
     */
    int cleanuphand;
    /* Should we skip the CertificateVerify message? */
    unsigned int no_cert_verify;
    int use_timer;
    ENC_WRITE_STATES enc_write_state;
    ENC_READ_STATES enc_read_state;
};
typedef struct ossl_statem_st OSSL_STATEM;
```
	- 초기 상태는
		- statem.state = MSG_FLOW_UNINITED
		- statem.hand_state = TLS_ST_BEFORE
		- statem.in_init = 1
		- statem.no_cert_verify = 0


* 기본적으로 각 상태에따라 function 들을 설정한다.

----------------------------------------------------------------------------------------------------


d2i_ prefix 관련 코드 분석

- d2i_EC_PRIVATEKEY 와 같은 함수들이 많다. 이는 openssl 에서 내부적으로 구현되어있다 (메크로로)

```c
# define IMPLEMENT_STATIC_ASN1_ENCODE_FUNCTIONS(stname) \
        static stname *d2i_##stname(stname **a, \
                                   const unsigned char **in, long len) \
        { \
                return (stname *)ASN1_item_d2i((ASN1_VALUE **)a, in, len, \
                                               ASN1_ITEM_rptr(stname)); \
        } \
        static int i2d_##stname(stname *a, unsigned char **out) \
        { \
                return ASN1_item_i2d((ASN1_VALUE *)a, out, \
                                     ASN1_ITEM_rptr(stname)); \
        }

                                                                             
# define IMPLEMENT_ASN1_FUNCTIONS_const(name) \                              
                IMPLEMENT_ASN1_FUNCTIONS_const_fname(name, name, name)       
                                                                             
# define IMPLEMENT_ASN1_FUNCTIONS_const_fname(stname, itname, fname) \       
        IMPLEMENT_ASN1_ENCODE_FUNCTIONS_const_fname(stname, itname, fname) \ 
        IMPLEMENT_ASN1_ALLOC_FUNCTIONS_fname(stname, itname, fname)          

DECLARE_ASN1_FUNCTIONS_const(EC_PRIVATEKEY)                         
DECLARE_ASN1_ENCODE_FUNCTIONS_const(EC_PRIVATEKEY, EC_PRIVATEKEY)   
IMPLEMENT_ASN1_FUNCTIONS_const(EC_PRIVATEKEY)                       
```

- 위와 같이 IMPLEMENT_ANS1_FUNCTIONS_const 와 같이 메크로 함수를 써서 d2i 와 i2d 접두사를 한 함수가 구현됨
- 즉 결과적으로는 ANS1_item_d2i 함수를 호출하게됨 파라미터만 조금 다르게

----------------------------------------------------------------------------------------------------

Nginx 와의 동작

* ngx_ssl_create_connecetion
	- QAT 인 경우에는 ASYNC 모드로 동작하도록 한다.


----------------------------------------------------------------------------------------------------

**Server Hello 과정의 Cipher 선택 이해**

- 알림
	1. openssl 1.1.0 기반으로 작성되었습니다. (이전 버전에 대해서는 코드내용이 다름)
	2. 아래 내용은 TLS1.3 을 포함하지 않습니다. (TLS1.2 까지 확인)

- 함수 호출 과정
	- tls_post_process_client_hello
		- ssl3_choose_cipher 

- tls_post_process_client_hello
	- OPENSSL 은 post 개념이 추가됨.
	- 예를 들면, tls_process_client_hello 함수가 수행이되고, 이에 추가적으로 필요한 작업이 있는 경우
	  tls_post_process_client_hello 라는 이름으로 (_post_ 가 추가) 추가함수가 수행이 됩니다.


- ssl3_choose_cipher
	- 실제 cipher 를 결정하는 함수입니다. 이 함수에서는 client 가 보내온 정보를 기반으로 
	  (예를 들면, supportedgroup 인 curve 값) 현재 인증서와 제공할수 있는 cipher 를 비교합니다.
	- 예로들어 ECDHE_ECDSA cipher 를 지원한다고 하는 경우
		- tls1_set_cert_validity 함수에서 **인증서의** curve 값을 확인
			- client 가 보내온 supportedgroup 에 위 해당하 인증서 curve 값이 있는지 확인
			- 동일한 curve 가 지원이 된다면, authentication 은 지원이 됨을 확인 (즉, ECDSA 는 지원 가능)
		- tls1_check_ec_tmp_key 함수에서 키교환 알고리즘 (ECDHE) 에 필요한 client 와 server 의 curve 비교
			- server 입장에서는 config 타임에서 설정된 supported_groups 값을 불러옴
			  (openssl 에서는 SSL 구조체의 해당 값을 가짐 `s->ext.supportedgroups`)
			- client 입장에서는 client hello 에서 제공할수있는 supported_groups 값을 전달
			  (openssl 에서는 client 가 보낸 값을 다음 SSL 구조체에 값을 가짐 `s->ext.peer_supportedgroups`)
	- 서로 같은 curve 를 지원하는 경우에 ECDHE 와 ECDSA cipher 가 지원됨.


**ecdh 설정 방식**

- ssl3_ctx_ctrl 함수에서 SSL_CTRL_SET_GROUPS_LIST command 로 수행하게 됩니다.
- tls1_set_groups_list 함수를 통해 ctx->ext.supportedgroups 에 group list 로 설정이 됩니다.
- : 단위로 여러개 curve 를 설정할 수 있으며 이는 str -> nid 로 변환 nid -> group 변환 과정을 거칩니다.


**handshake 과정에서 ecdh 보내는 과정**

- ossl_statem_server_construct_message 단계에서 tls_construct_server_hello 함수 호출을 하게 됩니다.
- 이후, tls_construct_extension 함수를 내부적으로 호출하게되고 thisexd->construct_stoc 를 호출하게 됩니다.
- thisexd->construct_stoc 함수는 TLSEXT_TYPE_supported_groups  타입에 대해서 tls_construct_stoc_supported_groups
  함수 입니다.
- tls_construct_stoc_supported_groups 함수에서 본래 파싱 단계에서 설정했던 group (바로 위 참조) 을 불러옵니다.
- 이후, pkt 변수에 group 값을 비트 0xff 길이로 기입합니다.


**tls1_set_cert_validity 함수 더 알아보기**

- tls1_set_cert_validity 함수에서는 SSL 구조체 s 의 각 chain 을 검사한다.

```c
void tls1_set_cert_validity(SSL *s)
{
    tls1_check_chain(s, NULL, NULL, NULL, SSL_PKEY_RSA);
    tls1_check_chain(s, NULL, NULL, NULL, SSL_PKEY_RSA_PSS_SIGN);
    tls1_check_chain(s, NULL, NULL, NULL, SSL_PKEY_DSA_SIGN);
    tls1_check_chain(s, NULL, NULL, NULL, SSL_PKEY_ECC);
    tls1_check_chain(s, NULL, NULL, NULL, SSL_PKEY_GOST01);
    tls1_check_chain(s, NULL, NULL, NULL, SSL_PKEY_GOST12_256);
    tls1_check_chain(s, NULL, NULL, NULL, SSL_PKEY_GOST12_512);
    tls1_check_chain(s, NULL, NULL, NULL, SSL_PKEY_ED25519);
    tls1_check_chain(s, NULL, NULL, NULL, SSL_PKEY_ED448);
}
```

tls1_check_chain 함수는 넘겨받은 idx (위에서 SSL_PKEY_ECC 같은 파라미터) 를 가지고 certificate PKEY, c, 
X509 x, EVP_PKEY pk, chain 를 구한다.
이후, tls1_check_cert_param 함수를 통해 (s, x, 1 /*check_ee_md*/ 파라미터로) 인증서의 param 를 확인한다.
- 이 함수 내에서는 x (x509) 를 가지고 pubkey 를 구하고, 이 pubkey 로 group_id 를 구한다.
- 이후 수행되는 tls1_check_group_id 를 통해 아래 함수들을 통과
	- tls_curve_allowd(s, group_id, SSL_SECOP_CURVE_CHECK)
	- tls1_get_peer_groups(s, &groups, &groups_len); 이 함수는 groups 에 s->ext.peer_supportedgroups 값을 넣음
		- supportedgroups 는  nginx 에서 ssl_ecdh_curve 로 들어간 값(확인 필요)
	- tls1_in_list(group_id, groups, groups_len) 을 통해 선호 하는 (groups) 에 group_id 가 있는지 확인한다.

참고로 group_id 는 다음 코드의 index 이다.

```c
/*
 * Table of curve information.
 * Do not delete entries or reorder this array! It is used as a lookup
 * table: the index of each entry is one less than the TLS curve id.
 */
static const TLS_GROUP_INFO nid_list[] = {
    {NID_sect163k1, 80, TLS_CURVE_CHAR2}, /* sect163k1 (1) */	<-- 1, 2, 3, 4 가 group id 이다.
    {NID_sect163r1, 80, TLS_CURVE_CHAR2}, /* sect163r1 (2) */
    {NID_sect163r2, 80, TLS_CURVE_CHAR2}, /* sect163r2 (3) */
    {NID_sect193r1, 80, TLS_CURVE_CHAR2}, /* sect193r1 (4) */
    {NID_sect193r2, 80, TLS_CURVE_CHAR2}, /* sect193r2 (5) */
    {NID_sect233k1, 112, TLS_CURVE_CHAR2}, /* sect233k1 (6) */
    {NID_sect233r1, 112, TLS_CURVE_CHAR2}, /* sect233r1 (7) */
    {NID_sect239k1, 112, TLS_CURVE_CHAR2}, /* sect239k1 (8) */
    {NID_sect283k1, 128, TLS_CURVE_CHAR2}, /* sect283k1 (9) */
    {NID_sect283r1, 128, TLS_CURVE_CHAR2}, /* sect283r1 (10) */
    {NID_sect409k1, 192, TLS_CURVE_CHAR2}, /* sect409k1 (11) */
    {NID_sect409r1, 192, TLS_CURVE_CHAR2}, /* sect409r1 (12) */
    {NID_sect571k1, 256, TLS_CURVE_CHAR2}, /* sect571k1 (13) */
    {NID_sect571r1, 256, TLS_CURVE_CHAR2}, /* sect571r1 (14) */
    {NID_secp160k1, 80, TLS_CURVE_PRIME}, /* secp160k1 (15) */
    {NID_secp160r1, 80, TLS_CURVE_PRIME}, /* secp160r1 (16) */
    {NID_secp160r2, 80, TLS_CURVE_PRIME}, /* secp160r2 (17) */
    {NID_secp192k1, 80, TLS_CURVE_PRIME}, /* secp192k1 (18) */
    {NID_X9_62_prime192v1, 80, TLS_CURVE_PRIME}, /* secp192r1 (19) */
    {NID_secp224k1, 112, TLS_CURVE_PRIME}, /* secp224k1 (20) */
    {NID_secp224r1, 112, TLS_CURVE_PRIME}, /* secp224r1 (21) */
    {NID_secp256k1, 128, TLS_CURVE_PRIME}, /* secp256k1 (22) */
    {NID_X9_62_prime256v1, 128, TLS_CURVE_PRIME}, /* secp256r1 (23) */
    {NID_secp384r1, 192, TLS_CURVE_PRIME}, /* secp384r1 (24) */
    {NID_secp521r1, 256, TLS_CURVE_PRIME}, /* secp521r1 (25) */
    {NID_brainpoolP256r1, 128, TLS_CURVE_PRIME}, /* brainpoolP256r1 (26) */
    {NID_brainpoolP384r1, 192, TLS_CURVE_PRIME}, /* brainpoolP384r1 (27) */
    {NID_brainpoolP512r1, 256, TLS_CURVE_PRIME}, /* brainpool512r1 (28) */
    {EVP_PKEY_X25519, 128, TLS_CURVE_CUSTOM}, /* X25519 (29) */
    {EVP_PKEY_X448, 224, TLS_CURVE_CUSTOM}, /* X448 (30) */
};
```

server key exchange 방식은 
tls_construct_server_key_exchange 함수를 확인하면 알 수 있다.
새롭게 EC key 를 생성하고, 이에 따른 signature 까지 하는 과정을 알 수 있다.
	- s->s3->tmp.pkey 에 생성이 된다. 
	- s->s3->tmp.pkey = ssl_generate_pkey_group(s, curve_id)


tls_post_process_client_hello 과정
	1. ssl3_choose_cipher
	2. tls_construct_server_key_exchange

---------------------------------------------------------------------------------------------------

dhparam

- 현재 PAS-K 는 DHE cipher 를 사용하기 위해서는 DH 인증서를 넣어주어서 사용하고 있다.

---------------------------------------------------------------------------------------------------

support curve version 

openssl 1.1.0
	/* The default curves */                                 
static const unsigned char eccurves_default[] = {        
    0, 29,                      /* X25519 (29) */        
    0, 23,                      /* secp256r1 (23) */     
    0, 25,                      /* secp521r1 (25) */     
    0, 24,                      /* secp384r1 (24) */
};

---------------------------------------------------------------------------------------------------

SSL 구조체의 statem

- state
	- Message flow 상태를 나타낸다.
		- MSG_FLOW_UNINITED
		- MSG_FLOW_ERROR
		- MSG_FLOW_READING
		- MSG_FLOW_WRITING
		- MSG_FLOW_FINISHED
- hand_state, request_state
	- handshake 의 상태를 나타낸다.
```c
typedef enum {
    TLS_ST_BEFORE,
    TLS_ST_OK,
    DTLS_ST_CR_HELLO_VERIFY_REQUEST,
    TLS_ST_CR_SRVR_HELLO,
    TLS_ST_CR_CERT,
    TLS_ST_CR_CERT_STATUS,
    TLS_ST_CR_KEY_EXCH,
    TLS_ST_CR_CERT_REQ,
    TLS_ST_CR_SRVR_DONE,
    TLS_ST_CR_SESSION_TICKET,
    TLS_ST_CR_CHANGE,
    TLS_ST_CR_FINISHED,
    TLS_ST_CW_CLNT_HELLO,
    TLS_ST_CW_CERT,
    TLS_ST_CW_KEY_EXCH,
    TLS_ST_CW_CERT_VRFY,
    TLS_ST_CW_CHANGE,
    TLS_ST_CW_NEXT_PROTO,
    TLS_ST_CW_FINISHED,
    TLS_ST_SW_HELLO_REQ,
    TLS_ST_SR_CLNT_HELLO, 
    DTLS_ST_SW_HELLO_VERIFY_REQUEST,
    TLS_ST_SW_SRVR_HELLO,
    TLS_ST_SW_CERT, 
    TLS_ST_SW_KEY_EXCH,
    TLS_ST_SW_CERT_REQ,
    TLS_ST_SW_SRVR_DONE,
    TLS_ST_SR_CERT,
    TLS_ST_SR_KEY_EXCH,
    TLS_ST_SR_CERT_VRFY,
    TLS_ST_SR_NEXT_PROTO,
    TLS_ST_SR_CHANGE,
    TLS_ST_SR_FINISHED,
    TLS_ST_SW_SESSION_TICKET,
    TLS_ST_SW_CERT_STATUS,
    TLS_ST_SW_CHANGE,
    TLS_ST_SW_FINISHED,
    TLS_ST_SW_ENCRYPTED_EXTENSIONS,
    TLS_ST_CR_ENCRYPTED_EXTENSIONS,
    TLS_ST_CR_CERT_VRFY,
    TLS_ST_SW_CERT_VRFY,
    TLS_ST_CR_HELLO_REQ,
    TLS_ST_SW_KEY_UPDATE,
    TLS_ST_CW_KEY_UPDATE,
    TLS_ST_SR_KEY_UPDATE,
    TLS_ST_CR_KEY_UPDATE,
    TLS_ST_EARLY_DATA,
    TLS_ST_PENDING_EARLY_DATA_END,
    TLS_ST_CW_END_OF_EARLY_DATA,
    TLS_ST_SR_END_OF_EARLY_DATA
} OSSL_HANDSHAKE_STATE;
```

------------------------------------------------------------------------------------------------

**tls_setup_handshake**

- SSL 구조체의 ext (extension) flag 초기화
- SSL 구조체의 cipher_list 가져온다.


------------------------------------------------------------------------------------------------

처음 state

```
1. st->state = MSG_FLOW_UNINITED
2. st->state = MSG_FLOW_WRITING
do init_write_state_machine
3. st->write_state = WRITE_STATE_TRANSITION
4. st->hand_state = TLS_ST_BEFORE

do write_write_state_machine
	set transition, pre_work, post_work, get_construct_message_f for server
	call info callback
	oss_statem_server_write_transition for server [transition(s)]

st->state = MSG_FLOW_READING
init_read_state_machine
st->read_state = READ_STATE_HEADER

read_state_machine(s)
	set transition, process_message, max_message_size, post_process_message for server
	for loop!
	tls_get_message_header   or dtls_get_message (if dtls)
		s->method->ssl_read_bytes		이 함수에서 recvd_type 이 튀어나오는데 그 종류는 아래와 같다.
										SSL3_RT_CHANGE_CIPHER_SPEC, RT_ALERT, RT_HANDSHAKE, RT_APPLICATION_DATA
										RT_HEARTBEAT .. 등등
			s->rwstate = SSL_NOTHING
	ossl_statem_server_read_tansition[transition(s)]	아마 여기서 hand_state 가 TLS_ST_SR_CLNT_HELLO 세팅?
	st->read_state = READ_STATE_BODY;
	tls_get_message_body

	이순간 s->statem 상태 기록
	(gdb) p s->statem
$26 = {state = MSG_FLOW_READING, write_state = WRITE_STATE_TRANSITION, write_state_work = WORK_ERROR,
  read_state = READ_STATE_BODY, read_state_work = WORK_ERROR, hand_state = TLS_ST_SR_CLNT_HELLO,
  request_state = TLS_ST_BEFORE, in_init = 1, read_state_first_init = 0, in_handshake = 1, cleanuphand = 0,
  no_cert_verify = 0, use_timer = 0, enc_write_state = ENC_WRITE_STATE_VALID, enc_read_state = ENC_READ_STATE_VALID}

	process_message()
		hand_state 가 TLS_ST_SR_CLNT_HELLO 이기에 tls_process_client_hello 함수 수행 (s, pkt)
			return MSG_PROCESS_CONTINUE_PROCESSING
	
	st->read_state = READ_STATE_POST_PROCESS		<-- process_message 에서 MSG_PROCESS_CONTINUE_PROCESSING 에 
														따름
	st->read_state_work = WROK_MORE_A

	for loop 시작부분으로 이동

	st->read_state_work = post_process_message(s, st->read_state_work)
		st->hand_state 가 TLS_ST_SR_CLNT_HELLO 임에 따라 tls_post_process_client_hello 함수 수행
			tls_post_process_client_hello 내부에서는 WORK_STATE 에 따라 움직임 (아마 단계가 A>B>C 단계로 수행

			wst 값은 WORK_A
			tls_early_post_process_client_hello

					ssl_get_new_session

					tls_parse_all_extensions	<-- 여기서 client 로 부터 받은 extension 값들을 모두 파싱한다.

			wst 값은 WORK_B

			ssl3_choose_cipher					<-- 여기서 server 와 client 간의 cipher 결정

			(gdb) p *cipher		<-- 예시
$48 = {valid = 1, name = 0x7f0e462108a4 "DHE-RSA-AES256-GCM-SHA384", 
  stdname = 0x7f0e462108c0 "TLS_DHE_RSA_WITH_AES_256_GCM_SHA384", id = 50331807, algorithm_mkey = 2, 
  algorithm_auth = 1, algorithm_enc = 8192, algorithm_mac = 64, min_tls = 771, max_tls = 771, min_dtls = 65277, 
  max_dtls = 65277, algo_strength = 24, algorithm2 = 1285, strength_bits = 256, alg_bits = 256}


			s->s3->tmp.new_cipher 에 결정된 cipher 가 들어감.

			wst 값은 WORK_C 로변경

			이후는 srp 관련 설정 수행

			wst 값은 WORK_FINISHED_STOP 으로 변경
	
	st->read_state_work = WORK_FINISHED_STOP 값을 가짐

	DTLS 이면 dtls1_stop_timer
	
	return SUB_STATE_FINISHED

	st->state 값은 MSG_FLOW_WRITING 으로 변경 (MSG_FLOW_READING 에서 SUB_STATE_FINISHED 를 만나기에 교체됨

	init_write_state_machine					<--- 이함수의 목적은 st->write_state 값을 초기로 만들기위함 
		st->write_state = WRITE_STATE_TRANSITION

	현재까지의 상태
	(gdb) p *st
$51 = {state = MSG_FLOW_WRITING, write_state = WRITE_STATE_TRANSITION, write_state_work = WORK_ERROR,
  read_state = READ_STATE_POST_PROCESS, read_state_work = WORK_FINISHED_STOP, hand_state = TLS_ST_SR_CLNT_HELLO,
  request_state = TLS_ST_BEFORE, in_init = 1, read_state_first_init = 0, in_handshake = 1, cleanuphand = 0,
  no_cert_verify = 0, use_timer = 0, enc_write_state = ENC_WRITE_STATE_VALID, enc_read_state = ENC_READ_STATE_VALID}

	-- 분석 여기까지. --

	알아둘 것은 MSG_FLOW_WRITING 단계에서 write_state_machine 수행 후 SUB_STATE_END_HANDSHAKE 를 만나면 끝나게됨
	그렇지 않고 SUB_STATE_FINISHED 를 만나면 다시 read 상태로 넘어가게 됨

```

---
openssl locking
https://web.mit.edu/6.005/www/fa15/classes/23-locks/
		
---

**tls_handle_status_request**

- SSl 구조체 ext 맴버변수는 내부 status_expected 값을 가짐
-

---

#0  ngx_ssl_verify_callback (ok=1, x509_store=0x14ffab0) at src/event/ngx_event_openssl.c:903
#1  0x00007f90faf64c44 in internal_verify (ctx=0x14ffab0) at crypto/x509/x509_vfy.c:1769
#2  0x00007f90faf61b04 in verify_chain (ctx=0x14ffab0) at crypto/x509/x509_vfy.c:232
#3  0x00007f90faf61d5c in X509_verify_cert (ctx=0x14ffab0) at crypto/x509/x509_vfy.c:295
#4  0x00007f90fb285658 in ssl_verify_cert_chain (s=0x14e2740, sk=0x14f96b0) at ssl/ssl_cert.c:427
#5  0x00007f90fb2c7fcf in tls_process_client_certificate (s=0x14e2740, pkt=0x14f2fc0)
    at ssl/statem/statem_srvr.c:3682
#6  0x00007f90fb2c2338 in ossl_statem_server_process_message (s=0x14e2740, pkt=0x14f2fc0)
    at ssl/statem/statem_srvr.c:1176
#7  0x00007f90fb2ae6a0 in read_state_machine (s=0x14e2740) at ssl/statem/statem.c:636
#8  0x00007f90fb2ae112 in state_machine (s=0x14e2740, server=1) at ssl/statem/statem.c:434
#9  0x00007f90fb2adc37 in ossl_statem_accept (s=0x14e2740) at ssl/statem/statem.c:255
#10 0x00007f90fb29406e in ssl_do_handshake_intern (vargs=0x14dcca0) at ssl/ssl_lib.c:3583
#11 0x00007f90fadd5ee9 in async_start_func () at crypto/async/async.c:152
#12 0x00007f90fa5af2c0 in ?? () from /lib/x86_64-linux-gnu/libc.so.6
#13 0x0000000000000000 in ?? ()

-------------------------------------------------------------------------------------------

**tls_process_client_certificate**

- from

-------------------------------------------------------------------------------------------

**EVP(envelope)**

- EVP API level provides the high-level abstract interface to cryptographic functionality
- Direct use of concrete cryptographic algorithm implementations via interface other than the EVP layer
  is **discouraged**.

-------------------------------------------------------------------------------------------

**Conceptual Component View**

- 4 level layering
	- Applications Component
	- TLS Component		(libssl)
	- Crypto Component	(libcrypto)
	- Engines Component

- to-be
	- The EVP layer becomes a thin wrapper for services implemented in the providers

! TLS protocols
	! SSL BIO
	! Statem
	! Record
! Supporting Services
	! Packet: internal component for reading protocol messages
	! Wpacket: internal component for writing protocol messages

33c4073175df4ee6f5767a7f620552fa

OPENSSL 
	- ENGINE has many methods

qat 에 async 쪽을 좀더 보자.


-------------------------------------------------------------------------------------------

**PACKET_remainig**

- PACKET *pkt need to be read (it's remaining.)
- 대게 얼마나 남아있는지 확인하기 위함. 0이면 아무것도 읽을게 없다.
- 있다면, *pkt->curr 

**PACKET_get_1**

- PACKET *pkt 구조체로 관리되고 있는 읽을 것에 대해서 1 바이트만 읽도록 한다.
- 얼마나 읽었는지에 대한 관리는 *pkt->curr 값과*pkt->remaining 값으로 확인한다.


**PACKET_peek_bypes**

- 

**Packet Buffer start**

- s->init_buf 가 없다면, BUF_MEM_new() 를 통해서 buf 를 가리킬 주소값을 할당받음

- handshake_fragment_len 이 있는 경우 handshake_fragment 의 버퍼를 SSL 버퍼에 옮긴다.

SSL 구조체의 rlayer 는 record layer 이다. 

```c
typedef struct record_layer_st {
    /* The parent SSL structure */
    SSL *s;
    /*
     * Read as many input bytes as possible (for
     * non-blocking reads)
     */
    int read_ahead;
    /* where we are when reading */
    int rstate;
    /* How many pipelines can be used to read data */
    size_t numrpipes;
    /* How many pipelines can be used to write data */
    size_t numwpipes;
    /* read IO goes into here */
    SSL3_BUFFER rbuf;
    /* write IO goes into here */
    SSL3_BUFFER wbuf[SSL_MAX_PIPELINES];
    /* each decoded record goes in here */
    SSL3_RECORD rrec[SSL_MAX_PIPELINES];
    /* used internally to point at a raw packet */
    unsigned char *packet;
    size_t packet_length;
    /* number of bytes sent so far */
    size_t wnum;
    unsigned char handshake_fragment[4];
    size_t handshake_fragment_len;
    /* The number of consecutive empty records we have received */
    size_t empty_record_count;
    /* partial write - check the numbers match */
    /* number bytes written */
    size_t wpend_tot;
    int wpend_type;
    /* number of bytes submitted */
    size_t wpend_ret;
    const unsigned char *wpend_buf;
    unsigned char read_sequence[SEQ_NUM_SIZE];
    unsigned char write_sequence[SEQ_NUM_SIZE];
    /* Set to true if this is the first record in a connection */
    unsigned int is_first_record;
    /* Count of the number of consecutive warning alerts received */
    unsigned int alert_count;
    DTLS_RECORD_LAYER *d;
} RECORD_LAYER;
```

ssl3_setup_buffers 에서 buf 메모리 alloc  수행.

**** read 수행 과정****
start entry : tls_get_message_header -> method->ssl_read_bytes
처음 read 시에는 ssl3_read_n 함수에서 s->rlayer->rbuf->buf 에 읽을만큼 담기게된다.
내부적으로 BIO_read 함수를 사용하는데 이는 더 분석이 필요함
또한, s->rlayer->rbuf->buf 를 pkt 라는 포인터 변수로 넘겨줌.
이후에 읽은만큼 rbuf 의 offset, left 가 책정됨
재미있는 점은 BIO_read 전후로 s->rwstate 값이 SSL_READING 으로 설정된다는 것.
참고로 이과정은 tls_get_message_header => ssl3_read_bytes => ssl3_get_record 를 통해서 들어옴
그리고! rbuf 에서는 일고자하는 것보다 더 많이 읽고 실제 packet 을 가리키는 곳은 s->rlayer->packet 멤버변수에
있다. 이 packet 의 length 는 실제 읽고싶은 만큼만이며, rbuf 에는 한번에 읽을 수 있는만큼 다 들어있음
즉, |rbuf-----|packet|------------| 이런 개념 참고로, packet 의 포인터는 rbuf 의 내부를 가리킴

그리고 ssl3_get_record 에서 처음 PACKET 이라는 구조체가 나오게 되는데, 이 값은 앞서 받은 packet 구조체의 
packet_length 만큼만 (PACKET*)pkt->curr 위 packet 포인터가 들어가며, remain 은 len 로 체워짐
이 과정이 PACKET_buf_init 에서 처음 수행이 됨

읽다가 더 필요한 경우 ssl3_read_n 으로 필요한 양만큼 계산하여 읽는 방식

최종적으로는 s->rlayer->rrec 의 배열에 0 번째 index 에 record 값이 들어간다.


rrec_num 은 RECORD_LAYER_get_numrpipes 값을 통해 가지고 올 수 있다.

ssl3_read_bytes 의 마지막은 s->init_buf->data 부분에 복사 되는 것
s->init_buf->data 는 readbytes 의 값 만큼 더해짐
s->init_msg 는 header 를 뺀 부분 (대략 4 값을 가짐)

여기 까지가 header 를 읽는 부분이였음

------------------------------------------------------------------------------------

grow_init_buf 의 타겟은 s->init_msg 이다.
