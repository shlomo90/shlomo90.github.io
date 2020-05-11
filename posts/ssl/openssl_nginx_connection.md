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


## Openssl Nginx Session

* `ngx_ssl_new_session` function does generate new session with openssl API.
* `ngx_ssl_new_session(ngx_ssl_conn_t *ssl_conn, ngx_ssl_session_t *sess)`
    * `ngx_ssl_conn_t` is `SSL` structure.
    * `ngx_ssl_session_t` is `SSL_SESSION` structure.
* `cached_sess`
    * it's in shared memory area.
* Allocate `cached_sess` and `sess_id` from shared memory area and initialize them
    * `sess_id->session` is assigned to `cached_sess`.
    * `sess_id` is queued in `shm_zone->data`.


* `ngx_http_ssl_merge_src_conf` function is called and set the openssl callback function to inform nginx
    * we can take the advantage of it for counting statistics.
    * callback functions
        * There are callback functions if `shm_zone` is set.
        * `new_cb`: `ngx_ssl_new_session`
        * `get_cached_session`: `ngx_ssl_get_cached_session`
        * `remove_cb`: ngx_ssl_remove_session
