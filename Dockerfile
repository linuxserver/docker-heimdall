FROM lsiobase/alpine.nginx:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

# install packages
RUN \
 apk add --no-cache \
	curl \
	php7-ctype \
	php7-pdo_sqlite \
	php7-tokenizer \
	tar && \
 mkdir -p /app/heimdall && \
 VERSION="$(curl -sX GET https://api.github.com/repos/linuxserver/Heimdall/releases/latest | grep 'tag_name' | cut -d\" -f4)" && \
 echo "**Installing Heimdall ${VERSION}**" && \
 curl -o \
  /tmp/heimdall.tar.gz -L \
  "https://github.com/linuxserver/Heimdall/archive/${VERSION}.tar.gz" && \
 tar xf \
  /tmp/heimdall.tar.gz -C \
  /tmp && \
 cp -R /tmp/Heimdall-*/* /app/heimdall/ && \
 echo "** cleanup **" && \
 rm -rf \
  /tmp/*

# add local files
COPY root/ /
