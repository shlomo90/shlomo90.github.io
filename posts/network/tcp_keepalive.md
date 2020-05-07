---
layout: post
comments: true
---

# TCP Keepalive

## Purpose

* cause Perfectly good connection
* consume unnecessary bandwidth.
* consume unnecessary cost money for an Internet path that charges for packets.


## How does work?

* It is driven by a keepalive timer. when the timer fires, a keepalive probe is sent, and the peer receiving the probe responds with an ACK.

## Who uses TCP Keepalive?

* Usually server node in client-server model for serving interactive-style services.
    * When a client connection is closed, server will wait forever. (half-open connection)
    * The server can detect if it sends keepalive probe to client.
* Also, client node can use this.

## Keepalive
