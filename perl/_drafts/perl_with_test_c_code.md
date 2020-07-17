---
layout: post
tags: nginx programming
title: Nginx Module Initializtion
comments: true
---

# Perl for Testing C Code

---

## Need to know

* cpan
  * Code library.
* prove
  * run tests through a TAP harness.

## Prerequisite

* cpan installed
* nginx installed (from source)

## How to use the *.t file in Nginx

1. Install *Test::Nginx*

```
$ sudo cpan Test::Nginx
```

2. Set the Nginx Binary PATH to env PATH.

```
$ export PATH=/home/hwan/src/nginx/objs:$PATH
```

3. Make 't' directory.
4. Write test perl file in 't' directory. (with 755 permission)

```perl
#!/usr/bin/perl -w

use Test::Nginx::Socket;

repeat_each(2);
plan tests => repeat_each() * 3 * blocks();

no_shuffle();
run_tests();

__DATA__

=== TEST 1: sanity
--- config
    location /echo {
        return 100;
        #echo_before_body hello;
        #echo world;
    }
--- request
    GET /echo
--- response_body
--- error_code: 100
```

5. Run the perl file

```
$ ./t/test_file.t
```


## References

* https://metacpan.org/pod/Test::Tutorial
  * This is so basic tutorial. you can find how to write the perl test with "Test" module.
