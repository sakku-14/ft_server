FROM debian:buster
RUN set -ex; \
	apt-get update; \
	apt-get -y install wget curl vim openssl \
		nginx \
		mariadb-server mariadb-client \
		php-cgi php-common php-fpm php-pear php-mbstring php-zip php-net
	rm -rf /var/lib/apt/lists
