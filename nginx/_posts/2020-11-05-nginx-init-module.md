
---
layout: post
tags: nginx programming
title: Nginx Initializtion (module)
comments: true
---

# Init Nginx Module

"Nginx Initialization (process)" 에서 이미 Init Cycle 과정까지 다루었다.
이번 과정에서는 Nginx 모듈이 어떻게 초기화되고 사용되는지 알아본다.

* Nginx 에서 설정되는 모듈 (대분류)
    * core
    * event
    * http
    * stream
    * engine
    * mail (여기서 다루지 않음)



## Parsing Configuration File

* Nginx Configuration 파싱은 *ngx_init_cycle* 내 *ngx_conf_param* 함수로부터 시작
* 이 글에서는 http, stream 모듈이 어떤식으로 초기화되는지에 대해서 알아본다.
* 파싱 로직은 이 글에서 다루지 않고, 후속 글에서 다룬다.

## core module

### core conf 생성

* core module 은 Nginx 에서 최상단에 위치하는 모듈이다. Nginx 프로세스 자체의 설정들에 대해
  설정이 가능한 Directive 들이 설정된다. (ex: worker_processes)
  * log, event, regex, http, stream, mail 모듈들이 core module 형식으로 정의된다.
* core module 형식을 가지는 모듈들은 *ngx_core_module_t* 구조체로된 *ctx* 를 가짐
    * 모듈 이름과 해당 모듈에서 사용할 "conf" 구조체를 생성 및 초기화하도록 하는 핸들러 선언
    * *create_conf*
    * *init_conf*
* 본격적인 Nginx Configuration 파일을 파싱하기 전에 Nginx 는 core module 형식을 가지는
  모듈들을 모두 순회하고, "conf" 를 생성한다.
* 이 후, Nginx Configuration 파일을 파싱하면서 각각의 Directive 설정들이 "conf" 안에 담긴다.

```c
typedef struct {
    ngx_str_t             name;
    void               *(*create_conf)(ngx_cycle_t *cycle);
    char               *(*init_conf)(ngx_cycle_t *cycle, void *conf);
} ngx_core_module_t;
```


### http block


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


## Merge

http block 파싱 시 http_ctx 는 main_conf, srv_conf, loc_conf 를 가짐
server block 파싱 시 ctx 가 새롭게 할당되고 이때 main_conf, srv_conf, loc_conf 도 다시 create_conf 작업을 수행
그러면 당연하게도 http_core_module 의 srv_conf 도 새롭게 할당되고 cscf 에 새롭게 할당한 ctx 추가
cscf 는 cmcf->server 에 리스트에 추가됨

여기까지 진행되면 http_ctx 와 각 서버별 ctx 는 따로 메모리 영역에 있음으로 각 서버별 ctx 들은 부모 http_ctx 의
설정을 상속 받아야한다. (단, 각 서버에 이미 설정되어있다면, 상속 받지 아니함 이미 있기에)

