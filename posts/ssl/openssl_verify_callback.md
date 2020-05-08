

verify_chain
    X509_STORE_CTX(ctx) -> check_revocation(ctx)
        check_cert
            check_crl (defined at x509/x509_vfy.c)


X509_STORE_CTX_init
    store 가 있으면, store->verify_cb 가 ctx->verify_cb 로


openssl 에서 check_crl 검사시 callback 호출이 있는데
    verify_cb_crl       이는 X509_STORE_CTX ctx 의 verify_cb 호출한다.


nginx 에서는 request 가 오면 ngx_ssl_create_connection 함수를 호출하여 connection (SSL) 을 생성



SSL_CTX     <-- SSL_CTX_new(SSLv23_method) 로 생성됨
    cert_store   <-- SSL_CTX_new 에서 호출되며 X509_STORE_new() 에 의해 할당

결론적으로 SSL_CTX 는 초기에 생성되기 때문에 SSL_CTX 생성 이후 , X509_STORE 에 X509_STORE_set_verify_cb 로 
Nginx callback 함수를 추가해주도록 한다.
    그러면, CRL  실패에 대한 정보를 얻을 수 있음.


정리 

SSL_CTX->cert_store 는 SSL_CTX_new 함수 내에서 X509_STORE_new() 에 의해 할당됨


1. running time 에서 ssl_verify_cert_chain 함수에서 X509_STORE_CTX 타입의 변수를 X509_STORE_CTX_new() 함수를 통해
   할당한다.

2. 이후 X509_STORE_CTX_init(ctx[1에서 생성된 변수], store) 가 수행 되면서 ctx 내부 맴버변수를 세팅한다.
    - store 는 SSL_CTX 에 있는 X509_STORE 타입의 변수이며 이는 SSL_CTX 초기 생성시 할당됨
    - X509_STORE_CTX_init 함수에서 ctx->verify_cb 에 store 에 있는 verify_cb 를 할당해준다. (여기 상속됨)




    


