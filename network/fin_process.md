<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# Fin Process (Delayed ACK)

간혹, 패킷 분석을 하다보면, close 4-way handshake 를 할 것으로 생각되는데 정작 실제 날라가는 패킷은 더 적은 것에 대해 의문을 품을 수 있다.
여기 아래 해당 상황에 대해서 분석을 해본다.

## A. Understanding Delayed ACK

### 1. TCPDUMP Captures for Delayed ACK
```
02:46:22.548341 IP 172.31.0.100.1344 > 172.31.0.1.11674: Flags [P.], seq 309:407, ack 351, win 508, options [nop,nop,TS val 884878429 ecr 1436], length 98
02:46:22.548458 IP 172.31.0.1.11674 > 172.31.0.100.1344: Flags [F.], seq 351, ack 407, win 27, options [nop,nop,TS val 143676 ecr 884878429], ngth 0
02:46:22.548715 IP 172.31.0.100.1344 > 172.31.0.1.11674: Flags [F.], seq 407, ack 352, win 508, options [nop,nop,TS val 884878429 ecr 143676],ength 0
02:46:22.548812 IP 172.31.0.1.11674 > 172.31.0.100.1344: Flags [.], ack 408, win 27, options [nop,nop,TS val 143676 ecr 884878429], length 0
```

## 2. Explainations

- 2번째 패킷의 F. 에서 . 은 ACK 인데 이는 첫 패킷에 대한 ACK 을 표현하는 것으로 ACK, FIN 이 Merge 된 것
- 3번째 패킷의 F. 은 TCP Half Close 와 연관이 되어있는데, 서버입장에서도 더이상 Client 에게 던질 것이 없는 경우 2번 째 Fin 에 대한 ACK 과 나도 더이상 보낼 게 없다는 뜻인
  Fin 을 합병해서 전달하기에 나타나는 것

# Ref

1. RFC1122 4.2.3.2 chapter
2. https://stackoverflow.com/questions/21390479/fin-omitted-fin-ack-sent

