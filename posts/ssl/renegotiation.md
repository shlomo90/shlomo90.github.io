---
layout: post
comments: true
---

# SSL Renegotiation and Session Reuse

SSL renegotiation process is the New SSL Handshake process over an established SSL connection
The SSL renegotiation process can establish another secure SSL session because renegotiation messages.
including the types of ciphers and encryption keys, are encrypted and then sent over to the existing SSL Connection


What is the session reuse?
The server side has the SSL Session ID for clients who already had a connection. When a client connects to
the server, it sends SSL ID in the Handshake message. The server receives the SSL Session ID and then check
it is in the session list. (Server doens't erase the SSL Session ID after connection closed and keeps it)


SSL renegotiation and Session Reuse
They have differnt purposes. SSL Renegotiation is used to change the SSL exchange Key Algorithm or Certificates
in existing session.
But, Session Reuse is used for boosting the performance and save the Network traffic resources.

Session renegotication
So, What is the "session renegotiation"

https://devcentral.f5.com/s/articles/ssl-profiles-part-6-ssl-renegotiation
