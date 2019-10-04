# Changelog

## 1.8.0-RC10 (2019/09/26)

* Switch to GitHub Actions
* Stop publishing Docker image on Quay
* Multi-platform Docker image
* mozilla-services/syncserver@e9b63a0
* Run as non-root user
* Fix access log issue if not defined
* Implicit timezone through tzdata package

> :warning: **UPGRADE NOTES**
> As the Docker container runs as a non-root user, you have to first stop the container and change permissions to `data` volume:
> ```
> docker-compose stop
> chown -R 1000:1000 data/
> docker-compose pull
> docker-compose up -d
> ```

## 1.8.0-RC9 (2019/08/05)

* Option to enable access log (`FF_SYNCSERVER_ACCESSLOG`)
* Option to tune log level (`FF_SYNCSERVER_LOGLEVEL`)
* Issue with healthcheck, remove for now (Issue #10)

## 1.8.0-RC8 (2019/08/04)

* Add healthcheck
* Alpine Linux 3.10

## 1.8.0-RC7 (2019/06/23)

* mozilla-services/syncserver@ac7b29c

## 1.8.0-RC6 (2019/03/21)

* Option to allow forwarded IPs (PR #7)

## 1.8.0-RC5 (2019/03/20)

* Switch to Alpine 3.9 based image

## 1.8.0-RC4 (2019/02/04)

* Fix build issue (see pypa/pip#6158)

## 1.8.0-RC3 (2019/01/22)

* Add `FF_SYNCSERVER_SQLURI` env var (Issue #5)
* No need to put `syncserver.ini` in data folder

## 1.8.0-RC2 (2018/07/27)

* Switch to Alpine 3.8 based image

## 1.8.0-RC1 (2018/05/25)

* Firefox Sync Server 1.8.0

## 1.7.0-RC2 (2018/05/25)

* Come back to Firefox Sync Server 1.7.0

## 1.6.0-RC3 (2018/05/25)

* Wrong tag pushed (1.7.0)
* No need of Supervisor

## 1.7.0-RC1 (2018/02/17)

* Firefox Sync Server 1.7.0
* No need of Supervisor

## 1.6.0-RC2 (2018/01/10)

* Python image updated

## 1.6.0-RC1 (2017/12/25)

* Initial version based on Firefox Sync Server 1.6.0
