FROM debian:buster
RUN	set -ex; \
		apt-get update -y; \
		apt-get upgrade -y; \
		apt-get install -y --no-install-recommends \
			ca-certificates \
			nginx \
			mariadb-server \
			mariadb-client \
			php-cgi \
			php-common \
			php-fpm \
			php-pear \
			php-mbstring \
			php-zip \
			php-net-socket \
			php-gd \
			php-xml-util \
			php-gettext \
			php-mysql \
			php-bcmath \
			unzip \
			supervisor \
			wget \
			vim; \
		rm -rf /var/lib/apt/lists/*

RUN	set -eux;
		service mysql start; \
		mysql -e "CREATE DATABASE wpdb;"; \
		mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'dbpassword';"; \
		mysql -e "GRANT ALL ON wpdb.* TO 'wpuser'@'localhost';"


