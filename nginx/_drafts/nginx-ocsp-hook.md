# Nginx Client OCSP and Request Hook

---

## Comparing what I've implemented ICAP and Client OCSP

Nginx has man subrequest functions like resolver. when I implemented ICAP, I was frustrated because
I had no idea to find the hooking point. Nowadays, Nginx 1.19.0 released and There are client OCSP
validation in it. When I saw that, I was astonished. if you have a plan to develop like ICAP or improve,
you should have reference of OCSP.


In Nginx 1.19.0, Client OCSP validation starts after finishing SSL Handshake Which means OPENSSL doesn't
check the Client certificates during Handshake. So, We may agree that Checking Client certificate is not
in charge of Handhsake. After Handhsaking, if the client certificate is not valid, Close the Connection.


## The Flow of Client OCSP implemented

About Implementation

1. After handshake, Resolving the OCSP URL that is in AIA Field (Guessing...) and, Do resolving the URL.
2. After resolving the url, Create OCSP Context (ctx) and connect to the IP (resolved).
  - It also uses the Nginx Connection Resource So, handlers for events should be set.
3. OCSP Checking.... (See also, ngx_ssl_ocsp_handler function).
4. After Checking OCSP Done, Call the original ssl handler `c->ssl->handler`.
  - the function `ngx_http_upstream_ssl_handshake_handler`. (follow the original business logic)
