---
layout: post
comments: true
---

# Session Resumption

---

## Purpose

1. Understanding the Session Resumption
2. Understanding between Session ID reuse and Ticket

## Session Ticket

* Backgound
    * Session resumption with session IDs has a major limitation
        * Server wants to cache the sssions

* Process
    * The ticket is sent by the server at the end of the TLS Handshake.
    * Clients supporting session tickets will cache the ticket along with the current session key inform.
    * Later the client includes the session ticket in the handshake message to indicate it wishes to resume the earlier session.

* Pros
    * Every host now is able to decrypt this session ticket and resume the session for the client.
* Cons
    * it becomes critical single point of failure for TLS security.
        * if the session key information is exposed for every session ticket.

