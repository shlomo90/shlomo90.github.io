---
layout: post
comments: true
---

# SSL

## SSL Protocol

It is sockets-oriented. All or none of the data that is sent to or received from a socket are
cryptographically protected in exactly the same way.  

### **SSL Record**

It fragments the data into manageable pieces (called fragments), and processes each fragment
individually.  
Each fragment is optionally compressed, authenticated with a MAC, encrypted, prepended with a 
header, and transmitted to the recipient.  
Each fragment that is treated and prepared this way is called an **SSL record**.  
On the recipient's side, the SSL records must be decrypted, verified (with regard to their
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
* See below `SSL Handshake Protocol Detail`


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

#### master secret

```
master_secret = 
    MD5(pre_master_secret
        + SHA(’A’ + pre_master_secret + ClientHello.random + ServerHello.random)) +
    MD5(pre_master_secret
        + SHA(’BB’ + pre_master_secret + ClientHello.random + ServerHello.random)) +
    MD5(pre_master_secret
        + SHA(’CCC’ + pre_master_secret + ClientHello.random + ServerHello.random))
```
* MD5 hash value is 16 bytes long
* master secret value is 3 * 16 bytes
* master secret is part of the session state of the cryptographic parameters (e.g., cryptographic keys and IVs)
* After generating master secret, `pre_master_secret` should be deleted from memory.


#### anonymous key exchange

* a key exchange without peer entity authentication.


## SSL Handshake Protocol Detail

### SSL handshake negotiation

* it's done when the client and server have exchanged `ChangeCipherSpec` messages
* They can communicate using the newly agreed-upon cryptographic parameters.
* `FINISHED` message is the first SSL handshake message that is protected according to these new
  parameters.


### SSL Handshake

![Alt text](/posts/ssl/pics/ssl_handshake.png)

* This is the basic SSL Handshake.
    * Something wrapped '[]' is optional.
* HELLOREQUEST message may be sent from the server to clinet. but it is seldom used in practice.
* After having exchanged CLIENTHELLO and SERVERHELLO messages, the client and server have negotiated a protocol
  version, a session identifier, a cipher suite, and a compression method. **Furthermore, two random values
  (i.e., ClientHello.random and ServerHello.random)**
* First Set of Messages
    1. Client sends a CLIENTHELLO message to server.
* Second Set of Messages
    1. Server sends a SERVERHELLO message to client in response to the CLIENTHELLO message
    2. Under some circumstances, the server may send a SERVERKEYEXCHANGE message to the client.
    3. the server sends a SERVERHELLODONE message to client
* Third Set of Messages
    1. The client sends a CLIENTKEYEXCHANGE message to the server. The content of this message depends on the
       **key exchange algorithm in use**
    2. The client sends a CHANGECIPHERSPEC message to the server and copies its pending write state into the
       current write state.
        * It means it's going to use the new encryption keys.
        * pending state
            * It's the state of the encryption
            * includes **new encryption keys**, and initialization vectors.
            * current read/write state is overwritten with the pending read/write state it means that the
              new encryption keys and IVs are to be used for future communication.
    3. The client sends a FINISHED Message to the server.
* Fourth Set of Messages
    1. Server sends another CHANGECIPHERSPEC message to the client and copies its pending write state into the
       current write state.
    2. Server sends a FINISHED message to the client. (This message is cryptographically protected under the
       **new cipher spec**.
* Handshake completed




Additionally, the use of ephemeral RSA key exchange is only allowed in the TLS standard,
[Link1](https://www.openssl.org/docs/man1.0.2/man3/SSL_CTX_set_tmp_rsa_callback.html)
Good reason for the ephemeral RSA.
[Link2](https://groups.google.com/forum/#!topic/sci.crypt/BPBi_MVbfTc)

keyUsage for openssl
[Link3](https://www.phildev.net/ssl/opensslconf.html)
