---
layout: post
comments: true
---

# Headers

## A. *hop-by-hop* headers

- the headers which are meaningful only for a single transport-lavel connection, and not stored by caches or forwarded by proxies.
    - example headers
        - Connection
        - Keep-Alive
        - Public
        - Proxy-Authenticate
        - Transfer-Encoding
        - Upgrade

## B. *end-to-end* headers

- the headers which must be transmitted to the ultimate recipient of a request or response.
    - end-to-end headers in responses must be stored as part of a cache entry and transmitted in any
      response formed from a cache entry. (말단 끝에서 유용한 헤더들)
    - example headers
        - all other headers

