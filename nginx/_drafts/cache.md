


```
proxy_cache_path
  - takes path
  - generates 'cache' structure and fill it.

(ngx_http_file_cache_t)
cache <------------------------------------------------------------------------+
+---------------------------+                                                  |
|*path (ngx_path_t) ---------------> +-------------------+                     |
|                           |        | name (ngx_str_t) ---> '/test'           |
|*temp_path (ngx_path_t) ---------+  | len (size_t)      |                     |
|                           |     |  | level[]          ---> takes 1~3 hierarchy levels of path.
|                           |     |  | manager          ---> ngx_http_file_cache_manager
|*shm_zone (ngx_shm_zone_t) -----+|  | purger            |                     |
|                           |    ||  | loader            |                     |
|                           |    ||  |*data             ---> cache ------------+
| inactive (time_t)         |    ||  |*conf_file        ---> cf->conf_file->file.name.data;
| max_size (off_t)          |    ||  | line              |                     |
|                           |    ||  +-------------------+                     |
|                           |    ||                                            |
|                           |    |+> +-------------------+                     |
|                           |    |   | name (ngx_str_t) ---> '/temp/test       |
|                           |    |   | len (size_t)      |                     |
|                           |    |   | level[]          ---                    |
|                           |    |   | manager           |                     |
|                           |    |   | purger            |                     |
|                           |    |   | loader            |                     |
|                           |    |   |*data              |                     |
|                           |    |   |*conf_file         |                     |
|                           |    |   | line              |                     |
|                           |    |   +-------------------+                     |
|                           |    |                                             |
|                           |  +-+-> +-------------------+                     |
|                           |  |     |*data            -[3]> NULL (init) --> cache
|                           |  |     | shm               |
|                           |  |     | init            -[3]> NULL (init) --> ngx_http_file_cache_init
|                           |  |     |*tag             -[3]> &ngx_http_proxy_module
|                           |  |     | noreuse         -[3]> 0 (init)
| (ngx_http_file_cache_sh_t)|  |     +-------------------+
|*sh                      -------+
|*shpool (ngx_slab_pool_t)  |  | |
                               | |
                               | +-> +-------------------+
                               |     |rbtree             |
                               |     |sentinel           |
                               |     |queue            ----> inactive queue
                               |     |cold               |
                               |     |loading            |
                               |     |size               |
                               |     |count              |
                               |     |watermark          |
                               |     +-------------------+
                               |
                               |
                               |
ngx_http_upstream_conf_t plcf->upstream
+---------------------------+  |
|                           |  |
|*cache_zone              -----+
|*cache_value               |
| cache_lock                |
| cache:2                   |
+---------------------------+

focus arguments : levels, keys_zone, max_size, inactive
            keys_zone=zonename:size
    
ngx_conf_full_name()
  - takes cycle, name, conf_prefix
  - testing name is valid (lightly, just check starting with '/')
  - put the conf_prefix in front of name string. (concat)

ngx_add_path()
  - takes cf, new path.
  - check the new path is already added in cf->cycle->paths.
  - if not, add it.


3. ngx_shard_memory_add()
  - takes cf, name, size, tag
  - find the name's shared zone from cf->cyhcle->shared_memory.part list.
    - check name, and tag.
  - if not, add it



if proxy_cache is set, plcf->upstream.cache = 1.
if proxy_cache_path is set, 




```

```
memo

nginx_cache_path = /opt/k2/var/run/k2/nginx/cache


ngx_cache_manager_process_handler


child from master
    Do ngx_cache_manager_process_cycle (wating event)


Causes
  1. cache->sh->queue 
    - cache : /opt/k2/var/run/k2/nginx/cache/1
    - cache-sh->queue is initialized shm_init.

  2. if cache is set, Do ngx_http_upstream_cache

    if the request is first time, Do ngx_http_file_cache_new()
      - Make 'r->cache = malloc(ngx_http_cache_t)'
      - do u->create_key(r) "ngx_http_proxy_create_key()"
        - push "key (uri)" r->cache->keys
      - Do ngx_http_file_cache_create_key()
        - after u->create_key(r), all hashing..and make a key
        - r->cache->key is the hash value.
        - copy r->cache->key to c->main
      - u->cacheable = 1
        - Cache is init done, now, it's cachable.
      - Do ngx_http_test_predicates()
        - check this request need to be cached or bypass
      - c->lock = u->conf->cache_lock
      - c->lock_timeout = u->conf->cache_lock_timeout
      - c->lock_age = u->conf->cache_lock_age
      - u->cache_status = NGX_HTTP_CACHE_MISS
   
   Do ngx_http_file_cache_open()
     - check the file cache exists "ngx_http_file_cache_exists()"
       - if it's first time, the new fcn(file_cache_node) is generated.
       - cache->sh->count++ : corresponding to 'fcn'
       - fcn->key = c->key (r->cache->key)
       - Insert fcn->node to cache->sh->rbtree.
       - fcn->uses = 1
       - fcn->count = 1
       - return is NGX_DECLINED
       - fcn->expire = ngx_time() + cache->inactive (expire time)
       - r->cache->uniq = fcn->uniq
       - r->cache->error = fcn->error
       - r->cache->node = fcn
    - NGX_OK means there is an already cache (fcn)
    - NGX_DECLINED means there is no fcn so, new cache is generated

  Do ngx_http_file_cache_name()
    - namining c->file.name.

  Do ngx_http_file_cache_lock()
    - r->cache->node->updating = 1
    - r->cache->node->lock_time = now + r->cache->lock_age
    - r->cache->updating = 1
    - r->cache->lock_time = r->cache->node->lock_time
    - return NGX_DECLINED (if it's new)

  r->cached = 0



ngx_http_upstream_process_request()
  - when p->upstream_done
    - Do ngx_http_file_cache_update()
      - c->updated = 1
      - c->updating = 0
      - uniq = 0
      - rename p->temp_file to c->file.name (r->cache->file.name)
      - c->node->count--;
      - c->node->error = 0;
      - c->node->uniq = uniq
      - cache->sh->size += fs_size -c->node->fs_size
      - c->node->fs_size = fs_size
   !! if response is chunked, update many times until receiving all.



ngx_http_upstream_send_response()
    ...

    if u->cacheable is set
      check the file cache is valid.
    if it's valid
      Do ngx_http_file_cache_set_header()


```


```

----------------------------------------------------------------------------
ngx_http_file_cache_exists
  - can be looked up and c->node is null. (fcn->count++, fcn->uses++)
  - can not be looked up and generate fcn and insert cache->sh->rbtree, (fcn->uses = 1, count = 1)

ngx_http_file_cache_reopen
  - c->node->count--
  - remove c->node

ngx_http_file_cache_update_variant
  - c->node->count--
  - remove c->node
  - after that do ngx_http_file_cache_exists

ngx_http_file_cache_update
  - c->node->count--

ngx_http_file_cache_free
  - c->node->count--
  -after this, check fcn->exists and count is 0 and c->min_uses is 1, remove it. (c->node = null) 

  c->node->count 는 expire 시 0 인 경우 삭제됨

ngx_http_file_cache_delete   (count 가 0인경우에만 삭제)
  - if fcn->exists,fcn->deleting = 1
----------------------------------------------------------------------------
ngx_http_file_cache_exists
  - can be looked up and c->node is null. (fcn->count++, fcn->uses++)
  - can not be looked up and generate fcn and insert cache->sh->rbtree, (fcn->uses = 1, count = 1)

ngx_http_file_cache_add
  - if fcn not looked up, generate fcn and set fcn->uses = 1

----------------------------------------------------------------------------




c->node
fcn->count = 파일 cache 가 사용된 횟수 즉, c->node 에 fcn 이 할당된 횟수, update 이후 1 감소, free 시 감소
   fcn->count 가 0 이면 아예 삭제
fcn->uses = 파일 cache 를 처음 만들 때, exist 체크 시, 기존에 c->node 에는 없지만 새로 찾았더니 있던 fcn 이면 ++

cache->sh->count = 추가또는 로드된 cache 의 갯수

ngx_http_file_cache_loader
  set tree.file_handler = ngx_http_file_cache_manage_file
  Do ngx_walk_tree (tree, cache->path->name)
    - if cache->path->name is file, Do ngx_http_file_cache_manage_file
```

----------------


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

cache->sh is ngx_http_file_cache_sh_t. (shared memory)
cache->sh->count


ngx_http_file_cache_init  (shm_zone[i].init)
    |
    | * Allocate "cache->sh" from shared memory.
    | * cache->shpool->data = cache->sh
    | * RBTree init cache->sh->rbtree
    | * Queue init cache->sh->queue
    |
    | * cache->sh->cold = 1
    | * cache->sh->loading = 0
    | * cache->sh->count = 0
    |



ngx_http_upstream_cache
    |
    | * check previous cache (r->cache)
    |
    |
    |
    |

ngx_http_file_cache_new
    |
    | * Allocate "c" ngx_http_cache_t from process memory
    | * Array init "c->keys"
    | * r->cache = c
    |


