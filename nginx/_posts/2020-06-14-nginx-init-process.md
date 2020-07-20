---
layout: post
tags: nginx programming
title: Nginx Module Initializtion
comments: true
---

# Init Process

---

## Core Module Initialization Steps

1. _ngx_preinit_modules_: update each `ngx_modules[i]`.
  - `ngx_modules[i]->index = i`
  - `ngx_modules[i]->name = ngx_module_names[i]`
  - `ngx_modules_n = i`
  - `ngx_module_names` are pre-defined in compile time in `objs` directory.
2. _ngx_init_cycle_: allocate `cycle->conf_ctx`
  - `cycle->conf_ctx = ngx_pcalloc(pool, ngx_max_module * sizeof(void*))`
3. _ngx_cycle_modules_: allocate `cycle->modules`
  - `cycle->modules = ngx_pcalloc(cycle->pool, (ngx_max_module + 1) * sizeof(ngx_module_t*))`
  - `cycle->modules_n = ngx_modules_n`
  - `ngx_memcpy(cycle->modules, ngx_modules, ...)`
4. _ngx_init_cycle_: create core type module's conf 
  - `rv = module->create_conf(cycle)`
    - e.g, regex module, `module` is `ngx_regex_module_ctx` NOT `ngx_regex_module` variable.
      - create list of `ngx_pcre_studies` static variable
        and allocate `ngx_regex_conf_t` and return
  - `cycle->conf_ctx[cycle->modules[i]->index] = rv`
    - `rv` is void*. each module's conf has own data structure.
5. _ngx_init_cycle_: initialize core type module' conf
  - `module->init_conf(cycle, cycle->conf_ctx[cycle->modules[i]->index])`
    - e.g, regex module, `ngx_regex_init_conf(ngx_cycle_t *cycle, void *conf)`.
      - `conf` is casted `ngx_regex_conf_t` that was created by number 4 step.

Now, the core modules are initialized. core modules have `create_conf`, `init_conf` functions.

```c
typedef struct {
    ngx_str_t             name;
    void               *(*create_conf)(ngx_cycle_t *cycle);
    char               *(*init_conf)(ngx_cycle_t *cycle, void *conf);
} ngx_core_module_t;
```


Actually before step 5, `ngx_conf_parse` is run and parses the nginx config. Maybe the parser meets
`http` or `stream` block and handles each module. See more.


## HTTP Module Initialization Steps

This starts from `ngx_conf_parse` in _ngx_init_cycle_. when parser meets 'http {', `ngx_conf_read_token(cf)`
returns `NGX_CONF_BLOCK_START` and no `cf->handler`. So, `ngx_conf_handler` is called.

1. _ngx_conf_handler_: Find module that has name 'http'.
  * `for(i = 0; cf->cycle->modules[i]; i++)`
    * Iterate all modules and get `cmd` (`cmd = cf->cycle->modules[i]->commands`)
  * `ngx_strcmp(name->data, cmd->name.data) != 0)`
  * `cf->cycle->modules[i]->type != NGX_CONF_MODULE && cf->cycle->modules[i]->type != cf->module_type`
    * `http` module's type is CORE_MODULE not HTTP_MODULE.
  * `conf = &(((void **) cf->ctx)[cf->cycle->modules[i]->index])`
    * Notice: `cf->ctx = cycle->conf_ctx`, `cf->cycle = cycle`.
    * Notice: `http` module doesn't do `create_conf` and `init_conf` so, `conf` has an address varaible
              having NULL value.
  * `rv = cmd->set(cf, cmd, conf)`
    * `cmd->set` is `ngx_http_block`
  * NOTICE!
    * the explanation of below code.

```
if (cmd->type & NGX_DIRECT_CONF) {
    conf = ((void **) cf->ctx)[cf->cycle->modules[i]->index];   // (void**)cf->ctx ==> cf->ctx->main_conf

} else if (cmd->type & NGX_MAIN_CONF) {
    conf = &(((void **) cf->ctx)[cf->cycle->modules[i]->index]); // &(void**)cf->ctx ==> &cf->ctx->main_conf

} else if (cf->ctx) {
    confp = *(void **) ((char *) cf->ctx + cmd->conf);  //*(void **)((char *) cf->ctx + cmd->conf) 
                                                            ==> cf->ctx + 8 (or 16 or 24).
    if (confp) {
        conf = confp[cf->cycle->modules[i]->ctx_index];
    }
}

// enable func 실행
rv = cmd->set(cf, cmd, conf);

```
2. _ngx_http_block_: allocate `ngx_http_conf_ctx_t`
  * `ctx = ngx_pcalloc(cf->pool, sizeof(ngx_http_conf_ctx_t))`
  * `*(ngx_http_conf_ctx_t **) conf = ctx;`
    * `conf` had an address pointing variable having NULL.
    * Now, `conf` has a new address pointing `ngx_http_conf_ctx_t` structure variable.
3. _ngx_http_block_: counting http modules
  * `ngx_http_max_module = ngx_count_modules(cf->cycle, NGX_HTTP_MODULE)`
4. _ngx_http_block_: allocate main_conf, srv_conf, loc_conf
  * `ctx->main_conf = ngx_pcalloc(cf->pool, sizeof(void*) * ngx_http_max_module)`
  * `ctx->srv_conf = ngx_pcalloc(cf->pool, sizeof(void*) * ngx_http_max_module)`
  * `ctx->loc_conf = ngx_pcalloc(cf->pool, sizeof(void*) * ngx_http_max_module)`
5. _ngx_http_block_: iterate http module and create main_conf, srv_conf, loc_conf.
  * Allocate confs (main, srv, loc)
    * `module = cf->cycle->modules[m]->ctx`
      * Ex. *ngx_http_module_ctx*
      * 'm' is module index.
    * `mi = cf->cycle->modules[m]->ctx_index`
    * `ctx->main_conf[mi] = module->create_main_conf(cf)`
      * if `module->create_main_conf` is not NULL.
      * It also creates http core module's main conf `cmcf`.
        * In `ngx_http_core_create_main_conf`, Allocate `cmcf->servers`
    * `ctx->srv_conf[mi] = module->create_srv_conf(cf)`
      * if `module->create_srv_conf` is not NULL.
    * `ctx->loc_conf[mi] = module->create_loc_conf(cf)`
      * if `module->create_loc_conf` is not NULL.
  * Run preconfiguration
    * call each module's `preconfiguration` fuction.
  * Before Do `ngx_conf_parse`
    * `cf->ctx = ctx`
  * Do `ngx_conf_parse`.
    * Find http directives in HTTP block and handle them.
    * HTTP core must have `server` directive. when parser meets it, add cmcf->servers
  * Run module's **init_main_conf** and **ngx_http_merge_servers()**.


```
+----+----+----+----+----+----+----+----+
| M1 | M2 | M3 | M4 | M5 | M6 | .. | MN |
+----+----+----+----+----+----+----+----+

+-------------------------------+
|   ctx (ngx_http_conf_ctx_t)  ----+  (http block)
+-------------------------------+  |
|           ...                 |  |
+-------------------------------+<-+
|   main_conf                  ----+  <-------------+
+-------------------------------+  |                |
|   srv_conf                   ----|--+             |
+-------------------------------+  |  |             |
|   loc_conf                   ----|--|--+          |
+-------------------------------+  |  |  |          |
|           ...                 |  |  |  |          |
+-------------------------------+<-+  |  |          |
|   http module 1's main_conf   |     |  |          |
|   (e.g, ngx_http_core_module) +-----------+       |
+-------------------------------+     |  |  |       |
|   http module 2's main_conf   |     |  |  |       |
+-------------------------------+     |  |  |       |
|           ...                 |     |  |  |       |
+-------------------------------+     |  |  |       |
|   http module n's main_conf   |     |  |  |       |
+-------------------------------+     |  |  |       |
|           ...                 |     |  |  |       |
+-------------------------------+<----+  |  |       |
|   http module 1's srv_conf    |        |  |       |
|   (e.g, ngx+http_core_module)------------------------------> cscf->ctx ---+
+-------------------------------+        |  |       |              
|   http module 2's srv_conf    |        |  |       |              
+-------------------------------+        |  |       |              
|           ...                 |        |  |       |              
+-------------------------------+        |  |       |              
|   http module n's srv_conf    |        |  |       |              
+-------------------------------+        |  |       |              
|           ...                 |        |  |       |              
+-------------------------------+<-------+  |       |              
|   http module 1's loc_conf    |           |       |              
+-------------------------------+           |       |              
|   http module 2's loc_conf    |           |       |              
+-------------------------------+           |       |              
|           ...                 |           |       |              
+-------------------------------+           |       |              
|   http module n's loc_conf    |           |       |              
+-------------------------------+           |       |              
|           ...                 |           |       |              
+-------------------------------+<----------+       |              
|   server[0] (_core_srv_conf_t)------------------------->ctx----------+
+-------------------------------+                   |                  |
|   server[1] (_core_srv_conf_t)|                   |                  |
+-------------------------------+                   |                  |
|   server[2] (_core_srv_conf_t)|                   |                  |
+-------------------------------+                   |                  |
|   server[3] (_core_srv_conf_t)|                   |                  |
+-------------------------------+                   |                  |
|           ...                 |                   |                  |
+-------------------------------+ (server block)    |                  |
|   ctx (ngx_http_conf_ctx_t)  -----+---+---+       | <------------+<--+
+-------------------------------+<--+   |   |       |              |    
|   main_conf                  ---------|---|-------+              |    
+-------------------------------+<------+   |       ^              |    
|   srv_conf                   -------+     |       |              |    
+-------------------------------+<----|-----+        \             |    
|   loc_conf                   -------|--+            \       cscf->ctx 
+-------------------------------+     |  |            |            |    
|           ...                 |     |  |            |            |         
+-------------------------------+<----+ <------------------+       |      
|   http module 1's srv_conf  -------------------------------------+ 
+-------------------------------+        |            |    |
|   http module 2's srv_conf    |        |            |    |
+-------------------------------+        |            |    |
|           ...                 |        |            |    |
+-------------------------------+        |            |    |
|   http module n's srv_conf    |        |            |    |
+-------------------------------+        |            |    |
|           ...                 |        |            |    |
+-------------------------------+<-------+            |    |
|   http module 1's loc_conf    |                     |    |
+-------------------------------+                     |    |
|   http module 2's loc_conf    |                     |    |
+-------------------------------+                     |    |
|           ...                 |                     |    |
+-------------------------------+                     |    |
|   http module n's loc_conf    |                     |    |
+-------------------------------+                     |    |
|           ...                 |                     |    |
+-------------------------------+                     |    |
|   ctx (ngx_http_conf_ctx_t)  -----+ (location block)|    |
+-------------------------------+<--+                 |    |
|   main_conf                  -----------------------+    |
+-------------------------------+                          |
|   srv_conf                   ----------------------------+
+-------------------------------+
|   loc_conf                   -------+
+-------------------------------+     |
|           ...                 |     |
+-------------------------------+<----+
|   http module 1's loc_conf    |
+-------------------------------+
|   http module 2's loc_conf    |
+-------------------------------+
|           ...                 |
+-------------------------------+
|   http module n's loc_conf    |
+-------------------------------+

즉, ngx_http_merge_servers 는 각각 산발된 server, location 설정 값들은
main <- server <- location 순으로 머지해나가는 것.
최종적으로는 core 의 main 에서의 설정들이 각 server 로 merge 됩니다.
참고로, 각 모듈별로만 merge 가 된다.
http <-> server : ngx_http_merge_servers 함수에서 server 의 설정이 http 의 server 로 덮어씌어짐
server <-> locaion : location 블럭에서 파싱한 location 에 대해서...
```
