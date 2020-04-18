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

### Set-Cookie Syntax

* Set-Cookie
    * It has one "cookie-pair" and multiple "cookie-av".
    * Some servers do multiple "cookie-pair" at Set-Cookie Header.
    * But, RFC6265 says the only one "cookie-pair"
* cookie-pair
    * It has cookie-name and cookie-value.
    * `cookie-name "=" cookie-value`
    * cookie-value SHOULD encode the data, for example, using Base64.
* cookie-av
    * It has `expires-av`, `max-age-av`, `domain-av`, `path-av`, `secure-av`, `httponly-av`, `extension-av`
* expires-av
    * "Expires=" sane-cookie-date
    * case-insensitively match
* max-age-av
    * "Max-Age=" non-zero-digit
    * case-insensitively match
* domain-av
    * "Domain=" domain-value
* path-av
    * "Path=" path-value
* secure-av
    * "Secure"
    * The secure attribute limits the score of the cookie to "secure" channels (where "secure" is defined by the user agent). When a cookie has the Secure attribute, the user agent will include the cookie in an HTTP request **only if the request is transmitted over a secure channel**
* httponly-av
    * "HttpOnly"
* extension-av
    * Anything server requirement.


## User Agent Requirements

### Cookie Syntax

* The user agent includes stored cookies in the Cookie HTTP request header.
* When the user agent generates an HTTP request, the user agent MUST NOT attach more than one Cookie header field.
* The user agent SHOULD sort the cookie-list in the following order
    * Cookies with longer paths are listed before cookies with shorter paths.
    * Among cookies that havve equal-length path fields, cookies with earlier creation-times are listed before cookie with later creation-times.
* Despite its name, the cookie-string is actually a sequence of octets, not a sequence of characters
  To convert the cookie-string into a sequence of characters, the user agent might wish to try using the UTF-8 character encoding.


### Handling Set-Cookie Header in response

* First, a user agent MAY ignore the entire "Set-Cookie" header or MUST parse the Set-Cookie Header.

* If Set-Cookie header has the cookie pair like `test name = google`. it goes `test name=google`.
    * And some cases have leading and tailing whitespace from cookie name or value.
    * But, I am not sure maintaing the internal whitespace `test name`.

* After the user agent finished parsing the set-cookie-string, the user agent is said to "receive a cookie" from the request-uri with name cookie-name, value cookie-value, etc.
* Store the cookies parsed.
    * I am not interested in the store model. Let's skip!

## Limits

* At least 4096 bytes per cookie (as measured by the sum of the length of the cookie's name, value, and attributes)
* At least 50 cookies per domain.
* At least 3000 cookies total.

## Third-Party Cookies

* A user agent often requests resources from other servers (such as advertising networks).
* The Pros and Cons
    * (cons) These Third-Party server an use cookies to track the user
        * if a user visits a site that contains content from a third party and then later visits another site that contains content from the same third party, the third party can track the user between the two sites.
    * (pros) Easy to track the state of users, event at multi servers.


## References

* 2109 -> 2965 -> 6265
    * [RFC6265](https://tools.ietf.org/html/rfc6265)
    * [RFC2109](https://tools.ietf.org/html/rfc2109)
    * [RFC2965](https://tools.ietf.org/html/rfc2965)

## See also

* [ABNF](https://tools.ietf.org/html/rfc5234)


## Some issues about cookies

* Verizon was found guilty of tracking users without their consent, and sharing their information with advertisers.j
