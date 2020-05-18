---
layout: post
comments: true
---

# Message Authentication

---

## Purpose to read this

1. Understand what Message Authentication is.
2. Understand how to work the Message Authentication in SSL/TLS.

## Why need?

Generally, Message Authentication Algorithms called `MAC (Message Authentication Code)` are used in SSL/TLS.
According to Wikipedia, the message authentication algorithms currently using are `Hash-based MD5` and
`SHA hash function`. The question is why does SSL/TLS Communication need them?

1. Message's data integrity
2. Message's data authenticity

Let's say that a client sends the message encrypted to a server and some attackers can hijack the network packet
and change the message. The server will know the message is invalid if the server checks Message with
the Message authentication algorithm agreed between the client and the server. It gives the authenticity and
trust the communication.

## MAC Algorithms

In TLS1 ~ TLS1.2, There are two algorithms.

1. MD5
2. SHA
