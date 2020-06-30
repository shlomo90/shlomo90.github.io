---
layout: post
tags: nginx programming
title: Module Initializtion
comments: true
---

# Init Process

---

## 1. Core Module Initialization Steps

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


## 2. HTTP Module Initialization Steps

This starts from `ngx_conf_parse` in _ngx_init_cycle_. when parser meets 'http {', `ngx_conf_read_token(cf)`
returns `NGX_CONF_BLOCK_START` and no `cf->handler`. So, `ngx_conf_handler` is called.

1. _ngx_conf_handler_: Find module that has name 'http'.
  - `for(i = 0; cf->cycle->modules[i]; i++)`
    - Iterate all modules and get `cmd` (`cmd = cf->cycle->modules[i]->commands`)
  - `ngx_strcmp(name->data, cmd->name.data) != 0)`
  - `cf->cycle->modules[i]->type != NGX_CONF_MODULE && cf->cycle->modules[i]->type != cf->module_type`
    - `http` module's type is CORE_MODULE not HTTP_MODULE.
  - `conf = &(((void **) cf->ctx)[cf->cycle->modules[i]->index])`
    - Notice: `cf->ctx = cycle->conf_ctx`, `cf->cycle = cycle`.
    - Notice: `http` module doesn't do `create_conf` and `init_conf` so, `conf` has an address varaible
              having NULL value.
  - `rv = cmd->set(cf, cmd, conf)`
    - `cmd->set` is `ngx_http_block`
2. _ngx_http_block_: allocate `ngx_http_conf_ctx_t`
  - `ctx = ngx_pcalloc(cf->pool, sizeof(ngx_http_conf_ctx_t))`
  - `*(ngx_http_conf_ctx_t **) conf = ctx;`
    - `conf` had an address pointing variable having NULL.
    - Now, `conf` has a new address pointing `ngx_http_conf_ctx_t` structure variable.
3. _ngx_http_block_: counting http modules
  - `ngx_http_max_module = ngx_count_modules(cf->cycle, NGX_HTTP_MODULE)`
4. _ngx_http_block_: allocate main_conf, srv_conf, loc_conf
  - `ctx->main_conf = ngx_pcalloc(cf->pool, sizeof(void*) * ngx_http_max_module)`
  - `ctx->srv_conf = ngx_pcalloc(cf->pool, sizeof(void*) * ngx_http_max_module)`
  - `ctx->loc_conf = ngx_pcalloc(cf->pool, sizeof(void*) * ngx_http_max_module)`
5. _ngx_http_block_: iterate http module and create main_conf, srv_conf, loc_conf.
  - `module = cf->cycle->modules[m]->ctx`
  - `mi = cf->cycle->modules[m]->ctx_index`
  - `ctx->main_conf[mi] = module->create_main_conf(cf)`
    - if `module->create_main_conf` is not NULL.
  - `ctx->srv_conf[mi] = module->create_srv_conf(cf)`
    - if `module->create_srv_conf` is not NULL.
  - `ctx->loc_conf[mi] = module->create_loc_conf(cf)`
    - if `module->create_loc_conf` is not NULL.
