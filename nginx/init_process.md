<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />


## init process steps.

Let's check the init process of nginx.

### 1. ngx_preinit_modules

1. ngx_preinit_modules
	- update the `ngx_modules` name and index  with `ngx_module_names`.
	- `ngx_module_names` and `ngx_modules` are pre-defined in compile time.

### 2. ngx_init_cycle

2. copy the `ngx_modules` to `cycle->modules`

3. (*create conf*) make module conf with `cycle->modules`.
    - do `create_conf` function each `cycle->modules`
	- set the cycle->conf_ctx[cycle->modules[i]->index] = `<created conf>`.

4. parsing (ngx_conf_param)
	- See below parsing block

5. (*init conf*) Initialize each module conf

6. create shared memory

7. handle listening sockets.


### Parsing block

- When parsing block, "http", "stream", etc. do this
	1. create context 'ctx' (ex. ngx_http_conf_ctx_t)
	2. allocate ctx->main_conf, ctx->srv_conf, ctx->loc_conf (not stream)
	3. do THE module's create_main_conf, create_srv_conf, create_loc_conf.
		- iterate all modules and check:
			1. It's itself module?
			2. it has create_main_conf, Do!
			3. it has create_srv_conf, Do!
			4. it has create_loc_conf, Do!
	4. Do preconfiguration if it has (module->preconfiguration)
	5. Keep parsing
	6. After parsing, do each module's `init_main_conf` if it has.
	7. Merge servers
	8. Init phases (?)
	9. Do postconfiguration if it has (module->post_configuration)
