<p align="center"><a href="https://github.com/crazy-max/docker-firefox-syncserver" target="_blank"><img height="128" src="https://raw.githubusercontent.com/crazy-max/docker-firefox-syncserver/master/.github/docker-firefox-syncserver.jpg"></a></p>

<p align="center">
  <a href="https://hub.docker.com/r/crazymax/firefox-syncserver/tags?page=1&ordering=last_updated"><img src="https://img.shields.io/github/v/tag/crazy-max/docker-firefox-syncserver?label=version&style=flat-square" alt="Latest Version"></a>
  <a href="https://github.com/crazy-max/docker-firefox-syncserver/actions?workflow=build"><img src="https://img.shields.io/github/workflow/status/crazy-max/docker-firefox-syncserver/build?label=build&logo=github&style=flat-square" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/crazymax/firefox-syncserver/"><img src="https://img.shields.io/docker/stars/crazymax/firefox-syncserver.svg?style=flat-square&logo=docker" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/crazymax/firefox-syncserver/"><img src="https://img.shields.io/docker/pulls/crazymax/firefox-syncserver.svg?style=flat-square&logo=docker" alt="Docker Pulls"></a>
  <br /><a href="https://github.com/sponsors/crazy-max"><img src="https://img.shields.io/badge/sponsor-crazy--max-181717.svg?logo=github&style=flat-square" alt="Become a sponsor"></a>
  <a href="https://www.paypal.me/crazyws"><img src="https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square" alt="Donate Paypal"></a>
</p>

## About

[Firefox Sync Server](http://moz-services-docs.readthedocs.io/en/latest/howtos/run-sync-1.5.html) Docker image based on Python Alpine Linux.<br />
If you are interested, [check out](https://hub.docker.com/r/crazymax/) my other Docker images!

💡 Want to be notified of new releases? Check out 🔔 [Diun (Docker Image Update Notifier)](https://github.com/crazy-max/diun) project!

___

* [Features](#features)
* [Image](#image)
* [Environment variables](#environment-variables)
* [Volumes](#volumes)
* [Ports](#ports)
* [Usage](#usage)
  * [Docker Compose](#docker-compose)
  * [Command line](#command-line)
* [Upgrade](#upgrade)
* [Notes](#notes)
  * [Use with MySQL database](#use-with-mysql-database)
* [How can I help?](#how-can-i-help)
* [License](#license)

## Features

* Run as non-root user
* Multi-platform image
* [Traefik](https://github.com/containous/traefik-library-image) as reverse proxy and creation/renewal of Let's Encrypt certificates (see [this template](examples/traefik))

## Image

| Registry                                                                                         | Image                           |
|--------------------------------------------------------------------------------------------------|---------------------------------|
| [Docker Hub](https://hub.docker.com/r/crazymax/firefox-syncserver/)                                            | `crazymax/firefox-syncserver`                 |
| [GitHub Container Registry](https://github.com/users/crazy-max/packages/container/package/firefox-syncserver)  | `ghcr.io/crazy-max/firefox-syncserver`        |

Following platforms for this image are available:

```
$ docker run --rm mplatform/mquery crazymax/firefox-syncserver:latest
Image: crazymax/firefox-syncserver:latest
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v6
   - linux/arm/v7
   - linux/arm64
   - linux/386
   - linux/ppc64le
   - linux/s390x
```

## Environment variables

* `TZ`: The timezone assigned to the container (default `UTC`)
* `PUID`: Process UID (default `1000`)
* `PGID`: Process GID (default `1000`)
* `FF_SYNCSERVER_ACCESSLOG`: Display access log (default `false`)
* `FF_SYNCSERVER_LOGLEVEL`: Log level output (default `info`)
* `FF_SYNCSERVER_PUBLIC_URL`: Must be edited to point to the public URL of your server (default `http://localhost:5000`).
* `FF_SYNCSERVER_SECRET`: This is a secret key used for signing authentication tokens. It should be long and randomly-generated.
* `FF_SYNCSERVER_ALLOW_NEW_USERS`: Set this to `false` to disable new-user signups on the server. Only request by existing accounts will be honoured (default `true`).
* `FF_SYNCSERVER_FORCE_WSGI_ENVIRON`: Set this to `true` to work around a mismatch between public_url and the application URL as seen by python, which can happen in certain reverse-proxy hosting setups (default `false`).
* `FF_SYNCSERVER_SQLURI`: Defines the database in which to store all server data (default `sqlite:///data/syncserver.db`).
* `FF_SYNCSERVER_FORWARDED_ALLOW_IPS`: Set this to `*` or an IP range if you use an Nginx reverse proxy (optional). 

> 💡 `FF_SYNCSERVER_SECRET_FILE` can be used to fill in the value from a file, especially for Docker's secrets feature.

## Volumes

* `/data`: Contains SQLite database if `FF_SYNCSERVER_SQLURI` is untouched

> :warning: Note that the volumes should be owned by the user/group with the specified `PUID` and `PGID`. If you don't give the volume correct permissions, the container may not start.

## Ports

* `5000`: Gunicorn port

## Usage

### Docker Compose

Docker compose is the recommended way to run this image. You can use the following [docker compose template](examples/compose/docker-compose.yml), then run the container:

```bash
docker-compose up -d
docker-compose logs -f
```

### Command line

You can also use the following minimal command:

```bash
$ docker run -d -p 5000:5000 --name firefox_syncserver \
  -e TZ="Europe/Paris" \
  -e FF_SYNCSERVER_SECRET="5up3rS3kr1t" \
  -v $(pwd)/data:/data \
  crazymax/firefox-syncserver:latest
```

## Notes

### Use with MySQL database

Set `FF_SYNCSERVER_SQLURI=pymysql://user:password@mysql_server_ip/db_name`

### Use with PostgreSQL database

Set `FF_SYNCSERVER_SQLURI=postgresql://user:password@postgresql_server_ip/db_name`

## Upgrade

Recreate the container whenever I push an update:

```bash
docker-compose pull
docker-compose up -d
```

## How can I help?

All kinds of contributions are welcome :raised_hands:! The most basic way to show your support is to star :star2:
the project, or to raise issues :speech_balloon: You can also support this project
by [**becoming a sponsor on GitHub**](https://github.com/sponsors/crazy-max) :clap: or by
making a [Paypal donation](https://www.paypal.me/crazyws) to ensure this journey continues indefinitely! :rocket:

Thanks again for your support, it is much appreciated! :pray:

## License

MIT. See `LICENSE` for more details.
