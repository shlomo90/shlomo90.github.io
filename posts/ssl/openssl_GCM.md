---
layout: post
comments: true
---

# GCM (Galois/Counter Mode)

---

* Before understanding the GCM, we need to know about many terminologie.

## Block cipher

* is an encryption method that applies a deterministic algorithm along with a **symmetric key** to
  encrypt a block of text, rather than encrypting one bit at a time as in stream ciphers
* Example, `AES128` means encrypting 128 bit blocks with a key of predetermined length: 128, 192, 256 bits
* Modes
    * CBC (cipher block chaining)
    * CFB (cipher feedback)
    * CTR (counter)
    * GCM (Galois/Counter)

### CBC

1. Taking the current plain text and exclusive-oring that with the previous **ciphertext block**
2. Send the result of that through Block Cipher
3. Output of the Block Cipher is the **ciphertext block**.


### GCM

* ![Alt text](/posts/ssl/pics/gcm_process.png)

* is a mode of operation for symmetric-key cryptographic block ciphers widely adopted thanks to its performance.
* is defined for block ciphers with a block size of 128 bits.

* GCM mode provides both privacy(encryption) and integrity.
See Below
https://crypto.stackexchange.com/questions/2310/what-is-the-difference-between-cbc-and-gcm-mode
https://crypto.stackexchange.com/questions/17691/why-does-aes-gcm-need-a-hash-mac-in-tls

DH vs RSA
https://www.venafi.com/blog/how-diffie-hellman-key-exchange-different-rsa

RFC ref
https://tools.ietf.org/html/rfc5246#section-6.2.3.3

