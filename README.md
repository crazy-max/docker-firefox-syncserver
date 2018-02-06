<p align="center"><a href="https://github.com/crazy-max/docker-firefox-syncserver" target="_blank"><img height="128"src="https://raw.githubusercontent.com/crazy-max/docker-firefox-syncserver/master/.res/docker-firefox-syncserver.jpg"></a></p>

<p align="center">
  <a href="https://microbadger.com/images/crazymax/firefox-syncserver"><img src="https://images.microbadger.com/badges/version/crazymax/firefox-syncserver.svg?style=flat-square" alt="Version"></a>
  <a href="https://travis-ci.org/crazy-max/docker-firefox-syncserver"><img src="https://img.shields.io/travis/crazy-max/docker-firefox-syncserver/master.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/firefox-syncserver/"><img src="https://img.shields.io/docker/stars/crazymax/firefox-syncserver.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/firefox-syncserver/"><img src="https://img.shields.io/docker/pulls/crazymax/firefox-syncserver.svg?style=flat-square" alt="Docker Pulls"></a>
  <a href="https://quay.io/repository/crazymax/firefox-syncserver"><img src="https://quay.io/repository/crazymax/firefox-syncserver/status?style=flat-square" alt="Docker Repository on Quay"></a>
  <a href="https://beerpay.io/crazy-max/docker-firefox-syncserver"><img src="https://img.shields.io/beerpay/crazy-max/docker-firefox-syncserver.svg?style=flat-square" alt="Beerpay"></a>
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YY7W3WDEPHCPQ"><img src="https://img.shields.io/badge/donate-paypal-7057ff.svg?style=flat-square" alt="Donate Paypal"></a>
</p>

## About

🐳 [Firefox Sync Server](http://moz-services-docs.readthedocs.io/en/latest/howtos/run-sync-1.5.html) image for Docker based on [Sync Server 1.6.0](https://github.com/mozilla-services/syncserver).<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other 🐳 Docker images!

Configuration of this docker image works through environment variables :

* `FF_SYNCSERVER_PUBLIC_URL` : Must be edited to point to the public URL of your server (default to `http://localhost:5000`).
* `FF_SYNCSERVER_SECRET` : This is a secret key used for signing authentication tokens. It should be long and randomly-generated.
* `FF_SYNCSERVER_ALLOW_NEW_USERS` : Set this to `false` to disable new-user signups on the server. Only request by existing accounts will be honoured (default to `true`).
* `FF_SYNCSERVER_FORCE_WSGI_ENVIRON` : Set this to `true` to work around a mismatch between public_url and the application URL as seen by python, which can happen in certain reverse-proxy hosting setups (default to `false`).
* `TZ` : The timezone assigned to the container (default to `UTC`)

The volume `/data` is mounted to persist the SQLite database.

## Usage

Docker compose is the recommended way to run this image. You can use the following [docker compose template](docker-compose.yml), then run the container :

```bash
$ docker-compose up -d
```

Or use the following command:

```bash
$ docker run -d -p 5000:5000 --name firefox-syncserver \
  -e FF_SYNCSERVER_PUBLIC_URL="http://localhost:5000" \
  -e FF_SYNCSERVER_SECRET="5up3rS3kr1t" \
  -e FF_SYNCSERVER_ALLOW_NEW_USERS="true" \
  -e FF_SYNCSERVER_FORCE_WSGI_ENVIRON="false" \
  -e TZ="Europe/Paris" \
  -v $(pwd)/data:/data \
  crazymax/firefox-syncserver:latest
```

## Nginx + Let's encrypt

Here is a docker-compose example to use Firefox Sync Server behind a reverse proxy with Nginx + Let's encrypt :

```yml
version: '3'

services:
  proxy:
    image: jwilder/nginx-proxy:alpine
    labels:
      - com.github.jrcs.letsencrypt_nginx_proxy_companion.nginx_proxy=true
    ports:
      - 80:80
      - 443:443
    volumes:
      - ./proxy/conf.d:/etc/nginx/conf.d:rw
      - ./proxy/vhost.d:/etc/nginx/vhost.d:rw
      - ./proxy/html:/usr/share/nginx/html:rw
      - ./proxy/certs:/etc/nginx/certs:ro
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/tmp/docker.sock:ro
    restart: always

  letsencrypt:
    image: jrcs/letsencrypt-nginx-proxy-companion
    depends_on:
      - proxy
    volumes:
      - ./proxy/certs:/etc/nginx/certs:rw
      - ./proxy/vhost.d:/etc/nginx/vhost.d:rw
      - ./proxy/html:/usr/share/nginx/html:rw
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
    restart: always

  firefox-syncserver:
    image: crazymax/firefox-syncserver:latest
    container_name: firefox-syncserver
    volumes:
      - ./data:/data
    environment:
      - VIRTUAL_HOST=syncserver.example.com
      - VIRTUAL_PORT=5000
      - LETSENCRYPT_HOST=syncserver.example.com
      - LETSENCRYPT_EMAIL=webmaster@example.com
      - FF_SYNCSERVER_PUBLIC_URL=https://syncserver.example.com
      - FF_SYNCSERVER_SECRET=5up3rS3kr1t
      - FF_SYNCSERVER_ALLOW_NEW_USERS=true
      - FF_SYNCSERVER_FORCE_WSGI_ENVIRON=true
      - TZ=Europe/Paris
    restart: always
```

## How can i help ?

All kinds of contributions are welcomed :raised_hands:!<br />
The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon:<br />
But we're not gonna lie to each other, I'd rather you buy me a beer or two :beers:!

[![Beerpay](https://beerpay.io/crazy-max/docker-firefox-syncserver/badge.svg?style=beer-square)](https://beerpay.io/crazy-max/docker-firefox-syncserver)
or [![Paypal](.res/paypal.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YY7W3WDEPHCPQ)

## License

MIT. See `LICENSE` for more details.
