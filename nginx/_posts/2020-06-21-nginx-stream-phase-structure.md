---
layout: post
tags: nginx programming request client stream structure
comments: true
---

# Stream Phase Structure

---

## PHASE Handler and Checker Init

* Steps
  1. Do _ngx_steram_init_phases_ (init array of phases)
  2. Each module post_configuration init (in _ngx_stream_block_)
  3. Do _ngx_stream_init_phase_handler_ (mapping phase and checker)

### 1. Do _ngx_stream_init_phases_

First, Initialize each phases' array.

```
cmcf+--------------------+
    |                    |
    ...                ...
    |                    | 
    +--POST_ACCEPT_PHASE-+ handler
    |void       *elts    |
    |ngx_uint_t  nelts   |
    |size_t      size    |
    |ngx_uint_t  nalloc  |
    |ngx_pool_t *pool    |
    +--PRE_ACCESS_PHASE--+ handler
    |void       *elts    |
    |ngx_uint_t  nelts   |
    |size_t      size    |
    |ngx_uint_t  nalloc  |
    |ngx_pool_t *pool    |
    +-ACCESS_PHASE-------+ handler
    |void       *elts    | 
    |ngx_uint_t  nelts   |
    |size_t      size    |
    |ngx_uint_t  nalloc  |
    |ngx_pool_t *pool    |
    +--------------------+
    ...                ...
    +--------------------+

```

###  2. Each module post_configuration init (in _ngx_stream_block_)

Each module does its own jobs at the specific phase. Phases can have multiple
handlers with _ngx_array_t_ structure. The below figure shows how to add a handler
each module.

```
cmcf+--------------------+
    |                    |
    ...                ...
    |                    | 
    +--POST_ACCEPT_PHASE-+ handler
    |void       *elts  --------------+
    |ngx_uint_t  nelts   |           |
    |size_t      size    |           |
    |ngx_uint_t  nalloc  |           |
    |ngx_pool_t *pool    |           |
    +--PRE_ACCESS_PHASE--+ handler   |
    |void       *elts  ----------------+
    |ngx_uint_t  nelts   |           | |
    |size_t      size    |           | |
    |ngx_uint_t  nalloc  |           | |
    |ngx_pool_t *pool    |           | |
    +-ACCESS_PHASE-------+ handler   | |
    |void       *elts    |           | | 
    |ngx_uint_t  nelts   |           | |
    |size_t      size    |           | |
    |ngx_uint_t  nalloc  |           | |
    |ngx_pool_t *pool    |           | |
    +--------------------+           | |
    ...                ...           | |
    +--------------------+           | |
                                     | |
     ngx_stream_handler_pt           | |
    +--------------------+ <---------+ |
    |h = ngx_stream_realip_handler     |
    +--------------------+             |
                                       |
     ngx_stream_handler_pt             |
    +--------------------+ <-----------+
    |h = ngx_stream_limit_conn_handler
    +--------------------+
```

### 3. Do _ngx_stream_init_phase_handler_ (mapping phase and checker)

After pushing handlers, Map the phases' checker and handler.
The checker function is an entry point function of the phase. In checker function,
Do run array pushed handlers in order and if the handler returns NGX_OK, Go to
next Phase step. if the handler return NGX_DECLINED, Do the next pushed handler
function. (Like giving another change to handle)

 
The below figure explains how to work of phases and handlers 

```
cmcf+--------------------+
    |                    |
    ...                ...
    |                    | 
    +--POST_ACCEPT_PHASE-+ handler
    |void       *elts  --------------+
    |ngx_uint_t  nelts   |           |
    |size_t      size    |           |
    |ngx_uint_t  nalloc  |           |
    |ngx_pool_t *pool    |           |
    +--PRE_ACCESS_PHASE--+ handler   |
    |void       *elts  ----------------+
    |ngx_uint_t  nelts   |           | |
    |size_t      size    |           | |
    |ngx_uint_t  nalloc  |           | |
    |ngx_pool_t *pool    |           | |
    +-ACCESS_PHASE-------+ handler   | |
    |void       *elts    |           | | 
    |ngx_uint_t  nelts   |           | |
    |size_t      size    |           | |
    |ngx_uint_t  nalloc  |           | |
    |ngx_pool_t *pool    |           | |
    +--------------------+           | |
    ...                ...           | |
    |                    |           | |
    +--------------------+           | |
    | *handler       --------+       | |
    +--------------------+   |       | |
    |                    |   |       | |
    ...                ...   |       | |
    +--------------------+ <-+       | |    +--+
    |checker = ngx_stream_core_generic_phase   |
  +--handler             |           | |       | POST_
  | |next = 2 (num of handlers)      | |       | ACCEPT
  | +--------------------+           | |       | _PHASE
  | |checker = ngx_stream_core_generic_phase   |
+----handler             |           | |       |
| | |next = 2            |           | |       |
| | +--------------------+           | |    +--+
| | |checker             |           | |       | PRE_
| | |handler             |           | |       | ACCESS
| | |next                |           | |       | _PHASE
| | +--------------------+           | |    +--+
| | |                    |           | |
| | |                    |           | |
| | |                    |           | |
| | +--------------------+           | |
| |                                  | |
| |  ngx_stream_handler_pt           | |
| +>+--------------------+ <---------+ |
|   |h = ngx_stream_realip_handler     |
+-->+--------------------+             |
    |h = ngx_something_else            |
    +--------------------+             |
                                       |
     ngx_stream_handler_pt             |
    +--------------------+ <-----------+
    |h = ngx_stream_limit_conn_handler
    +--------------------+
```

The _next_ is for junping next phase (e.g: POST_ACCEPT_PHASE -> PRE_ACCESS_PHASE).
