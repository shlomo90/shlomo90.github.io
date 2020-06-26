---------------------------------------------
ngx_http_upstream_process_expires() 함수에서
r->cache->valid_sec = expires   <-- header 기준
---------------------------------------------

300 이상 에러 응답시
  ngx_http_upstream_intercept_errors 함수를 수행

  ngx_http_file_cache_valid 함수를 수행하여  valid 가 설정된게 있다면, 해당 응답코드가 r->cache->error 로 저장
  이는 ngx_http_file_cache_free 함수에서 fcn->error 로 저장


proxy_cache_min_uses is the number of requests after which the response will be cached.

no used:
    proxy_cache_bypass

"cookie_" variable handles in ngx_http_variable_cookie
"proxy_cache_bypass": checking the headers (request) and make decision bypassing.
"proxy_no_cache": checking the headers (request + response) and make decision bypassing





ngx_http_proxy_process_status_line
    200/300/....

    200 인 경우

    ngx_http_upstream_process_headers

https://www.nginx.com/blog/nginx-caching-guide/



!! proxy_cache depends on proxy_buffering !!



vary http header
- this header is for content negotiation using the accept, accept-language and accept-encoding
- depends on accept header
- the server tells us that Accept header is important like this.
  - Vary: Accept
  - This response varies based on the value of the accept header of your request
  -

client --------------------->  Nginx  ----------------------------> origin server
                                     <-----------------------------
    +---------------+                  +--------------------------+
    |GET / HTTP/1.1 |                  |HTTP/1.1 200 OK           |
    |Host: test     |                  |Content-Length: 8365      |
    |               |                  |Cache-Control: max-age=864|
    +---------------+                  |**Vary: Accept-Encoding** |
                                       +--------------------------+

                        +---------------------------------------------------------------------------------
                        ! caching.
                        ! Vary header is noted.
                        !   - "Only to be used for requests that have no Accept-Encoding in the request"
                        +---------------------------------------------------------------------------------

                        do ngx_http_file_cache_set_header
                          - do ngx_http_file_cache_vary
                            - find request headers matched with vary's values and do md5 hashing + main key.
                            - save the result in ngx_http_file_cache_header_t -> variant.
                              - This variable is used for checking the future request header matches previous request whoes response was cached.



HTTP/1.1 200 OK
Content-Length: 8365
Cache-Control: max-age=86400


nginx
let's say there is "vary: header1,header2" header from response
1. find each header1, header2 from headers_in.
2. md5sum found header's values and appended.
3. finalize md5 hashing and the result goes c->variant.




keys
    key: $uri$is_arg$args
    key: $uri$is_arg$args
    key: $uri$is_arg$args
    key: $uri$is_arg$args
    key: $uri$is_arg$args
    key: $uri$is_arg$args
    key: $uri$is_arg$args
    key: $uri$is_arg$args
    key: $uri$is_arg$args




ngx_http_file_cache_vary_header:
    Add main key to raw md5 material
    iterate request header and find the header key matched by vary values.
      - the values go to add to md5 raw material     <-- kinda snapshoot.




variant mismatch:   (check previous fcn's variant that was from response's vary header.

    - ngx_http_file_cache_reopen




---


ref

https://www.smashingmagazine.com/2017/11/understanding-vary-header/
https://www.fastly.com/blog/best-practices-using-vary-header
https://www.nginx.com/blog/nginx-caching-guide/
