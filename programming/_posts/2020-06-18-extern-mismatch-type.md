---
layout: post
tags: programming c issue
comments: true
---

# incompatible `extern` variable case

---

## Issue

Suppose there are two files (`ngx_stream_core_module.c`, `ngx_status.c`)

```c
/* ngx_stream_core_module.c */

extern ngx_str_t *ngx_protocol_strings;
//extern ngx_str_t ngx_protocol_strings[MAX];
```

```c
/* ngx_status.c */

ngx_str_t ngx_protocol_strings[NGX_SSL_PROT_MAX] = {
    ngx_string("ssl_prot_sslv3"),
    ngx_string("ssl_prot_tls1_0"),
    ngx_string("ssl_prot_tls1_1"),
    ngx_string("ssl_prot_tls1_2"),
    ngx_string("ssl_prot_tls1_3"),
    ngx_string("ssl_prot_dtls1_0"),
    ngx_string("ssl_prot_dtls1_2")
};  
```

This c code uses the extern keyword incorrectly. the declaration of extern variable
`ngx_str_t *ngx_protocol_strings` is incompatible with `ngx_str_t ngx_protocol_strings[]`.
`int*` is not the same with `int[]`.


But I think this kind of human error could happend. because we cast the array to pointer variable. See below.

```c
int main ()
{
    int a[10] = {1,2,3,4,5,6,7,8,9};
    int *b;

    b = a;
}
```

Here is the great gcc option for protecting this bug `-Wno-builtin-declaration-mismatch`.
If you apply this option, conflict warning message will show up.

```
 error: conflicting types for 'ngx_protocol_strings'
 note: previous declaration of 'ngx_protocol_strings' was here
 error: conflicting types for 'ngx_key_exchange_strings'
 note: previous declaration of 'ngx_key_exchange_strings' was here
 error: conflicting types for 'ngx_auth_strings'
 note: previous declaration of 'ngx_auth_strings' was here
 error: conflicting types for 'ngx_hmac_strings'
 note: previous declaration of 'ngx_hmac_strings' was here
 error: conflicting types for 'ngx_sess_strings'
 note: previous declaration of 'ngx_sess_strings' was here
 error: conflicting types for 'ngx_encrypt_strings'
 note: previous declaration of 'ngx_encrypt_strings' was here
```

## Conclusion

Use the gcc option `-Wno-builtin-declaration-mismatch`.
