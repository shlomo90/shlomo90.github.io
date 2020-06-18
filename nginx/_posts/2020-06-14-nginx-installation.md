---
layout: post
tags: nginx programming
comments: true
---

# Install Nginx

---

## Process

1. Clone the Nginx git repository from github "https://github.com/nginx/nginx.git"

```
git clone https://github.com/nginx/nginx.git
```

2. Install Dependencies

```
apt-get install -y libpcre3 libpcre3-dev
apt-get install -y libssl-dev zlib1g-dev
apt-get update -y --fix-missing
apt-get install -y libfcgi-dev libfcgi0ldbl \
            libmcrypt-dev libssl-dev libc-client2007e \
            libc-client2007e-dev libxml2-dev libbz2-dev \
            libcurl4-openssl-dev libjpeg-dev libpng-dev \
            libfreetype6-dev libkrb5-dev libpq-dev \
            libxml2-dev libxslt1-dev
```

3. Run `./auto/configure`

4. Save the result of build summary.

5. Run `make install`

6. Configure the `nginx.conf` file. (You can find the conf file in build summary file)

7. Run `nginx`

## Nginx With PHP

Nginx supports PHP. You can simple edit the config below.

```
location ~ \.php$ {
    proxy_pass   http://127.0.0.1:9000;
}
```

But, First of all, You need to install php server.

1. Get the source code of php [Download Link](https://www.php.net/distributions/php-7.4.6.tar.gz)
2. Extract the compressed php file.
```
$ tar -xvf php-7.4.6.tar.gz
```
3. Configure it
```
$ ./configure
```
4. Make and Install
```
$ make
$ make install
```
5. Check it's installed well
```
$ php -v
```
6. Open server background
```
$ _SERVER=/workspace/html && php -S 127.0.0.1:9000 &
```
`_SERVER` is an environment variable having php server root path. Make sure the root directory path should be 
same with nginx root directory path.
7. nginx reload and check it works
```
$ ./nginx -s reload
```
