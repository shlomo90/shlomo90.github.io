# ECDHE and ECDH Cipher

## What is the EC?

EC means "Elliptic Curve". It's fater than RSA Key Exchange algorithm because its
bit size is much less than RSA but more security.

## What is the Curve?

Curve is the equation of mathematic. It supports curves like secp128r1, secp256r1, ...  
By default, *prime256v1* is very popular.  
curve has the field size which is a necessary thing to each communicate over SSL.  
RFC shows some curves has the same thing but different names See below.  

```
 ------------------------------------------
           Curve names chosen by
      different standards organizations
 ------------+---------------+-------------
 SECG        |  ANSI X9.62   |  NIST
 ------------+---------------+-------------
 sect163k1   |               |   NIST K-163
 sect163r1   |               |
 sect163r2   |               |   NIST B-163
 sect193r1   |               |
 sect193r2   |               |
 sect233k1   |               |   NIST K-233
 sect233r1   |               |   NIST B-233
 sect239k1   |               |
 sect283k1   |               |   NIST K-283
 sect283r1   |               |   NIST B-283
 sect409k1   |               |   NIST K-409
 sect409r1   |               |   NIST B-409
 sect571k1   |               |   NIST K-571
 sect571r1   |               |   NIST B-571
 secp160k1   |               |
 secp160r1   |               |
 secp160r2   |               |
 secp192k1   |               |
 secp192r1   |  prime192v1   |   NIST P-192
 secp224k1   |               |
 secp224r1   |               |   NIST P-224
 secp256k1   |               |
 secp256r1   |  prime256v1   |   NIST P-256
 secp384r1   |               |   NIST P-384
 secp521r1   |               |   NIST P-521
 ------------+---------------+-------------
```

#### REF
1. https://www.johndcook.com/blog/2018/08/21/a-tale-of-two-elliptic-curves/
2. http://www.secg.org/sec2-v2.pdf

## Support Key exchange/agreement and Authentication

* Cipher naming
```
<Protocol>_<Key Exchange Algo>_WITH_<Block chipher>_<Message authentication algo>
```
* cipher suites 종류
```
TLS1.0-1.2 cipher suites
    Key exchange/agreement	Authentication 
    RSA	                        RSA
    Diffie–Hellman      	DSA
    ECDH	                ECDSA
    SRP
    PSK
```

#### REF
1. "https://en.wikipedia.org/wiki/Cipher_suite"

## Key Exchange Algo and authentication Explaination

* Here are two Authentication Algorithm below (ECDSA, RSA)
* Authentication algorithms are used for signing message.

```
ECDH_ECDSA              Certificate MUST contain an
                        ECDH-capable public key.  It
                        MUST be signed with ECDSA.

ECDHE_ECDSA             Certificate MUST contain an
                        ECDSA-capable public key.  It
                        MUST be signed with ECDSA.

ECDH_RSA                Certificate MUST contain an
                        ECDH-capable public key.  It
                        MUST be signed with RSA.

ECDHE_RSA               Certificate MUST contain an
                        RSA public key authorized for
                        use in digital signatures.  It
                        MUST be signed with RSA.
```

## What is different between ECDH, ECDHE

ECDHE is the E=Ephemeral version where you get a distinct DH key for every handshake (session)  
So, Even though Eve knows the private key, it's impossible to see **the previous session's packet**  
ECDHE gives you forward secrecy; ECDH Doesn't give you forward secrecy  
ECDH has a **fixed** DH key; one side of the handshake doesn'tchange from one instance to the next  

Some reasons, OPENSSL 1.1.0 doesn't have Fixed ECDH ciphers. See REF. 3

#### REF
1. https://security.stackexchange.com/questions/96145/confused-about-rfc-4492-difference-between-ecdh-capable-public-key-and-ecdsa
2. http://www.secg.org/  Recommended Elliptic Curve Domain Parameters
3. https://stackoverflow.com/questions/41356625/can-someone-tell-me-how-to-make-a-server-choose-a-ecdh-cipher-over-ecdhe


## Generate Key, Ceritificate OPENSSL

1. Generate Private Key

```bash
openssl ecparam -out /etc/nginx/ssl/nginx.key -name prime256v1 -genkey
```

2. Generate Certificate Signing Reqeust

```bash
    openssl req -new -key /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/csr.pem
```

3. Generate Certificate with private key and csr file

```bash
    openssl req -x509 -nodes -days 365 -key /etc/nginx/ssl/nginx.key -in /etc/nginx/ssl/csr.pem -out /etc/nginx/ssl/nginx.pem
```


