---
layout: post
comments: true
---

# Nginx Status Module

---

## Code Analysis

* the code below.

```
ngx_status_module_init

ngx_status_conf_t
    conf = cycle->conf_ctx[ngx_status_module.index]

               //each module
conf->counters[ngx_modules[i]->index]

 +-
 v
|  |  |  |  |  |  |  |  |



c is conf->counters[ngx_modules[i]->index]
c->counter->accumulate has shared memory pointer
c->counter->windows
c->counter->sec


void**** cycle->conf_ctx


cycle->conf_ctx

    | module 1 | void *** ... | module 2 | void *** ... | ... | module n | void *** ... |

    in status (module number x)

    | module x | ngx_status_conf_t *        |




   process 1
|
|  cycle pool -> |                                      |
|                   ^
|                   +-- ngx_status_conf_t                   // each module...
|                           |counters           ->          | ngx_status_list_t | ngx_status_list_t |...|   |
|                           |count(nchild)                      |accumulate     --> shared
|                           |other vars..                       |windows
|                                                               |sec
|

   process 2
|
|  cycle pool -> |                                      |
|                   ^
|                   +-- ngx_status_conf_t
|

   process 3
|
|  cycle pool -> |                                      |
|                   ^
|                   +-- ngx_status_conf_t
|

   process 4
|
|  cycle pool -> |                                      |
|                   ^
|                   +-- ngx_status_conf_t
|

```
