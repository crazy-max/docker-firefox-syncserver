<p align="center"><a href="https://github.com/crazy-max/docker-firefox-syncserver" target="_blank"><img height="100"src="https://raw.githubusercontent.com/crazy-max/docker-firefox-syncserver/master/res/firefox-syncserver-docker.png"></a></p>

<p align="center">
  <a href="https://microbadger.com/images/crazymax/firefox-syncserver"><img src="https://images.microbadger.com/badges/version/crazymax/firefox-syncserver.svg?style=flat-square" alt="Version"></a>
  <a href="https://travis-ci.org/crazy-max/docker-firefox-syncserver"><img src="https://img.shields.io/travis/crazy-max/docker-firefox-syncserver/master.svg?style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/firefox-syncserver/"><img src="https://img.shields.io/docker/stars/crazymax/firefox-syncserver.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/firefox-syncserver/"><img src="https://img.shields.io/docker/pulls/crazymax/firefox-syncserver.svg?style=flat-square" alt="Docker Pulls"></a>
  <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YY7W3WDEPHCPQ"><img src="https://img.shields.io/badge/donate-paypal-7057ff.svg?style=flat-square" alt="Donate Paypal"></a>
</p>

## About

[Firefox Sync Server](http://moz-services-docs.readthedocs.io/en/latest/howtos/run-sync-1.5.html) image for Docker based on [Sync Server 1.6.0](https://github.com/mozilla-services/syncserver).<br />

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

## How can i help ?

We welcome all kinds of contributions :raised_hands:!<br />
The most basic way to show your support is to star :star2: the project, or to raise issues :speech_balloon:<br />
Any funds donated will be used to help further development on this project! :gift_heart:

[![Donate Paypal](https://raw.githubusercontent.com/crazy-max/docker-firefox-syncserver/master/res/paypal.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YY7W3WDEPHCPQ)

## License

MIT. See `LICENSE` for more details.
