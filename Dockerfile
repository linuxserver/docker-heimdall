FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.14

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
 apk add --no-cache \
	curl \
	php7-ctype \
	php7-pdo_sqlite \
	php7-tokenizer \
	php7-zip && \
 echo "**** install heimdall ****" && \
 mkdir -p \
	/heimdall && \
 if [ -z ${HEIMDALL_RELEASE+x} ]; then \
 	HEIMDALL_RELEASE=$(curl -sX GET "https://api.github.com/repos/linuxserver/Heimdall/commits/2.x" \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
	/heimdall/heimdall.tar.gz -L \
	"https://github.com/linuxserver/Heimdall/archive/${HEIMDALL_RELEASE}.tar.gz" && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /
