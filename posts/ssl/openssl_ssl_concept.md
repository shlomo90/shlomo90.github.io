---
layout: post
comments: true
---

# SSL

## SSL Protocol

* It is sockets-oriented
    * all or none of the data that is sent to or received from a socket are cryptographically
      protected in exactly the same way.
    * It fragments the data into manageable pieces (called fragments), and processes each fragment
      individually.
    * each fragment is optionally compressed, authenticated with a MAC, encrypted, prepended with
      a header, and transmitted to the recipient
    * Each fragment that is treated and prepared this way is called **an SSL record**.
    * On the recipient's side, the SSL records must be decrypted, verified (with regard to their
      MACs), decompressed, and reassembled, before the data can be delivered to the respective
      higher-layer.
    * **SSL record** consists of four field
        1. type field
        2. version field
        3. length field
        4. fragment field

![Alt text](/posts/ssl/pics/ssl_protocol.png)

### SSL Record Protocol

* encapsulation of higher-layer protocol data.


### SSL Handshake protocol

* communicating peers to authenticate each other and to negotiate a cipher suite and a compression
  method used for the communications.
* **cipher suite** is used to cryptographically protect data.


### SSL Change Spec Protocol

* communicating peers to signal a cipher spec change
* is used to put these parameters in place and make them effective.

### SSL Alert Protocol

* communicating peers to signal indicator of potential problems


### SSL Aplication Data Protocol

* it is in charge of the secure transmission of application data.
* it feeds the data of application layer into the **SSL Record Protocol**.

## SSL Record

* it is tagged with a length field that refers to the length of the entire record.
* multiple SSL messages of the same type can in fact be carried inside a single SSL record.

```
 __________________ SSL Record _________________________
/                                                       \
+---------+---------+---------+--------------------------+
|SSL MSG1 |SSL MSG2 |SSL MSG3 |  ...                     |
+---------+---------+---------+--------------------------+
```

## SSL Port Strategy

* Separate port strategy
    * 80 for HTTP
    * 443 for HTTPS
* upward negotiation strategy
    * Detect SSL and upgrade to SSL
    * Ref to RFC2817

## SSL Session

* SSL sessions and connections are **stateful**
    * SSL protocol state machines on either side to operate consistently
        * current state
        * pending state
        * read state
        * write state
* done


### SSL Session State Elements

* `session id`
* `peer certificate`
    * X.509v3 certificate of the peer
* `compression method`
    * Data compression algo used (prior to encryption)
* `cipher spec`
    * Data encryption and MAC algo used
* `master secret`
    * 48-byte secret that is shared between the client and the server
* `is resumable`
    * Flag whether the SSL session is resumable


#### premaster secret

* Before secret key cryptographic techniques can be invoked, some keying material must be
  establish a 48-bypte premaster secret (Usually for RSA, DH, FORTEZZA)

* `RSA`
    1. Client generates a `premaster secret`
    2. Client encrypts it under the server's public key (the server may send the public key in ServerHello)
    3. Client sends the result ciphertext to the server
    4. Server decrypts the ciphertext with server's private key

* `DHE`
    * the DH parameters are not fixed and are not part of public key certificate
    1. DH parameters are dynamically generated
    2. They are authenticated in some way
        * the parameters are digitally signed with the sender's private signing key (Maybe Client's)
    3. The recipient can then use the sender's public key to verify the signature
        * Authenticity of the public key is guaranteed
    * how to generate premaster?
        * 클라이언트는 certificate와 DH parameter의 signature를 검증 한 뒤, 클라이언트의
          DH parameter를 보냅니다. 이후 클라이언트와 서버는 각각 주고받은 DH parameter를
          이용해 premaster secret을 유도한 뒤, premaster secret과 client random, server random을
          조합하여 session key를 유도합니다.
* `DH`
    * keying material generated is always the same for two participating entities
* `DH_anon`
    * it is vunerable for Man in the middle attack.


#### anonymous key exchange

* a key exchange without peer entity authentication.

## SSL handshake negotiation

* it's done when the client and server have exchanged `ChangeCipherSpec` messages
* They can communicate using the newly agreed-upon cryptographic parameters.
* `FINISHED` message is the first SSL handshake message that is protected according to these new
  parameters.
