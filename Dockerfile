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
			wget \
			vim;
#		rm -rf /var/lib/apt/lists
#RUN apt-get update && apt-get install -y nginx
#EXPOSE 8080 433
CMD ["nginx", "-g", "daemon off;"]
