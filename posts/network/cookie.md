<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# Cookie HTTP

* This is a summary of RFCs about Cookie

## Cookie Header fields

* *Cookie*
* *Set-Cookie*

## Purpose

* Historically, it contains a number of security and privacy infelicities.
* Letting the servers **maintain a stateful session** over the mostly stateless HTTP protocol.
    * origin server sends cookie to user agent. (Use *Set-Cookie* header)
    * user agent sends back to origin server. (Use *Cookie* header)

## Restrictions

* There are some cases that are not fit into syntax and semantic in use today, Should document the
  different things.

## Terminology

* *request-host* is the name of the host
* *string* means a sequence of non-NUL octets.


## Server Requirements

### Set-Cookie

## User Agent Requirements

## References

* 2109 -> 2965 -> 6265
    * [RFC6265](https://tools.ietf.org/html/rfc6265)
    * [RFC2109](https://tools.ietf.org/html/rfc2109)
    * [RFC2965](https://tools.ietf.org/html/rfc2965)

## See also

* [ABNF](https://tools.ietf.org/html/rfc5234)
