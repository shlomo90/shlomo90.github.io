---
layout: post
comments: false
---

# Cipher Suite

---

## Purpose

1. I can understand what the meaning of cipher suite string.
2. I can understand why the cipher suite concent is used.

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

---

## References

* [Cipher Suites Wiki](https://en.wikipedia.org/wiki/Cipher_suite)
