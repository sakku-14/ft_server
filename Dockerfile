FROM debian:buster
RUN	set -ex; \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			apt-utils \
			ca-certificates \
			mariadb-client \
			mariadb-server \
			nginx \
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
		rm -rf /var/lib/apt/lists/*

ENV	DB			wpdb
ENV	USER		wpuser
ENV	HOST		localhost
ENV	PASSWORD	dbpassword

RUN	set -eux; \
		service mysql start; \
		mysql -e "CREATE DATABASE $DB;"; \
		mysql -e "CREATE USER '$USER'@'$HOST' IDENTIFIED BY '$PASSWORD';"; \
		mysql -e "GRANT ALL ON $DB.* TO '$USER'@'$HOST';"

ENV	WP_URL	https://wordpress.org/latest.tar.gz
ENV	WP_PATH	/var/www/html/wordpress

RUN	set -eux; \
		wget -O wordpress.tar.gz "$WP_URL"; \
		mkdir -p "$WP_PATH"; \
		tar -xzf wordpress.tar.gz -C "$WP_PATH" --strip-components=1; \
		rm wordpress.tar.gz; \
		chown -R www-data:www-data "$WP_PATH"

COPY	./srcs/wp-config.php "$WP_PATH/wp-config.php"

RUN	chmod 777 "$WP_PATH/wp-config.php"

ENV	PHPMA_VER	5.0.2
ENV	PHPMA_URL	https://files.phpmyadmin.net/phpMyAdmin/$PHPMA_VER/phpMyAdmin-$PHPMA_VER-all-languages.tar.gz
ENV	PHPMA_PATH	/var/www/html/phpmyadmin

RUN	set -eux; \
		wget -O phpmyadmin.tar.gz "$PHPMA_URL"; \
		mkdir -p "$PHPMA_PATH"; \
		tar -xzf phpmyadmin.tar.gz -C "$PHPMA_PATH" --strip-components=1; \
		rm phpmyadmin.tar.gz

ENV	SSL_PATH	/etc/nginx/ssl
ENV	KEY	server.key
ENV	CSR	server.csr
ENV	CRT	server.crt

RUN	set -eux; \
		mkdir -p "$SSL_PATH"; \
		openssl genrsa -out "$SSL_PATH/$KEY" 2048; \
		openssl req -new \
			-subj "/C=JP/ST=Tokyo/L=Minato-ku/O=42Tokyo/OU=42cursus/CN=localhost" \
			-key "$SSL_PATH/$KEY" \
			-out "$SSL_PATH/$CSR"; \
		openssl x509 -req \
			-days 3650 \
			-signkey "$SSL_PATH/$KEY" \
			-in "$SSL_PATH/$CSR" \
			-out "$SSL_PATH/$CRT"

COPY	./srcs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN	chmod +x /etc/supervisor/conf.d/supervisord.conf

ENV	E_KIT_URL	https://github.com/progrium/entrykit/releases/download/v0.4.0/entrykit_0.4.0_Linux_x86_64.tgz
ENV	E_KIT_PATH	/bin

RUN	set -eux; \
		wget -O entrykit.tgz "$E_KIT_URL"; \
		tar -xzf entrykit.tgz -C "$E_KIT_PATH"; \
		rm entrykit.tgz; \
		chmod +x "$E_KIT_PATH/entrykit"; \
		entrykit --symlink

COPY	./srcs/default.tmpl /etc/nginx/sites-available/default.tmpl
ENTRYPOINT	["render", "/etc/nginx/sites-available/default", "--", "/usr/bin/supervisord"]

EXPOSE	80 443
