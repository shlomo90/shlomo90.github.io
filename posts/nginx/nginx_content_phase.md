---
layout: post
comments: true
---

# Nginx Content Phase

## HTTP Phases

* 12 types http content phases
    1. NGX_HTTP_POST_READ_PHASE
    2. NGX_HTTP_SERVER_REWRITE_PHASE
    3. NGX_HTTP_FIND_CONFIG_PHASE
    4. NGX_HTTP_REWRITE_PHASE
    5. NGX_HTTP_POST_REWRITE_PHASE
    6. NGX_HTTP_PREACCESS_PHASE
    7. NGX_HTTP_ACCESS_PHASE,
    8. NGX_HTTP_POST_ACCESS_PHASE,
    9. NGX_HTTP_TRY_FILES_PHASE,
    10. NGX_HTTP_PRECONTENT_PHASE,
    11. NGX_HTTP_CONTENT_PHASE,
    12. NGX_HTTP_LOG_PHASE

* 7 types stream content phases
    1. NGX_STREAM_POST_ACCEPT_PHASE
    2. NGX_STREAM_PREACCESS_PHASE
    3. NGX_STREAM_ACCESS_PHASE
    4. NGX_STREAM_SSL_PHASE
    5. NGX_STREAM_PREREAD_PHASE
    6. NGX_STREAM_CONTENT_PHASE
    7. NGX_STREAM_LOG_PHASE
 

### *ngx_http_init_phases* function.

* *ngx_http_init_phases* Call trace

```
ngx_http_block()
    <-- Each module's create_main_conf -->
    <-- Each module's create_srv_conf  -->
    <-- Each module's create_loc_conf  -->
    <-- Each module's preconfiguration() -->

    <-- Keep parsing under "http" block -->

    <-- Each module's init_main_conf() + ngx_http_merge_servers() -->

    <-- Each servers' ngx_http_init_locations() + ngx_http_init_static_location_trees() -->

    ngx_http_init_phases()

    <-- Each module's postconfiguration() -->

    ...
```

* Jobs
    * Initialize Nginx variable *cmcf->phases[INDEX].handler*.
        * *cmcf->phases* is *ngx_http_phase_t* type array.
        * Each *INDEX* is defined enumeration *ngx_http_phases*.
        * *handler* variable type is *ngx_array_t*.
    * That is, Array init Nginx array.

### *ngx_http_init_phase_handlers* function.

* *ngx_http_init_phase_handlers* Call trace

```
ngx_http_block()

    ... 중략 ...

    ngx_http_init_phases()

    <-- Each module's postconfiguration() -->
    <-- ngx_http_variables_init_vars() -->

    ngx_http_init_phase_handlers()

    ... 중략 ...
```

* Jobs
    * Allocate and Assign *cmcf->phase_engine.handlers*

```
cmcf->phases[x].handlers     +-----------------------------+
    |NGX_HTTP_POST_READ_PHASE|NGX_HTTP_SERVER_REWRITE_PHASE|NGX_HTTP_FIND_CONFIG_PHASE|NGX_HTTP_REWRITE_PHASE|
                             |(ngx_http_core_rewrite_phase)|
                             +-----------------------------+
                                           ^
                                           | ph->checker 
+------------------------------------------+
|
|   +------------------------+-----------------------------+------------------------+------------------------+
|   |cmcf->phases[x].handlers|cmcf->phases[x].handlers     |cmcf->phases[x].handlers|cmcf->phases[x].handlers|
|   +-----------|------------+-------------|----------------+------------------------+------------------------+
|               |                          |
|               |                          |    +-------+-------+
|               |                          +--> |handler|handler|
|               |                               +---^---+---^---+
|               |                                   |       |
|               |                      (ph->handler)|       +-+ (ph++->handler)
|               |   +-------+-------+-------+---+   +----+    |
|               +-->|handler|handler|handler|...|        |    |
|                   +-------+-------+-------+---+        |    |
+-----+--------------------------------------------------+    |
      |     +-------------------------------------------------+
    +-|--+--|-+----+----+----+----+    
    | ph0| ph1| ph2| ph | ph |....|        <-- cmcf->phase_engine.handlers
    +-|--+----+----+----+----+----+
      |
      ph->next = 2

```

* Notice!
    1. The zero index of 'ph' has *NGX_HTTP_SERVER_REWRITE_PHASE*'s handler.
       Because there is no *NGX_HTTP_POST_READ_PHASE*'s handlers.
    2. *cmcf->phases[NGX_HTTP_SERVER_REWRITE_PHASE].handlers* is *ngx_http_rewrite_handler*.

### Usage of *cmcf->phase_engine.handlers*

When a request comes, *ngx_http_process_request_line* function is called.
It's the start entry of parsing client's request.

* Call Trace to the function using *cmcf->phase_engine.handlers*.

```
ngx_http_process_request_line    (rev->handler set ngx_http_process_request_headers)
done

ngx_http_process_request_headers            
    ngx_http_process_request            <-- if HEADER Parse Done
        ngx_http_handler                (c->read->handler = ngx_http_request_handler
                                        (c->write->handler = ngx_http_request_handler
                                        (r->read_event_handler = ngx_http_block_reading

            ngx_http_core_run_phases    (r->write_event_handler = ngx_http_core_run_phases
```

* When it reaches to *ngx_http_core_run_phases* function, Run *ph's checker*.
    * examples checkers = `ngx_stream_core_preread_phase` for NGX_STREAM_PREREAD_PHASE
    * examples checkers = `ngx_stream_core_content_phase` for NGX_STREAM_CONTENT_PHASE
    * examples checkers = `ngx_stream_core_gerneric_phase` for default
    * NOTICE!
        * Only If handlers are, it's added in `ph`.
* *r->phase_handler is assigned before call *ngx_http_core_run_phases*. (See the below code.)
    * if request 'r' is internal, *r->phase_handler* is *cmcf->phase_engine.server_rewrite_index*.
    * otherwise, *r->phase_handler* is 0.

```c
void
ngx_http_core_run_phases(ngx_http_request_t *r)
{
    ngx_int_t                   rc;
    ngx_http_phase_handler_t   *ph;
    ngx_http_core_main_conf_t  *cmcf;

    cmcf = ngx_http_get_module_main_conf(r, ngx_http_core_module);

    ph = cmcf->phase_engine.handlers;

    while (ph[r->phase_handler].checker) {

        rc = ph[r->phase_handler].checker(r, &ph[r->phase_handler]);

        if (rc == NGX_OK) {
            return;
        }
    }
}
```

* In the *check function*, it calls itself's handler.

```c
ngx_int_t
ngx_http_core_rewrite_phase(ngx_http_request_t *r, ngx_http_phase_handler_t *ph)
{
    ngx_int_t  rc;

    ngx_log_debug1(NGX_LOG_DEBUG_HTTP, r->connection->log, 0,
                   "rewrite phase: %ui", r->phase_handler);

    rc = ph->handler(r);    //<--------------------------This

    if (rc == NGX_DECLINED) {
        r->phase_handler++;
        return NGX_AGAIN;
    }

    if (rc == NGX_DONE) {
        return NGX_OK;
    }

    /* NGX_OK, NGX_AGAIN, NGX_ERROR, NGX_HTTP_...  */

    ngx_http_finalize_request(r, rc);

    return NGX_OK;
}
```

* As you can see this code, After one phase handler finished, do next phase handler.

## Extra

### Usage of Each PHASE

* NGX_STREAM_POST_ACCEPT_PHASE
    * ngx_stream_realip_module.c
* NGX_STREAM_PREACCESS_PHASE
    * ngx_stream_limit_conn_module.c
* NGX_STREAM_ACCESS_PHASE
    * ngx_stream_access_module.c
* NGX_STREAM_SSL_PHASE
    * ngx_stream_ssl_module.c
* NGX_STREAM_PREREAD_PHASE
    * ngx_stream_ssl_preread_module.c
* NGX_STREAM_CONTENT_PHASE
    * default....
* NGX_STREAM_LOG_PHASE
    * ngx_stream_log_module.c
