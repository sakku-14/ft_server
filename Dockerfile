FROM debian:buster

RUN	set -eux; \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			ca-certificates \
			mariadb-client \
			mariadb-server \
			nginx \
			openssl \
			php-bcmath \
			php-cgi \
			php-common \
			php-fpm \
			php-gd \
			php-gettext \
			php-mbstring \
			php-mysql \
			php-net-socket \
			php-pear \
			php-xml-util \
			php-zip \
			supervisor \
			wget; \
		rm -rf /var/lib/apt/lists/*;

ENV	DB_NAME=wpdb \
	USER_NAME=wpuser \
	HOST_NAME=localhost \
	PASSWORD=wppassword

RUN	set -eux; \
		service mysql start; \
		mysql -e "CREATE DATABASE $DB_NAME"; \
		mysql -e "GRANT ALL ON $DB_NAME.* to '$USER_NAME'@'$HOST_NAME' identified by '$PASSWORD';";

ENV	WP_PATH=/var/www/html/wordpress \
	WP_TAR=wordpress.tar.gz \
	WP_URL=https://ja.wordpress.org/latest-ja.tar.gz \
	PHPMA_PATH=/var/www/html/phpmyadmin \
	PHPMA_TAR=phpMyAdmin.tar.gz \
	PHPMA_URL=https://files.phpmyadmin.net/phpMyAdmin/5.0.4/phpMyAdmin-5.0.4-all-languages.tar.gz

RUN	set -eux; \
		mkdir -p $WP_PATH; \
		wget -O $WP_TAR $WP_URL; \
		tar -xvf $WP_TAR -C $WP_PATH --strip-components=1; \
		rm $WP_TAR; \
		mkdir -p $PHPMA_PATH; \
		wget -O $PHPMA_TAR $PHPMA_URL; \
		tar -xvf $PHPMA_TAR -C $PHPMA_PATH --strip-components=1; \
		rm $PHPMA_TAR; \
		rm $PHPMA_PATH/config.sample.inc.php;

COPY	./srcs/wp-config.php $WP_PATH/wp-config.php
COPY	./srcs/config.inc.php $PHPMA_PATH/config.inc.php

RUN	chown -R www-data:www-data /var/www/html/*;

ENV	SSL_PATH=/etc/nginx/ssl \
	KEY=server.key \
	CSR=server.csr \
	CRT=server.crt

RUN	set -eux; \
		mkdir -p $SSL_PATH; \
		openssl genrsa \
			-out "$SSL_PATH/$KEY" 2048; \
		openssl req -new \
			-subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42Tokyo/OU=42cursus/CN=localhost" \
			-key "$SSL_PATH/$KEY" \
			-out "$SSL_PATH/$CSR"; \
		openssl x509 -req \
			-days 3650 \
			-signkey "$SSL_PATH/$KEY" \
			-in "$SSL_PATH/$CSR" \
			-out "$SSL_PATH/$CRT";

COPY	./srcs/default.tmpl /etc/nginx/sites-available/default.tmpl

ENV	E_KIT_URL=https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz \
	E_KIT_TAR=entrykit.tgz \
	E_KIT_PATH=/bin

RUN	set -eux; \
		wget -O $E_KIT_TAR $E_KIT_URL; \
		tar -xvf $E_KIT_TAR -C $E_KIT_PATH; \
		rm $E_KIT_TAR; \
		chmod +x $E_KIT_PATH/entrykit; \
		entrykit --symlink;

COPY	./srcs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN	chmod +x /etc/supervisor/conf.d/supervisord.conf;

ENTRYPOINT	["render", "/etc/nginx/sites-available/default", "--", "/usr/bin/supervisord"]

EXPOSE 80 443
