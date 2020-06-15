
ngx_http_core_content_phase
    call r->content_handler (ngx_http_proxy_handler)


ngx_http_add_location
    - created clcf 


cf->ctx->loc_conf[ngx_http_core_module.ctx_index]->locations  is queue (q)
    1. alloc ngx_http_location_queue_t (lq)
    2. init lq->list
    2. insert lq tail to q


ngx_http_init_listening
    alloc hport.
    ls->servers = hport


    ls->servers = 



ngx_http_block (cf, cmcf, cmcf->ports)
    cmcf->ports is added ngx_http_add_listen

    each cmcf->ports "port" 's default_server = 


1. listen directive
    - do ngx_http_add_listen(cf, cscf, lsopt)
      - cscf is passed the default "conf"
    
2. ngx_http_add_listen
    - create ports array.
    - each port do ngx_http_add_addreses(cf, cscf, &port[i], lsopt)
    - and final step is do ngx_http_add_address

3. ngx_http_add_addresses
    - each port's addrs "addr"'s opt has the default_server

4. ngx_http_add_address(cf, cscf, port, lsopt)
    - each port's addrs "addr" initialized
    - addr has the default_server = cscf.

---------------------------



scrum
    - evolving versions
    - scrum test board
    daily scrum meeting.
sprint
    - work sort cycle.
    - team 
    - we'll have 

        product backlog 

