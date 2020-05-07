---
layout: post
comments: true
---

# CPS and TPS

## connection per second

* The number of L4 connections established per second
* Determine the maximum number of fully functional (establishement, single small transaction, graceful termination) connections that can be established per second.

## transactions per second

* The number of L5-L7 transactions completed per second
* "transaction" means that one HTTP request and response processed.
* Used to say, there is one connection and multiple HTTP transactions use the connection.

* ref
    * https://devcentral.f5.com/s/articles/understanding-performance-metrics-and-network-traffic-31962
