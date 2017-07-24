FROM lsiobase/alpine.nginx:3.6

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install build packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	autoconf \
	automake \
	g++ \
	gcc \
	libpng-dev \
	libtool \
	make \
	nasm \
	nodejs-npm \
	zlib-dev && \

# install runtime packages
 apk add --no-cache \
	curl \
	libpng \
	nodejs \
	php7-curl \
	php7-dom \
	php7-iconv \
	php7-phar \
	php7-tokenizer \
	zlib && \

# install composer
 curl \
 -sS https://getcomposer.org/installer \
	| php -- --install-dir=/usr/bin --filename=composer && \

# install argus
 mkdir -p \
	/usr/share/webapps/argus && \
 curl -o \
 /tmp/argus.tar.gz -L \
	"https://github.com/linuxserver/Argus/archive/master.tar.gz" && \
 tar xf \
 /tmp/argus.tar.gz -C \
	/usr/share/webapps/argus --strip-components=1 && \
 cd /usr/share/webapps/argus && \
 npm install && \
 composer install && \

# cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root \
	/tmp/* && \
 mkdir -p \
	/root

# add local files
COPY root/ /
