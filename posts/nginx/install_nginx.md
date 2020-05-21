---
layout: post
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
