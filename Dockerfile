FROM --platform=${TARGETPLATFORM:-linux/amd64} python:2.7-alpine3.10

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG FF_SYNCSERVER_SQL_DRIVER=mysql

ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN printf "I am running on ${BUILDPLATFORM:-linux/amd64}, building for ${TARGETPLATFORM:-linux/amd64}\n$(uname -a)\n"

LABEL maintainer="CrazyMax" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.url="https://github.com/crazy-max/docker-firefox-syncserver" \
  org.opencontainers.image.source="https://github.com/crazy-max/docker-firefox-syncserver" \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$VCS_REF \
  org.opencontainers.image.vendor="CrazyMax" \
  org.opencontainers.image.title="Firefox Sync Server" \
  org.opencontainers.image.description="Firefox Sync Server" \
  org.opencontainers.image.licenses="MIT"

ENV SYNCSERVER_VERSION="1.8.0" \
  SHA1_COMMIT="e1aab54cbcb6e570979835789f7b4624eebdc875" \
  TZ="UTC" \
  PUID="1000" \
  PGID="1000"

RUN \
  EXTRA_PIP_PACKAGES="" \
  && EXTRA_BUILD_DEPS="" \
  && if [ "$FF_SYNCSERVER_SQL_DRIVER" = "mysql" ]; then \
    EXTRA_PIP_PACKAGES="${EXTRA_PIP_PACKAGES} pymysql"; \
    EXTRA_BUILD_DEPS="${EXTRA_BUILD_DEPS} mariadb-dev"; \
  elif [ "$FF_SYNCSERVER_SQL_DRIVER" = "postgresql" ]; then \
    EXTRA_PIP_PACKAGES="${EXTRA_PIP_PACKAGES} pymysql"; \
    EXTRA_BUILD_DEPS="${EXTRA_BUILD_DEPS} postgresql-dev"; \
  elif [ "$FF_SYNCSERVER_SQL_DRIVER" = "sqlite" ]; then \
    EXTRA_PIP_PACKAGES="${EXTRA_PIP_PACKAGES} pysqlite"; \
    EXTRA_BUILD_DEPS="${EXTRA_BUILD_DEPS} sqlite-dev"; \
  fi \
  && apk --update --no-cache add \
    bash \
    curl \
    libffi \
    libressl \
    libstdc++ \
    shadow \
    su-exec \
    tzdata \
  && apk --update --no-cache add -t build-dependencies \
    build-base \
    git \
    libffi-dev \
    libressl-dev \
    sqlite-dev \
    ${EXTRA_BUILD_DEPS} \
  && git clone https://github.com/mozilla-services/syncserver app \
  && cd app \
  && git reset --hard $SHA1_COMMIT \
  &&  \
  if [ "$EXTRA_PIP_PACKAGES" != "" ]; then \
    pip install $EXTRA_PIP_PACKAGES; \
  fi \
  && pip install --upgrade --no-cache-dir -r requirements.txt \
  && pip install --upgrade --no-cache-dir -r dev-requirements.txt \
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
