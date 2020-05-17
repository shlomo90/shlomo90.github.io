---
layout: post
comments: true
---

# Block Cipher

---

It is an ecryption method that applies a deterministic algorithm along with a **symmetric key** to
encrypt **a block of text**, rather than encrypting one bit at a time as in **stream ciphers**.

An example, `AES128` means encrypting **128 bit blocks** with a key of predetermined length: 128,
192, 256 bits.

## Block Cipher Modes

There are four block cipher modes.  

* CBC (cipher block chaining)
* CFB (cipher feedback)
* CTR (counter)
* GCM (Galois/Counter)

### GCM (Galois/Counter Mode)

![Alt text](/posts/ssl/pics/gcm_process.png)

GCM is a mode of operation for symmetric-key cryptographic block ciphers widely adopted thanks to
its performance. And it is defined for block ciphers with a block size of 128 bits.  

GCM mode provides both privacy(encryption) and integrity.

### CBC (Cipher Block Chaining)

1. Taking the current plain text and exclusive-oring that with the previous **ciphertext block**
2. Send the result of that through Block Cipher
3. Output of the Block Cipher is the **ciphertext block**.

#### What is the differences between GCM and CBC

* https://crypto.stackexchange.com/questions/2310/what-is-the-difference-between-cbc-and-gcm-mode

---

## References

1. [What is a block cipher?](https://www.wolfssl.com/what-is-a-block-cipher/)
2. [Check this 1](https://crypto.stackexchange.com/questions/17691/why-does-aes-gcm-need-a-hash-mac-in-tls)
3. [DH vs RSA](https://www.venafi.com/blog/how-diffie-hellman-key-exchange-different-rsa)
4. [RFC ref](https://tools.ietf.org/html/rfc5246#section-6.2.3.3)
