FROM lsiobase/alpine.nginx:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
ARG HEIMDALL_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
	APP_NAME=Heimdall

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	curl \
	php7-ctype \
	php7-pdo_sqlite \
	php7-tokenizer \
	tar && \
 echo "**** install heimdall ****" && \
 mkdir -p \
	/var/www/localhost/heimdall && \
 if [ -z ${HEIMDALL_RELEASE+x} ]; then \
 	HEIMDALL_RELEASE=$(curl -sX GET "https://api.github.com/repos/linuxserver/Heimdall/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /tmp/heimdall.tar.gz -L \
	"https://github.com/linuxserver/Heimdall/archive/${HEIMDALL_RELEASE}.tar.gz" && \
 tar xf \
 /tmp/heimdall.tar.gz -C \
	/var/www/localhost/heimdall --strip-components=1 && \
 echo "**** configure nginx ****" && \
 echo -e '\n# Heimdall user authorization\nfastcgi_param  PHP_AUTH_USER $remote_user;\nfastcgi_param  PHP_AUTH_PW $http_authorization;' >> \
	/etc/nginx/fastcgi_params && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /
