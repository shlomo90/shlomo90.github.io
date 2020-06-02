# 성능 측정

## 관련 자원

* 성능 측정용 Window 자원: 192.168.220.72
* 가능한 성능 측정 장비
  * C100
  * C100MP
  * XT80

## C100MP

* Spirent TestCenter Layer 4-7 Application 4.43
  * Version: Avalanche 4.43 Build 1126
  * NOTICE: 프로그램이 java 에러가 날 수 있는데 다시 실행하면, 정상으로 동작.


## XT80

* IxLoad 6.10.0.1253 EA


## 테스트 방식

먼저, 무엇을 테스트할것인지에 대한 계획을 세우는게 좋다. 아래는 테스트 계획 일부이다.

```
Test 1:
    Firmware        : XXX 
    Nginx           : Not SSL Stat applied
    Notice          : No License sets the 500cps limit.
    Target Service  : something...
    Setting:
        SSL:
            cipher      : AES256-SHA (General)
            RSA Key     : 2048
            backend-ssl : disable
            session-reuse: disable
        Server:
            Max.Requests/Conn: 64
            response bodysize: 1byte
            Maximum Requests Per Connection: 50
        protocol    : TCP
        simusers    : 2000
        client port : Xg1
        server port : Xg2
    Result:
        1. First test result
            CPS Max: 8520
            CPS Min: 8300
        2. Second 
            CPS Max: 8625
            CPS Min: 8280

Test 2:
    Firmware        : XXX 
    Nginx           : SSL Stat applied
    Notice          : No License sets the 500cps limit.
    Target Service  : Something...
    Setting:
        cipher      : AES256-SHA (General)
        RSA Key     : 2048
        Maximum Requests Per Connection: 50
        simusers    : 2000
        client port : Xg1
        server port : Xg2
        protocol    : TCP
        session-reuse: disable
        backend-ssl : disable
        Server:
            Max.Requests/Conn: 64
            response bodysize: 1byte
    Result:
        1. First test result
            CPS Max: 8500
            CPS Min: 8284
        2. Second 
            CPS Max: 8624
            CPS Min: 8359

Test 3:
    Firmware        : XXX 
    Nginx           : Not SSL Stat applied
    Notice          : No License sets the 500cps limit.
    Target Service  : Something...
    Setting:
        SSL:
            cipher      : AES256-SHA (General)
            RSA Key     : 2048
            backend-ssl : disable
            session-reuse: disable
        Server:
            Max.Requests/Conn: 64
            response bodysize: 1byte
            Maximum Requests Per Connection: 50
        protocol    : TCP
        simusers    : 2000
        client port : Xg1
        server port : Xg2
    Result:
        1. First test result
            CPS Max: 9150
            CPS Min: 8750
        2. Second 
            CPS Max: 9000
            CPS Min: 8760

Test 4:
    Firmware        : XXX 
    Nginx           : SSL Stat applied
    Notice          : No License sets the 500cps limit.
    Target Service  : Something...
    Setting:
        cipher      : AES256-SHA (General)
        RSA Key     : 2048
        Maximum Requests Per Connection: 50
        simusers    : 2000
        client port : Xg1
        server port : Xg2
        protocol    : TCP
        session-reuse: disable
        backend-ssl : disable
        Server:
            Max.Requests/Conn: 64
            response bodysize: 1byte
    Result:
        1. First test result
            CPS Max: 9000
            CPS Min: 8568
        2. Second 
            CPS Max: 8925
            CPS Min: 8600
```

위 테스트는 간단하게 nginx 성능 테스트를 하기위함이다. 우리는 사람이기에 실수할 수있음으로 테스트 명세서를
작성하고 이에 Double Check 하여 테스트를 진행하도록 하자.














