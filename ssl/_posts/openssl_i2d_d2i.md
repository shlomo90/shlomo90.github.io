---
layout: post
comments: false
---

# i2d and d2i

---

* **d2i_TYPE()** attempts to decode len bytes at *ppin.*
* **i2d_TYPE()** encodes the structure pointed to by a into DER format.
* letter `i` and `d` in `i2d_TYPE()` stands for "interal" (that is an internal C structure) and "DER" respectively

* `i2d_SSL_SESSION`
    * defined at `ssl/ssl_asn1.ckj`
    * need `cipher/cipher_id`

    * Generate local ASN1 structure `as` initialise it and call `i2d_SSL_SESSION_ASN1(as, pp)`
        * `pp` is the output pointer.
    * NOTICE
        * `i2d_SSL_SESSION_ASN1` function is defined  at `ssl/ssl_asn1.c`.
        * Check `IMPLEMENT_STATIC_ASN1_ENCODE_FUNCTIONS(SSL_SESSION_ASN1)`

* `ssl_session_oinit(ASN1_OCTET_STRING **dest, ASN1_OCTET_STRING *os, unsigned char *data, size_t len)`
    * Initialise OCTET String from buffer and length
    * Set the data to os's data and assign `os`'s pointer to `*dest`.


* octet string
    * octet is `byte`
    * octet string is `byte string`
