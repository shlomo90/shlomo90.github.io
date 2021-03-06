---
layout: post
tags: nginx programming request client stream
comments: true
---

# Nginx Request Flow (stream module)

---

## Function based Flow

* Scope
  * from Client receives Request to Nginx proxies.

```
ngx_stream_init_connection (ls->handler)
    | ! handler state
    |   - c->read->handler = NULL;
    |   - c->write->handler = NULL;
    |
    | * s->signature = NGX_STREAM_MODULE
    | * s->main_conf = addr_conf->ctx->main_conf
    | * s->srv_conf = addr_conf->ctx->srv_conf
    | * s->ssl = addr_conf->ssl
    |
    | * handler changes
    |   - c->read->handler = ngx_stream_session_handler
    |
    | * Do ngx_stream_session_handler
    V

ngx_stream_session_handler
    |
    |
    | * Do ngx_stream_core_run_phases
    |
    V


ngx_stream_core_content_phase
    | ! handler state
    |   - c->read->handler = ngx_stream_session_handler
    |   - c->write->handler = NULL;
    |
    |
    | * cscf->handler (ngx_stream_proxy_handler)
    V

ngx_stream_proxy_handler (cscf->handler)
    |
    | * handler changes
    |   - c->write->handler = ngx_stream_proxy_downstream_handler;
    |   - c->read->handler = ngx_stream_proxy_downstream_handler;
    | * Do uscf->peer.init()
    | 
    | * Do ngx_stream_proxy_connect()
    V

ngx_stream_proxy_connect
    |
    | * update u->state (u = s->upstream)
    |
    | * Do ngx_event_connect_peer()
    |   - connect to upstream real.
    |
    | * update pc (u->peer.connection) 
    |   - pc->data, pc->pool, etc.
    |
    | * handler changes
    |   - pc->read->handler = ngx_stream_proxy_connect_handler;
    |   - pc->write->handler = ngx_stream_proxy_connect_handler;
    |
    | * Do ngx_stream_proxy_init_upstream() (if rc is not NGX_AGAIN)
    V

ngx_stream_proxy_init_upstream
    |
    * if ssl in use
    |\
    | | yes
    | | * Do ngx_stream_proxy_ssl_init_connection 
    | *
    | 
    | TODO: I am not interested non ssl right now.
    V 

ngx_stream_proxy_ssl_init_connection
    | ! handler state
    |   - pc->read->handler = ngx_stream_proxy_connect_handler;
    |   - pc->write->handler = ngx_stream_proxy_connect_handler;
    |
    | * Do ngx_ssl_create_connection()
    |
    * * Do ngx_ssl_handshake()
    |\  - After 
    ||\
    || + if NGX_AGAIN.
    || |  - pc->read->handler = ngx_ssl_handshake_handler
    || |  - pc->write->handler = ngx_ssl_handshake_handler
    || |  - pc->ssl->handler = ngx_stream_proxy_ssl_handshake
    || |    - This function run after handshake done.
    || *
    | \
    |  + if NGX_OK (handshaked)
    |  |  - pc->ssl->handhsaked = 1
    |  |  - pc->recv = ngx_ssl_recv
    |  |  - pc->send = ngx_ssl_write 
    |  |  - pc->recv_chain = ngx_ssl_recv_chain
    |  |  - pc->send_chain = ngx_ssl_send_chain
    |  +
    | / 
    |/
    +
    | - Do ngx_stream_proxy_ssl_handshake
    V

ngx_stream_proxy_ssl_handshake
    | ! handler state
    |   - pc->read->handler = ngx_ssl_handshake_handler
    |   - pc->write->handler = ngx_ssl_handshake_handler
    |   - pc->recv = ngx_ssl_recv
    |   - pc->send = ngx_ssl_write 
    |   - pc->recv_chain = ngx_ssl_recv_chain
    |   - pc->send_chain = ngx_ssl_send_chain
    |
    | * Check verify
    | * Save session if session reuse up.
    |
    *
    |\
    | \
    |  + if udp
    |  | * Do ngx_event_udp_accept(client connection)
    |  | * update u->downstream_buf
    |  +
    | /
    |/
    *
    | ngx_stream_proxy_init_upstream
    V
                
ngx_stream_proxy_init_upstream
    |
    |
    |
    |
    |
    |
    | * handler changes
    |   - pc->read->handler = ngx_stream_proxy_upstream_handler
    |   - pc->write->handler = ngx_stream_proxy_upstream_handler
    |
    | * Do ngx_stream_proxy_process 
    V
```
