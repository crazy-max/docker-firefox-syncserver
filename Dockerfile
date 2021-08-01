ARG SYNCSERVER_VERSION=1.8.0
ARG SHA1_COMMIT=5932c464d70ec9cf0344b1d3e970b3711de6a98e

FROM crazymax/yasu:latest AS yasu
FROM python:2.7-alpine3.10

ARG SYNCSERVER_VERSION
ARG SHA1_COMMIT
RUN apk --update --no-cache add \
    bash \
    curl \
    libffi \
    libressl \
    libstdc++ \
    mariadb-client \
    postgresql-client \
    shadow \
    tzdata \
  && apk --update --no-cache add -t build-dependencies \
    build-base \
    gcc \
    git \
    libffi-dev \
    libressl-dev \
    mariadb-dev \
    musl-dev \
    postgresql-dev \
    python-dev \
  && git clone https://github.com/mozilla-services/syncserver app \
  && cd app \
  && git reset --hard $SHA1_COMMIT \
  && pip install --upgrade --no-cache-dir -r requirements.txt \
  && pip install --upgrade --no-cache-dir -r dev-requirements.txt \
  && pip install psycopg2 pymysql \
  && apk del build-dependencies \
  && rm -rf /tmp/* /var/cache/apk/* \
  && python ./setup.py develop

ENV TZ="UTC" \
  PUID="1000" \
  PGID="1000"

COPY --from=yasu / /
COPY entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh \
  && mkdir -p /data /opt/syncserver \
  && addgroup -g ${PGID} syncserver \
  && adduser -u ${PUID} -G syncserver -h /data -s /bin/sh -D syncserver \
  && chown -R syncserver. /data /opt/syncserver

EXPOSE 5000
VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/local/bin/gunicorn", "--paste", "/opt/syncserver/syncserver.ini" ]
