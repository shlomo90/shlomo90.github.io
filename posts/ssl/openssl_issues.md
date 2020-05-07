---
layout: post
comments: true
---

# Openssl Issues

Segmentation fault in SSL_check_chain (CVE-2020-1967)

```
Segmentation fault in SSL_check_chain (CVE-2020-1967)
=====================================================

Severity: High

Server or client applications that call the SSL_check_chain() function during or
after a TLS 1.3 handshake may crash due to a NULL pointer dereference as a
result of incorrect handling of the "signature_algorithms_cert" TLS extension.
The crash occurs if an invalid or unrecognised signature algorithm is received
from the peer. This could be exploited by a malicious peer in a Denial of
Service attack.

OpenSSL version 1.1.1d, 1.1.1e, and 1.1.1f are affected by this issue.  This
issue did not affect OpenSSL versions prior to 1.1.1d.

Affected OpenSSL 1.1.1 users should upgrade to 1.1.1g

This issue was found by Bernd Edlinger and reported to OpenSSL on 7th April
2020. It was found using the new static analysis pass being implemented in GCC,
-fanalyzer. Additional analysis was performed by Matt Caswell and Benjamin
Kaduk.

Note
=====

This issue did not affect OpenSSL 1.0.2 however these versions are out of
support and no longer receiving public updates. Extended support is available
for premium support customers: https://www.openssl.org/support/contracts.html

This issue did not affect OpenSSL 1.1.0 however these versions are out of
support and no longer receiving updates.

Users of these versions should upgrade to OpenSSL 1.1.1.

References
==========

URL for this Security Advisory:
https://www.openssl.org/news/secadv/20200421.txt

Note: the online version of the advisory may be updated with additional details
over time.

For details of OpenSSL severity classifications please see:
https://www.openssl.org/policies/secpolicy.html
```

* bug fixed code point(?)

```c

static int tls1_check_sig_alg(SSL *s, X509 *x, int default_nid)
{
    int sig_nid, use_pc_sigalgs = 0;
    size_t i;
    const SIGALG_LOOKUP *sigalg;
    size_t sigalgslen;
    if (default_nid == -1)
        return 1;
    sig_nid = X509_get_signature_nid(x);
    if (default_nid)
        return sig_nid == default_nid ? 1 : 0;

    if (SSL_IS_TLS13(s) && s->s3.tmp.peer_cert_sigalgs != NULL) {
        /*
         * If we're in TLSv1.3 then we only get here if we're checking the
         * chain. If the peer has specified peer_cert_sigalgs then we use them
         * otherwise we default to normal sigalgs.
         */
        sigalgslen = s->s3.tmp.peer_cert_sigalgslen;        //<-- if tls 1.3, use_pc_signalgs is set
        use_pc_sigalgs = 1;                                 //    and use different sigalgslen.
    } else {
        sigalgslen = s->shared_sigalgslen;
    }
    for (i = 0; i < sigalgslen; i++) {
        sigalg = use_pc_sigalgs
                 ? tls1_lookup_sigalg(s->s3.tmp.peer_cert_sigalgs[i])   //<-- tls1.3's sigalg uses tmp.peer_cert_signals array.
                 : s->shared_sigalgs[i];                                //<-- other versions
        if (sigalg != NULL && sig_nid == sigalg->sigandhash)
            return 1;
    }
    return 0;
}
```
