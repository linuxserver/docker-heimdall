# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:arm64v8-3.17

# set version label
ARG BUILD_DATE
ARG VERSION
ARG HEIMDALL_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache --upgrade \
    php81-ctype \
    php81-curl \
    php81-intl \
    php81-pdo_pgsql \
    php81-pdo_sqlite \
    php81-pdo_mysql \
    php81-tokenizer \
    php81-zip && \
  echo "**** configure nginx ****" && \
  echo 'fastcgi_param  PHP_AUTH_USER      $remote_user; # Heimdall user authorization' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  PHP_AUTH_PW        $http_authorization; # Heimdall user authorization' >> \
    /etc/nginx/fastcgi_params && \
  echo "**** install heimdall ****" && \
  mkdir -p \
    /heimdall && \
  if [ -z ${HEIMDALL_RELEASE+x} ]; then \
    HEIMDALL_RELEASE=$(curl -sX GET "https://api.github.com/repos/linuxserver/Heimdall/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/heimdall.tar.gz -L \
    "https://github.com/linuxserver/Heimdall/archive/${HEIMDALL_RELEASE}.tar.gz" && \
  mkdir -p \
    /app/www-tmp && \
  tar xf \
    /tmp/heimdall.tar.gz -C \
    /app/www-tmp --strip-components=1 && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
