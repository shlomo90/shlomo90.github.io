---
layout: post
comments: true
---

# Session Resumption

---

## Purpose

1. Understanding the Session Resumption
2. Understanding between Session ID reuse and Ticket

## Session Reuse

The SSL Handshake takes many costs like exchanging Cipher Specs, generating secret key, etc.  
If every `https` connection tries to establish a SSL Connection, It may look like wasting Network 
resources.  

`Session Reuse` is the technique of saving unnecessary resources. Simply, It uses the previous
connection session when new connection comes to a Server. Servers keep saving the `Session ID`
that is created when SSL Handshake successfully done even though the Connection is closed. After
the identical Client tries to connect to the server with `Session ID`, Server checks the ID and
use the Cipher Specs and Secret key already agreed before.  

In `Session Reuse` with `Session ID`, Servers should have the Client's `Session ID`. and It could be
removed if Session expires.

## Session Ticket

`Session Ticket` eventually has the exact work but, processes are little bit different with
`Session Reuse` with `Session ID`. Here is the Background.  

* Session resumption with session IDs has a major limitation (Server should cache the sessions.)

### How to work Session Ticket?

1. The ticket is sent by the server at the end of the TLS Handshake.
2. Clients supporting session tickets will cache the ticket along with the current session key
   inform.
3. Later the client includes the session ticket in the handshake message to indicate it wishes to
   resume the earlier session.

The *Pros* is every host now is able to decrypt this session ticket and resume the session for the
Client. But the *Cons* is that could become critical **single point of failure** for TLS security.
The session key information is exposed for every session ticket.
