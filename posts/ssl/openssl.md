---
layout: post
comments: true
---

# Openssl

---

* Perform an analysis of openssl code and how to work.

## Purpose

1. Understand OPENSSL Structure
2. Make a program using openssl for TLS/SSL.

## Introduction

* Openssl is the open source for encrypt connection to protect End to End user information.
* Why we need to study this Openssl? because the security is getting important in internet.
* Let's be a professional export for Openssl.


---

## Index

1. [Versioning](./openssl_version.md)
2. [Data Structure](./openssl_SSL.md)
3. [Issues](./openssl_issues.md)
4. [Init](./openssl_init.md)
5. [Method](./openssl_method.md)
6. [Nginx Connection](./openssl_nginx_connection.md)
7. [i2d and d2i](./openssl_i2d_d2i.md)


## DrawIO

See the below link.  
[link][1]


[1]: https://www.draw.io/?lightbox=1&highlight=0000ff&nav=1&title=openssl.drawio#Uhttps%3A%2F%2Fdrive.google.com%2Fuc%3Fid%3D1ZRzsjQkChZ1PicHW3h2apNBo4vZ6AP8_%26export%3Ddownload


---

SSL Handshake Protocol
SSL Record Layer Protocol
    Breaking Down the data from application layers, with fixed length
    Compression Data
    Add Message Authentication Code, which is calculated with the help of integrity Key.
    Encrypt the packets(which was broken down with fixed length)
