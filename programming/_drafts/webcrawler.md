
# Webcrawler

* This is from 500 Less Line book.
* It finds and downloads all pages on **a website**

---

## How to work?

* Beginning with a root URL
* Parse it for links to unseen pages
* Add these to a queue
* Fetch next pages from queue until no unseen links and the queue is empty


* Constraints
  * Limit concurrent requests for not diving too deeply.

* Threads
  * it's in charge of downloading one page at a time over a socket

* Example of `fetch` code
```python
def fetch(url):
    sock = socket.socket()
    sock.connect(('xkcd.com', 80))
    request = 'GET {} HTTP/1.0\r\nHost: xkcd.com\r\n\r\n'.format(url)
    sock.send(request.encode('ascii'))
    response = b''
    chunk = sock.recv(4096)
    while chunk:
        response += chunk
        chunk = sock.recv(4096)
    # Page is now downloaded.
    links = parse_links(response)
    q.add(links)
```

* Ideas 
  * What about making crawlers in Nginx?


* C10K Problem
  * Client 10000 concurrent connection Failure


* Async framework builds on the two features we have shown - non-blocking sockets and event loop
  * This system is designed for I/O-bound problems not CPU-bound ones


? it is important to correct a common misapprehension that async is *faster* than multithreading. Often it's not
  in the python.
