---
layout: post
comments: true
---

# Openssl

* Perform an analysis of openssl code and how to work.

## Purpose

1. Understand OPENSSL Structure
2. Make a program using openssl for TLS/SSL.

## Introduction

* Openssl is the open source for encrypt connection to protect End to End user information.
* Why we need to study this Openssl? because the security is getting important in internet.
* Let's be a professional export for Openssl.


---


## 1. Openssl versioning

* Versions prior to 0.9.3
	* 0xMMNNFFRBB (M: Major, N: Minor, F: Fix, R: Final B: beta/patch)
* Versions after 0.9.3
	* 0xMNNFFPPS (M: Major, N: Minor, F: Fix, P: Patch, S: Status)
	* The **status** nibble has one of the values *0 for development*, *1 to e for betas*, *f for release*.
* Macro OPENSSL_VERSION_NUMBER, OPENSSL_VERSION are defined.


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
