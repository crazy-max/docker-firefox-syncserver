<p align="center"><a href="https://github.com/crazy-max/docker-firefox-syncserver" target="_blank"><img height="128"src="https://raw.githubusercontent.com/crazy-max/docker-firefox-syncserver/master/.res/docker-firefox-syncserver.jpg"></a></p>

<p align="center">
  <a href="https://microbadger.com/images/crazymax/firefox-syncserver"><img src="https://images.microbadger.com/badges/version/crazymax/firefox-syncserver.svg?style=flat-square" alt="Version"></a>
  <a href="https://travis-ci.org/crazy-max/docker-firefox-syncserver"><img src="https://img.shields.io/travis/crazy-max/docker-firefox-syncserver/master.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/firefox-syncserver/"><img src="https://img.shields.io/docker/stars/crazymax/firefox-syncserver.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/firefox-syncserver/"><img src="https://img.shields.io/docker/pulls/crazymax/firefox-syncserver.svg?style=flat-square" alt="Docker Pulls"></a>
  <a href="https://quay.io/repository/crazymax/firefox-syncserver"><img src="https://quay.io/repository/crazymax/firefox-syncserver/status?style=flat-square" alt="Docker Repository on Quay"></a>
  <a href="https://www.codacy.com/app/crazy-max/docker-firefox-syncserver"><img src="https://img.shields.io/codacy/grade/d6131942609e4d0ba34953e87d26f455.svg?style=flat-square" alt="Code Quality"></a>
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YY7W3WDEPHCPQ"><img src="https://img.shields.io/badge/donate-paypal-7057ff.svg?style=flat-square" alt="Donate Paypal"></a>
</p>

## About

🐳 [Firefox Sync Server](http://moz-services-docs.readthedocs.io/en/latest/howtos/run-sync-1.5.html) image based on Python Alpine Linux.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other 🐳 Docker images!

## Features

### Included

* Alpine Linux 3.8

### From docker-compose

* [Traefik](https://github.com/containous/traefik-library-image) as reverse proxy and creation/renewal of Let's Encrypt certificates

## Docker

### Environment variables

* `TZ` : The timezone assigned to the container (default `UTC`)
* `FF_SYNCSERVER_PUBLIC_URL` : Must be edited to point to the public URL of your server (default `http://localhost:5000`).
* `FF_SYNCSERVER_SECRET` : This is a secret key used for signing authentication tokens. It should be long and randomly-generated.
* `FF_SYNCSERVER_ALLOW_NEW_USERS` : Set this to `false` to disable new-user signups on the server. Only request by existing accounts will be honoured (default `true`).
* `FF_SYNCSERVER_FORCE_WSGI_ENVIRON` : Set this to `true` to work around a mismatch between public_url and the application URL as seen by python, which can happen in certain reverse-proxy hosting setups (default `false`).
* `FF_SYNCSERVER_SQLURI` : Defines the database in which to store all server data (default `sqlite:///data/syncserver.db`).

### Volumes

* `/data` : Contains SQLite database if `FF_SYNCSERVER_SQLURI` is untouched

### Ports

* `5000` : Gunicorn port

## Use this image

### Docker Compose

Docker compose is the recommended way to run this image. You can use the following [docker compose template](examples/compose/docker-compose.yml), then run the container :

```bash
touch acme.json
chmod 600 acme.json
docker-compose up -d
docker-compose logs -f
```

### Command line

You can also use the following minimal command :

```bash
$ docker run -d -p 5000:5000 --name firefox_syncserver \
  -e TZ="Europe/Paris" \
  -e FF_SYNCSERVER_SECRET="5up3rS3kr1t" \
  -v $(pwd)/data:/data \
  crazymax/firefox-syncserver:latest
```

## Update

Recreate the container whenever i push an update :

```bash
docker-compose pull
docker-compose up -d
```

## How can I help ?

All kinds of contributions are welcome :raised_hands:!<br />
The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon:<br />
But we're not gonna lie to each other, I'd rather you buy me a beer or two :beers:!

[![Paypal](.res/paypal.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YY7W3WDEPHCPQ)

## License

MIT. See `LICENSE` for more details.
