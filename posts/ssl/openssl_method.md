---
layout: post
comments: true
---

# Openssl Method

* Openssl has many methods like SSLv3, TLS1.1, ...
* Openssl covers these methods with macro function `IMPLEMENT_tls_meth_func`.

## IMPLEMENT_tls_meth_func macro function

* First, it is defined `ssl/ssl_locl.h` file.
* This function get `version`, `flags`, `mask`, `func_name`, `s_accept`, `s_connect`, `enc_data`

```c
# define IMPLEMENT_tls_meth_func(version, flags, mask, func_name, s_accept, \
                                 s_connect, enc_data) \
const SSL_METHOD *func_name(void)  \
        { \
        static const SSL_METHOD func_name##_data= { \
                version, \
                flags, \
                mask, \
                tls1_new, /*ssl_new*/\
                tls1_clear, /*ssl_clear*/\
                tls1_free, /*ssl_free*/\
                s_accept, /*ssl_accept*/ /*usually ossl_statem_accept*/\
                s_connect, /*ssl_connect*/ /*usually ossl_statem_connect*/\
                ssl3_read, /*ssl_read*/\
                ssl3_peek, /*ssl_peek*/\
                ssl3_write, /*ssl_write*/\
                ssl3_shutdown, \
                ssl3_renegotiate, \
                ssl3_renegotiate_check, \
                ssl3_read_bytes, \
                ssl3_write_bytes, \
                ssl3_dispatch_alert, \
                ssl3_ctrl, \
                ssl3_ctx_ctrl, \
                ssl3_get_cipher_by_char, /*get_cipher_by_char*/ \
                ssl3_put_cipher_by_char, /*put_cipher_by_char*/\
                ssl3_pending, \
                ssl3_num_ciphers, /*num_ciphers*/\
                ssl3_get_cipher, /*get_cipher*/\
                tls1_default_timeout, /*get_timeout*/\
                &enc_data, /*ssl3_enc*/\
                ssl_undefined_void_function, /*ssl_version*/\
                ssl3_callback_ctrl, \
                ssl3_ctx_callback_ctrl, \
        }; \
        return &func_name##_data; \
        }
```

* `func_name` is the method name (ex:SSLv23_method, SSLv23_server_method, ...)
    * TLS_method is the same with SSLv23_method.
* So, the `func_name` is defined at compile time and this function return `func_name##_data` value.
    * `##` is to concatenate two strings around `##`.

