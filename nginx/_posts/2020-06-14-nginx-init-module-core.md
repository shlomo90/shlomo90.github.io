---
layout: post
tags: nginx programming
title: Nginx Initialization module (core)
comments: true
---

#### Update

* 2020-06-13 release
* 2020-11-15 update module
<br/>
<br/>

# Init Nginx Module

---

"Nginx Initialization (process)" 에서 이미 Init Cycle 과정까지 분석했고,
이번 과정에서는 Nginx 모듈이 어떻게 초기화되고 사용되는지 알아본다.

* Nginx 에서 설정되는 모듈 (대분류)
    * core
    * event
    * http
    * stream
    * engine
    * mail (여기서 다루지 않음)
<br/>
<br/>


## Parsing Configuration File

---

* Nginx Configuration 파싱은 *ngx_init_cycle* 내 *ngx_conf_param* 함수로부터 시작
* 이 글에서는 http, stream 모듈이 어떤식으로 초기화되는지에 대해서 알아본다.
* 파싱 로직은 이 글에서 다루지 않고, 후속 글에서 다룬다.
<br/>
<br/>


## Nginx Module

---

Nginx Module 은 기능에 대해서 탈부착이 가능하도록 되어있다. 기능을 사용하기 위해선
Nginx Build 시점에서 `Path` 설정이 필요합니다. `path` 설정 이후에는 빌드과정에서
`ngx_modules.c` 파일을 생성하는데, 이 파일에는 `extern` 형식을 각 모듈의 이름이
`ngx_module_t` 구조체 형식으로 선언만 되어있다. 각 모듈에 대한 정의는 모듈 파일에
정의됩니다.


Nginx Module 은 Hierarchy 를 가집니다. Nginx 가 초기 수행시에 `core` 모듈을
시작으로, 하부 모듈들을 초기화하기 시작합니다. 초기화 과정은 Nginx Configuration
파싱을 수행하면서 초기화하게 됩니다.
<br/>
<br/>

### Nginx Configuration Structure

---

Nginx Configuration 을 아래와 같은 Block 단위로 구성이 됩니다.

```
# 초기 core 모듈 영역


http {
    # http 모듈 영역

    server {
        location {
        }
    }
}

stream {
    #stream 모듈 영역

    server {
    }
}
```


`stream` 모듈은 `http` 모듈과 다르게 location 을 가지지 않습니다. 추측컨대,
`stream` 모듈은 L4 layer 에서 구동되기에 L7 영역인 Location 이 필요 없습니다.


Nginx 는 Nginx Configuration 파일을 파싱하기 전에 `core` 모듈을 먼저 초기화
하는 작업을 진행하고, 이후, 각각의 `http`, `stream` 블럭을 만나게 될 경우
해당 모듈에 대해서 초기화 하는 작업을 수행합니다.
<br/>
<br/>

### ngx_modules.c 파일

---

앞서 설명과 같이, 빌드 시점에서 생성되는 `ngx_modules.c` 파일은 사용되는
모듈들의 구조체를 `ngx_modules` 라는 `ngx_module_t` 구조체 배열로 관리합니다.
<br/>
<br/>

### ngx_module_t 구조체

---

구조체 정의는 아래와 같습니다.

```c
struct ngx_module_s {
    ngx_uint_t            ctx_index;
    ngx_uint_t            index;

    char                 *name;

    ngx_uint_t            spare0;
    ngx_uint_t            spare1;

    ngx_uint_t            version;
    const char           *signature;

    void                 *ctx;
    ngx_command_t        *commands;
    ngx_uint_t            type;

    ngx_int_t           (*init_master)(ngx_log_t *log);

    ngx_int_t           (*init_module)(ngx_cycle_t *cycle);

    ngx_int_t           (*init_process)(ngx_cycle_t *cycle);
    ngx_int_t           (*init_thread)(ngx_cycle_t *cycle);
    void                (*exit_thread)(ngx_cycle_t *cycle);
    void                (*exit_process)(ngx_cycle_t *cycle);

    void                (*exit_master)(ngx_cycle_t *cycle);

    uintptr_t             spare_hook0;
    uintptr_t             spare_hook1;
    uintptr_t             spare_hook2;
    uintptr_t             spare_hook3;
    uintptr_t             spare_hook4;
    uintptr_t             spare_hook5;
    uintptr_t             spare_hook6;
    uintptr_t             spare_hook7;
};
```

`index` 는 `ngx_preinit` 과정에서 전체 모듈에 대한 순차적으로 index 를 부여받는다.  
`ctx_index` 는 `http`, `stream` 등 파싱 시점에서 `ngx_count_modules` 함수 수행 시,
할당 받습니다.

* `index`
    * Core module 에서 쓰이는 것으로 보임
* `ctx_index`
    * http, stream 등에서 쓰이는 것으로 보임
* `ctx`
    * 해당 모듈에서 쓰이는 conf, name 이 명시됩니다.
* `command`
    * 해당 모듈에서 쓰이는 Directive 들이 명시
<br/>
<br/>

### core module

---

`core` module 은 Nginx 에서 가장 최 상단에 위치하는 모듈이다. `core` 모듈에서
파생된 모듈들 (`http`, `stream`, etc.) 을 관리하며, Nginx 서버 운용에 필요한
것들을 담고 있다.
<br/>
<br/>

### core conf 생성

---

기본적으로 모듈을 
core module 형식을 가지는 모듈 (`http`, `stream`, etc.) 들은
*ngx_core_module_t* 구조체로된 *ctx* 를 가집니다.
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
