---
layout: post
tags: nginx programming
title: Nginx Initialization (process)
comments: true
---

#### Update Stamps

* 2020-06-14 First written
* 2020-11-05 Renewal (This article is separated)


---

# Init Nginx


Nginx 가 초기화하면서 어떤 순서로 Configuration 설정이 읽어지고, 세팅되는지
이해하도록 한다.
먼저, 코드 흐름을 설명하고, 세부적인 내용으로 들어가 상세 설명하는 방식인 
Top-Down 방식으로 진행한다.


---


## Init Code Flow

* 시간별 함수 수행
    * `nginx.c`
        * *ngx_get_options*
            * `nginx` 바이너리 수행 시 넘어오는 Argument 옵션 확인
        * *ngx_log_init*
            * Nginx 로그 구조체 초기화
        * *ngx_ssl_init*
            * Openssl 에서 제공하는 API 를 이용하여 SSL 관련 Library 초기화
            * Openssl 은 SSL 내부 구조체에 외부 프로그램 데이터를 저장할수
              있도록 인터페이스를 제공한다.
            * 자세한건 링크 https://www.openssl.org/docs/man1.1.1/man3/SSL_set_ex_data.html
        * *ngx_os_init*
            * 아래 OS 의존적인 전역 변수를 설정한다.
            * Page Size 
                * Slab Memory allocator 에서 사용
            * CPU Cacheline
            * Number of CPU
        * *ngx_add_inherited_sockets*
            * ??
        * *ngx_preinit_modules*
            * compile 시점에서 생성된 모듈 이름을 실제 running 타임에서 사용할 구조체에
              할당한다.
        * *ngx_init_cycle*
            * 각종 configuration 파일을 순회하면서 설정을 적용한다.
            * http, stream, engine, etc. 블럭들을 파싱


## Init cycle

* Nginx 는 프로그램이 시작되서 종료될때 까지를 하나의 cycle 로 본다.
    * nginx (start) -> nginx (reload)
    * nginx (reload) -> nginx (quit or exit)
    * 기타 등등
* Nginx reload 경우, 기존 cycle 의 정보를 그대로 상속 받는다.
* cycle 에서 관리되는 것들
    * Shared memory
    * Conf file path
        * 로그가 출력되는 파일들을 conf path 로 관리됨 (open_files)
    * Listening Sockets
        * listen directive 로 추가된 listening 소켓들을 관리
        * 모든 Client 의 요청들은 이 소켓의 Event 처리부터 시작된다.
    * Connections
        * Nginx 에서 사용되는 Connection 구조체는ㅗ
* Configuration Parsing
    * Cycle Initialization 에서 가장 중요한 것은 Nginx Configuration 파일 파싱 과정이다.
      여기서 다루지 않고 후속 Posting 에서 다루도록 한다.


