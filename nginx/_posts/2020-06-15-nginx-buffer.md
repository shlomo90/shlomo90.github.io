---
layout: post
tags: nginx programming buffer
comments: true
---

# Nginx Buffer System

---

## Buffer Meta Data

```
start           pos                  last                    end                       
+---------------+--------------------+-----------------------+
|               |                    |                       |
| Parsed Data   | Data to be parsed  | Empty buffer space    |
|               |                    |                       |
+---------------+--------------------+-----------------------+
```

* start <-> pos
  * currently nginx read (parsing)
* start <-> last
  * received data from socket
* start <-> end
  * total buffer size (fixed ususally)
* pos <-> last
  * the length of data to be parsed more
* last <-> end
  * It's empty space in buffer.

Nginx uses buffer system in many cases like `r->header_in`, chain, etc.
This buffer's structure is named `ngx_buf_t`.
