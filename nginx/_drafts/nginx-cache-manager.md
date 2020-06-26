```
### Cache manager Processing ####

ngx_cache_manager_process_cycle
    |
    | * ev.handler = ctx->handler = ngx_cache_manager_process_handler
    | * ev.data = ident (garbage)
    | * ev.log = cycle->log
    | * Do ngx_setproctitle()
    | * Do ngx_add_timer(ev, delay)
    |   - Do ngx_rbtree_insert(&ngx_event_timer_rbtree, ev->timer)
  +>|
  | |
  | | * ngx_process_events_and_timers(cycle)
  | |
  +-+



ngx_process_events_and_timers
    |
    | ...
    | * Do ngx_process_events()
    |   - check events from epoll_wait and do handling.
    | * Do ngx_event_process_posted
    | * Do ngx_event_expire_timers()
    |   - check the cache timer expired.
    | * Do ngx_event_process_posted
    |
    *

ngx_event_expire_timers
    |
    | * Searching RBTree node expired
    | * Do ev->handler
    |   - cache: ev->handler: ngx_cache_manager_process_handler
    |
    |
    *
ngx_cache_manager_process_handler
    |
    | 
  +>* * for (i = 0; i < ngx_cycle->paths.nelts; i++)
  | |
  | | * Do path[i]->manager(path[i]->data) if path[i]->manager is set
  | |   - path[i]->data = (ngx_http_file_cache_t)cache
  | |   - path[i]->manager = ngx_http_file_cache_manager
  | |   - return is "n" msec.
  | |   - Set "next = (n <= next) ? n : next;
  | |     - default "next" is 3600초
  | |     - find the smallest time from each paths.
  | |   - Do ngx_time_update()
  +-+
    | * Do ngx_add_timer(ev, next)
    |
    *

ngx_http_file_cache_manager
    |
    | * update cache->last = ngx_current_msec
    |   - ngx_current_msec is updated by ngx_time_update()
    |
    | * Do ngx_http_file_cache_expire(cache)
    |   - The return is "next" timer
    +
    |\
    | \
    |  +
    |  | if "next" timer is 0, return "cache->manager_sleep"
    |  * 
    |
  +>* for (;;)
  | |
  | | * Do ngx_http_file_cache_forced_expire(cache)
  | |   - The return "wait"
  | * * return 
  | |\
  | | \
  | |  + * if (wait > 0) return wait * 1000
  | |  | * if ngx_quit || ngx_terminate return next * 1000
  | |  | * if cache->files >= cache->manager_files return cache->manager_sleep
  | |  | * if elapsed >= cache->manager_threshold return cache->manager_sleep
  | |  *
  +-+
ngx_http_file_cache_expire
    |
  +>* for (;;)
  | |
  | * if ngx_quit || ngx_terminate return 1 (wait)
  | * if &cache->sh->queue is empty return 10 (wait)
  | * the last queue from &cache->sh->queue is not expired return (wait)
  | |  
  | | * Get the ngx_http_file_cache_node_t "fcn" from the last queue.
  | |
  | | * Do ngx_http_file_cache_delete() if fcn->count == 0.
  | * if fcn->deleting return 1 (wait)
  | | 
  | | * remove the queue from &cache->sh->queue
  | | * insert the queue to &cache->sh->queue's head.
  | | 
  | * if cache->files >= cache->manager_files return 0 (wait)
  | | 
  +-+ 

ngx_http_file_cache_forced_expire()
    |
  +>* for from last of &cache->sh->queue to head
  | |
  | | * Do ngx_http_file_cache_delete(cache, q, name) if fcn->count == 0
  | | * else decrese tries (from 20)
  | * if tries is zero return 1(wait)
  | |
  +-+
```

```

```
