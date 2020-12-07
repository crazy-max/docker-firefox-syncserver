FROM --platform=${TARGETPLATFORM:-linux/amd64} python:2.7-alpine3.10

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN printf "I am running on ${BUILDPLATFORM:-linux/amd64}, building for ${TARGETPLATFORM:-linux/amd64}\n$(uname -a)\n"

LABEL maintainer="CrazyMax"

ENV SYNCSERVER_VERSION="1.8.0" \
  SHA1_COMMIT="5932c464d70ec9cf0344b1d3e970b3711de6a98e" \
  TZ="UTC" \
  PUID="1000" \
  PGID="1000"

RUN apk --update --no-cache add \
    bash \
    curl \
    libffi \
    libressl \
    libstdc++ \
    shadow \
    su-exec \
    tzdata \
    postgresql-dev \
  && apk --update --no-cache add -t build-dependencies \
    build-base \
    git \
    libffi-dev \
    libressl-dev \
    gcc \
    python-dev \
    musl-dev \
  && git clone https://github.com/mozilla-services/syncserver app \
  && cd app \
  && git reset --hard $SHA1_COMMIT \
  && pip install pymysql \
  && pip install --upgrade --no-cache-dir -r requirements.txt \
  && pip install --upgrade --no-cache-dir -r dev-requirements.txt \
  && pip install psycopg2 \
  && apk del build-dependencies \
  && rm -rf /tmp/* /var/cache/apk/* \
  && python ./setup.py develop

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
