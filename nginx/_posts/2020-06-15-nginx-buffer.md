---
layout: post
tags: nginx programming buffer
title: Nginx Buffer Structure
comments: true
---

#### Doc Update

* 2020-11-18: Format change
* 2020-06-15: init
<br/>
<br/>

# Nginx Buffer System

---

<br/>
<br/>

## Buffer Meta Data

---

<details><summary>ngx_buf_t Structure</summary>
<p>

```c
struct ngx_buf_s {
    u_char          *pos;
    u_char          *last;
    off_t            file_pos;
    off_t            file_last;

    u_char          *start;         /* start of buffer */
    u_char          *end;           /* end of buffer */
    ngx_buf_tag_t    tag;
    ngx_file_t      *file;
    ngx_buf_t       *shadow;


    /* the buf's content could be changed */
    unsigned         temporary:1;

    /*
     * the buf's content is in a memory cache or in a read only memory
     * and must not be changed
     */
    unsigned         memory:1;

    /* the buf's content is mmap()ed and must not be changed */
    unsigned         mmap:1;

    unsigned         recycled:1;
    unsigned         in_file:1;
    unsigned         flush:1;
    unsigned         sync:1;
    unsigned         last_buf:1;
    unsigned         last_in_chain:1;

    unsigned         last_shadow:1;
    unsigned         temp_file:1;

    /* STUB */ int   num;
};
```
</p></details>

* Nginx Buffer Concept
    * 데이터를 읽고, 소비하기까지의 Buffer 이다.

* Ngind Buffer Working
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
