---
layout: post
comments: false
---

# session callback

Openssl library supports the session ticket for TLS1.3.

* API
    * `SSL_CTX_set_session_ticket_cb`
        * Set the SSL_CTX's `generate_ticket_cb` and `decrypt_ticket_cb`.
