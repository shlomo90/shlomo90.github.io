---
layout: post
tags: network subnet
comments: true
---

# Subnet

---

## What does do subnet and why does it need?

After installing OS, we need to setup the network setting. We might wonder what the subnet and gateway are.
the ethernet networking is based on LAN and used for local networking. So, why the subnet is required?


```
255      255      224      0
11111111 11111111 11100000 00000000
                  11111000 00000000

                  00000111

                  248
11111111 11111111 11111000 00000000
                  240
                  11110000

192.168.224.1
11000000 10101000 11100000 00000001

                  226
11111111 11111111 11100010 10110100
```
