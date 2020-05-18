---
layout: post
comments: false
---

# Cipher Suite

---

## Purpose

1. I can understand what the meaning of cipher suite string.
2. I can understand why the cipher suite concent is used.
3. I can understand what `cipher list` is.

## Naming Scheme (Structure)

```
TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
```

`TLS` defines the protocol that this cipher suite is for.  

`ECDHE_RSA` indicates the *key exchange algorithm* being used. The key exchange algorithm is used to determine
if and how the client and server will authenticate during the handshake. `RSA` indicates that the algorithm of
*authentication* Client or Server will use.  

`AES_128_GCM` indicates the *block cipher* being used to encrypt the message stream, together with the block
cipher mode of operation. In here, `GCM` is the block cipher mode of operation.
[More Information](./block_ciphers.md)

`SHA256` indicates the *message authentication algorithm* which is used to authenticate a message.


## Cipher List Format

`Cipher List` consists of one or more cipher strings separated by colons. For example, The meaning
of `SHA1+DES` Cipher list is all ciphers using `SHA1` Message Authentication Code and `DES` Block
Cipher to encrypt message stream.  

Each cipher string can be optionally preceded by the characters `!`, `-`, `+`.  
(한국말로 표현하면, `!`, `-`, `+` 이 `cipher string` 보다 먼저 온다는 것)  

`+` means combined in a single cipher string (logical AND operation). This example is already showed
above.  

`!` means the cipher permanently deleted from the cipher list. Even though you explicitly use the
cipher string already marked `!`, It's not taken.  

`-` means the cipher are deleted from the list, but different to `!` it's not permanently deleted.
The ciphers marked `-` can be add again by later options.  

`+` means the cipher are moved to **the end of the list**. It seems like *cipher list* has the
priority.  

## Cipher Strings

Below the list is permitted cipher string.

`ALL` : all ciphers suites except the eNULL ciphers which must be explicitly enabled.  

`HIGH` : "high" encryption cipher suites. This currently means those with key lengths larger than 128  

`MEDIUM` : cipher suites currently thoes using 128 bit encryption  

`LOW` : cipher suites currently thoes using 64 or 56 bit but EXCLUDING export cipher  

`RSA` : cipher suites using RSA key exchange  

---

## References

* [Cipher Suites Wiki](https://en.wikipedia.org/wiki/Cipher_suite)
