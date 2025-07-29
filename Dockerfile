# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.22

# set version label
ARG BUILD_DATE
ARG VERSION
ARG HEIMDALL_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    php84-dom \
    php84-intl \
    php84-opcache \
    php84-pdo_mysql \
    php84-pdo_pgsql \
    php84-pdo_sqlite \
    php84-tokenizer && \
  echo "**** configure nginx ****" && \
  echo 'fastcgi_param  PHP_AUTH_USER      $remote_user; # Heimdall user authorization' >> \
    /etc/nginx/fastcgi_params && \
  echo 'fastcgi_param  PHP_AUTH_PW        $http_authorization; # Heimdall user authorization' >> \
    /etc/nginx/fastcgi_params && \
  echo "**** configure php opcache ****" && \
  echo 'opcache.validate_timestamps=0' >> \
    /etc/php84/conf.d/00_opcache.ini && \
  echo "**** configure php-fpm to pass env vars ****" && \
  sed -E -i 's/^;?clear_env ?=.*$/clear_env = no/g' /etc/php84/php-fpm.d/www.conf && \
  if ! grep -qxF 'clear_env = no' /etc/php84/php-fpm.d/www.conf; then echo 'clear_env = no' >> /etc/php84/php-fpm.d/www.conf; fi && \
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> /etc/php84/php-fpm.conf && \
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
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
