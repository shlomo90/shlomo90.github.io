# SSL Works? (Editing)

## Key Usage

Key usage extension defines the purpose (e.g., encipherment, signature, certificate signing)  
Example is that 

```
[ v3_OCSP ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = OCSPSigning
```

## authentication (RSA, ECDSA)

It is used for checking client's certificate is what I really want to connect.  
So, It checks the certificate with algorithm (RSA, ECDSA)  
키를 교환할 상대방이 교부한 인증서가 정말 내가 접속하고자 하는 상대방이 맞는지  
상위 인증기관 (CA)를 통하여 확인하게 되는데, 이 때 사용되는 알고리즘을 의미합니다.

1. key exchange (RSA, ECDH(ECDHE),...)

How to choose the key exchange algo between server and client.

```
Server has Private key and Public key
client has Private key and Public key

client send public key to server
server send public key to client

client has (C's Pri, S's Pub) -> shared key (same with server's shared key)
server has (S's pri, C's Pub) -> shared key (same with client's shared key)
```

2. Sign (ECDSA) [related to speed] (how can i check this sent msg is really what my friend sent?

The scenario is the following: Alice wants to sign a message with her private key (dA), and Bob wants to validate the signature using Alice's public key (HA).

Hmmm..   
plain text -> integer -> sign!(ECDSA) -> encrypted -> send  
encrypt text -> verify!(ECDSA) -> plain  

https://andrea.corbellini.name/2015/05/30/elliptic-curve-cryptography-ecdh-and-ecdsa/

보다 문득 든 궁금증인데 ECDH 와 ECDSA 에서 private 키 값은 같이 쓰이는가?  
"KeyUsage extension", "ExtendedKeyUsage" 와 같은 항목이 Cert 만들때 존재하는데 이떄 결정되나봄.
