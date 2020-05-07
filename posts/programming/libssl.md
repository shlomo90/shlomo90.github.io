---
layout: post
comments: true
---

# libssl-dev 의존성

## A. 개요

- openssl 관련하여 개발하다보면, libssl-dev (ubuntu 버전) 또는 openssl-devel (Fedora 버전) 을 많이 경험하게  된다. 여기서보면, libssl-dev 은 흔히, `#include <openssl/xxx.h>` 해더파일을 사용할 수 있게 해주는 고마운 존재다. 

## B. 설치 방법

- 설치방법은 아래와 같다.
  - 아래 예제는 0.9.8 로 다운 그레이드하는 방법

```bash
    sudo apt-get install libssl-dev=0.9.8o-5ubuntu1.7 -y --force-yes
```

  - 본래 설치는 다음 명령을 수행한다. (ubuntu version)

```bash
    sudo apt-get install libssl-dev -y
```

## C. 참고 사항

  - openssl = binaries and tools
  - libssl-dev = development files and headers
  - libssl0.9.8 = actcual openssl libraries
