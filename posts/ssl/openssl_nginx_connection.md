---
layout: post
comments: true
---

# Openssl with nginx

## Openssl Nginx SSL Connection

* Nginx creates the SSL Connection at `ngx_ssl_create_connection` function.
* This function is called at the first SSL init connection.
    * `ngx_http_upstream_ssl_init_connection` function.

~~~ c
ngx_connection_t

    ssl      -------------> ngx_ssl_connection_t
                                connection          ---->      ngx_ssl_conn_t(SSL)
                                session_ctx
                                last
                                ...
~~~

* `ngx_ssl_connection_t`'s `connection` value is assigned by `SSL_new` Openssl Function.
    * And then, Save the Nginx Connection `c` to `connection`'s ex_data `ngx_ssl_connection_index`. 
    * This means `connection` can access to `c` (nginx connection).
