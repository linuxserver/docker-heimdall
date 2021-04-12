FROM ghcr.io/linuxserver/baseimage-alpine:3.13

# set version label
ARG BUILD_DATE
ARG VERSION
ARG HEIMDALL_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV \
  HOME="/app/heimdall" \
  NODE_ENV="production"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
  	curl \
  	g++ \
  	make \
  	python2 && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    nodejs \
    npm && \
  echo "**** install heimdall ****" && \
  mkdir -p \
    /app/heimdall && \
  if [ -z ${HEIMDALL_RELEASE+x} ]; then \
    HEIMDALL_RELEASE=$(curl -sX GET "https://api.github.com/repos/linuxserver/heimdalljs/commits/master" \
    | awk '/sha/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/heimdalljs.tar.gz -L \
    "https://github.com/linuxserver/heimdalljs/archive/${HEIMDALL_RELEASE}.tar.gz" && \
  tar xf \
    /tmp/heimdalljs.tar.gz -C \
    /app/heimdall/ --strip-components=1 && \
  cd /app/heimdall && \
  NODE_ENV="development" npm install && \
  cp .env.example .env && \
  npm run build && \
  echo "**** cleanup ****" && \
  npm prune --production && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /root/.cache \
    /tmp/*

# add local files
COPY root/ /
