<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />


## 1. Initialize Module Steps

Let's see how to initialize modules in nginx.

1. (ngx_preinit_modules) Update the `ngx_modules` name and index with `ngx_module_names`.
	- `ngx_module_names` and `ngx_modules` are pre-defined in compile time.

2. (ngx_init_cycle) Copy the `ngx_modules` to `cycle->modules`.

3. (ngx_init_cycle) (*create conf*) make module conf with `cycle->modules`.
    - do `create_conf` function each `cycle->modules`
	- set the cycle->conf_ctx[cycle->modules[i]->index] = `<created conf>`.

4. (ngx_init_cycle) Do `ngx_conf_param` function.
	- See below parsing block

5. (ngx_init_cycle) (*init conf*) Initialize each module conf.

6. (ngx_init_cycle) Create shared memory.

7. (ngx_init_cycle) Handle listening sockets.


### Parsing block

- When parsing block "http", "stream", etc. follow these:
	1. create context 'ctx' (ex. ngx_http_conf_ctx_t)
	2. allocate ctx->main_conf, ctx->srv_conf, ctx->loc_conf (not stream)
	3. do THE module's create_main_conf, create_srv_conf, create_loc_conf.
		- iterate all modules and check:
			1. is It itself module?
			2. Does it has create_main_conf, Do!
			3. Does it has create_srv_conf, Do!
			4. Does it has create_loc_conf, Do!
	4. Do preconfiguration if it has (module->preconfiguration)
	5. Keep parsing
	6. After parsing, do each module's `init_main_conf` if it has.
	7. Merge servers
	8. Init phases (?)
	9. Do postconfiguration if it has (module->post_configuration)
