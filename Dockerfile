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
 echo "**** install heimdall ****" && \
 mkdir -p \
	/var/www/localhost/heimdall && \
 git clone \
	https://github.com/linuxserver/Heimdall.git \
	/var/www/localhost/heimdall && \
 echo "** cleanup **" && \
 rm -rf \
 /tmp/*

# add local files
COPY root/ /
