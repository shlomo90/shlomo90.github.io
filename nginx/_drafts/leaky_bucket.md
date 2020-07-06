

# leaky bucket

Computer networking 에서 사용하는 일종의 비유. 일정한 비율의 트래픽을 전송하기 위한 알고리즘으로 leaky bucket
은 token bucket 과 유사하다.

leaky bucket 에 물을 붇는다는 것은 Network Traffic 이 burst 하게 들어온다는 것을 의미하고, leaking 즉, 새는 물은
일정한 비율로 나가는 패킷으로 보면 된다.

이와 관련된 알고리즘으로 Generic cell rate algorithm 을 확인해보라.

* ref
  * https://en.wikipedia.org/wiki/Leaky_bucket
  * https://en.wikipedia.org/wiki/Generic_cell_rate_algorithm


---

is a analogy of how a bucket with a leak will overflow if ether the average rate at which is poured in exceeds
the rate at which the bucket leaks or if more water than the cacpcity of the bucket is poured in all at once

it is used in packet-switched computer networks and telecommunications network in both the traffic policing and
traffic shaping of data transmissions, in the form of packets to defined limits on bandwidth and burstiness

to detect when the average or peak rate of random or stocahstic (확률론적)

At least some implementations of the leaky bucket are a mirror image of the Token Bucket algorithm
determin exactly the same sequence of events to conform or not conform to the same limits.



token bucket

A token is added to the bucket every 1/r seconds
The bucket can hold at the most B tokens. if a token arrives when the bucket is full, it is discarded.

when a packet (network layer PDU) of n bytes arrives,
    if at least n tokens are in the bucket, n tokens are removed from the bucket, and the packet is sent to the
    network

    if fewer than n tokens are available, no tokens are removed from the bucket, and the packet is considered
    to be non-conformant.

PDU (protocol data unit)



---


limit_cps is j




