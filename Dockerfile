FROM python:2.7-slim
MAINTAINER CrazyMax <crazy-max@users.noreply.github.com>

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="firefox-syncserver" \
  org.label-schema.description="Firefox Sync Server" \
  org.label-schema.version=$VERSION \
  org.label-schema.url="https://github.com/crazy-max/docker-firefox-syncserver" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/crazy-max/docker-firefox-syncserver" \
  org.label-schema.vendor="CrazyMax" \
  org.label-schema.schema-version="1.0"

ENV SYNCSERVER_VERSION="1.8.0" \
  SHA1_COMMIT="34344d8b961e1518c7044acaa3c28006bf0c6815"

ADD entrypoint.sh /entrypoint.sh

RUN apt-get update \
  && apt-get install -y --no-install-recommends git g++ \
  && git clone https://github.com/mozilla-services/syncserver app \
  && cd app \
  && git reset --hard $SHA1_COMMIT \
  && pip install --upgrade --no-cache-dir -r requirements.txt \
  && pip install --upgrade --no-cache-dir -r dev-requirements.txt \
  && apt-get -y remove g++ git \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && python ./setup.py develop \
  && chmod a+x /entrypoint.sh

EXPOSE 5000
VOLUME [ "/data" ]

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "/usr/local/bin/gunicorn", "--paste", "/data/syncserver.ini" ]
