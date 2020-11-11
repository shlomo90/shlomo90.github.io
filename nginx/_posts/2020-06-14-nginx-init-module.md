---
layout: post
tags: nginx programming
title: Nginx Initialization module (core)
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
