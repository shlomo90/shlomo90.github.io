---
layout: post
tags: nginx programming
title: Nginx Initialization Flow
comments: true
---


#### Update Stamps

* 2020-11-11 Reorganize categories and "See also"
* 2020-11-05 Renewal (This article is separated)
* 2020-06-14 First written


---

# Init Nginx


* 목표
    * Nginx 초기화 순서를 이해한다.
        * Nginx 코드 분석을 하되, Top-Down 방식으로 진행

---


## Init Code Flow

아래 함수들은 `nginx.c` 의 main 문에서 순서대로 수행됩니다.

*ngx_get_options*
    * `nginx` 바이너리 수행 시 넘어오는 Argument 옵션 확인

*ngx_log_init*
    * Nginx 로그 구조체 초기화

*ngx_ssl_init*
    * Openssl 에서 제공하는 API 를 이용하여 SSL 관련 Library 초기화
    * Openssl 은 SSL 내부 구조체에 외부 프로그램 데이터를 저장할수
      있도록 인터페이스를 제공한다.
    * 자세한건 링크 https://www.openssl.org/docs/man1.1.1/man3/SSL_set_ex_data.html

*ngx_os_init*
    * 아래 OS 의존적인 전역 변수를 설정한다.
    * Page Size 
        * Slab Memory allocator 에서 사용
    * CPU Cacheline
    * Number of CPU

*ngx_add_inherited_sockets*
    * ??

*ngx_preinit_modules*
    * compile 시점에서 생성된 모듈 이름을 실제 running 타임에서 사용할 구조체에
      할당한다.

*ngx_init_cycle*
    * 각종 configuration 파일을 순회하면서 설정을 적용한다.
    * http, stream, engine, etc. 블럭들을 파싱


## Init cycle

* Nginx Cycle 의미
    * Nginx 는 프로그램이 시작되고, 종료될때 까지를 하나의 cycle
        * nginx (start) -> nginx (reload)
        * nginx (reload) -> nginx (quit or exit)
        * 기타 등등

* Nginx Cycle 에서 관리하는 것
    * Shared memory
    * Conf file path
        * 로그가 출력되는 파일들을 conf path 로 관리됨 (open_files)
    * Listening Sockets
        * listen directive 로 추가된 listening 소켓들을 관리
        * 모든 Client 의 요청들은 이 소켓의 Event 처리부터 시작된다.
    * Connections
        * Nginx 는 사용할 Connection 자원을 미리 할당합니다.


* 초기화
    * Nginx reload 경우, 기존 cycle 의 정보를 그대로 상속 받는다.
    * Nginx 최초 실행 시, `ngx_cycle` 변수하에 모두 메모리 할당.


## See also

* [Nginx Initialization module (core)](https://shlomo90.github.io/nginx/2020/06/14/nginx-init-module.html)
