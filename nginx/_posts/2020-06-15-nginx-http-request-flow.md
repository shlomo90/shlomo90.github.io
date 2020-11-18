---
layout: post
tags: nginx programming request client http
comments: true
---

#### Doc Update

* 2020-11-18: format change
* 2020-06-15: init
<br/>
<br/>

# Nginx Request Flow

---

## Function based Flow

* Scope
  * Front getting Client HTTP request to sending the request to upstream real.

```
ngx_http_init_connection (ls->handler)
    | * args = ngx_connection_t
    | * update "c->data"
    |   - create ngx_http_connection_t structure and assign it to "c->data".
    | * update "c->log", c->read->handler, c->write->handler
    |   - c->read->handler = ngx_http_wait_request_handler
    |   - c->write->handler = ngx_http_empty_handler
    |   - if http2, c->read->handler = ngx_http_v2_init
    |   - if ssl, c->read->handler = ngx_http_ssl_handshake
    |
    |
    * (wait the event...)

ngx_http_ssl_handshake
 +->| ! handler state
 |  |   - c->read->handler = ngx_http_ssl_handshake
 |  |   - c->write->handler = ngx_http_empty_handler
 |  |
 |  |
 |  | * Do recv() to check SSL protocol versions
 |  | * Do ngx_ssl_create_connection
 |  |   - This connection is for SSL.
 |  * * Do ngx_ssl_handshake (OPENSSL Internal handshake starts)
  \/|   - after successfully handshake done, "c->ssl->handshaked" is set.
    |
    |
    | * handler changes
    |   - c->read->handler = ngx_http_wait_request_handler
    |   - c->write->handler = ngx_http_empty_handler /* STUB */
    |
    | * Do ngx_http_wait_request_handler
    |
    V


ngx_http_wait_request_handler
    | ! handler state
    |   - c->read->handler = ngx_http_wait_request_handler
    |   - c->write->handler = ngx_http_empty_handler
    |
    |
    | * Create buffer "c->buffer"
    | * Receive data from socket (Maybe Request Headers)
    * * Do "ngx_http_create_request" (Create ngx_http_request_t structure!)
    |\
    | | * r structure allocated
    | | * r->main_conf, r->srv_conf, r->loc_conf assigned
    | |   - This will be 
    | | * r->header_in = hc->busy[0] or c->buffer
    | |   - hc->busy is for HTTP pipelining.
    | | * r->headers_in.content_length_n, ... initialized
    |/ 
    |
    | * c->read->handler = ngx_http_process_request_line
    | * Do "ngx_http_process_request_line"
    V

ngx_http_process_request_line
 +->| ! handler state
E|  |   - c->read->handler = ngx_http_process_request_line
 |  |   - c->write->handler = ngx_http_empty_handler
A|  |
 |  | * Do "ngx_http_read_request_header"
G|  *   - Just Read data from socket and update "r->header_in"
 ^\/|
A|  |O
 |  |K
I|  |
 |  |
N|  * * Do "ngx_http_parse_request_line"
  \/|   - Read Just one Request Header line.
    |   - If result is EGAIN, and header_in buffer is full,
   O|     Do ngx_http_alloc_large_header_buffer.
   K|
    | * Do ngx_http_process_request_uri
    | * Do ngx_http_validate_host
    | * Do ngx_http_set_virtual_server
    | * Init "r->headers_in.headers" list.
    | * Handler changes
    |   - c->read->handler = ngx_http_process_request_headers
    | * Do ngx_http_process_request_headers
    V

ngx_http_process_request_headers
    | ! Handler State
    |   - c->read->handler = ngx_http_process_request_headers
    |   - c->write->handler = ngx_http_empty_handler
    |
 +->| (!: rev->handler is "ngx_http_process_request_headers")
E|  |
A|  | * ngx_http_read_request_header
G|  |   - recv data from socket and update "r->header_in->last"
A|  | * rc = ngx_http_parse_header_line
I|  |   - In this function, update "r->header_name_end", "r->header_start",
N|  |     "r->header_end", "r->header_hash"
 |  |  rc == PARSE_HEADER_DONE
 |  *-----------------------------------------+
 ^\/| * update "r->request_length"            | * update "r->request_length"
 |  | * Get a elem from r->headers_in.headers | * update "r->http_state"
 | O| * update "h->hash", "h->key", "h->value"| * do "ngx_http_process_request_header"
 | K|   - "h" means header.                   | * do "ngx_http_process_request(r)"
 |  | * find hash "r->header_hash"            |      (Next step)
 |  |   - do hash handler (headers_in)        |
 |  |   - See also "ngx_http_headers_in" var  |
  \/                                          |
                                             / 
    +---------------------------------------+
    |
    V

ngx_http_process_request
    |
    | * Do SSL relative logic. (SSL Detection, SSL Verify, etc.)
    | * Handler change
    |   - c->read->handler = ngx_http_request_handler
    |   - c->write->handler = ngx_http_request_handler
    |   - r->read_event_handler = ngx_http_block_reading
    |
    | * Do ngx_http_handler (Entry point)
    | * Do ngx_http_run_posted_requests
    |
    V

```
