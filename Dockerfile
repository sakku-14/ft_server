FROM debian:buster
#RUN set -ex; \
RUN	apt update -y && \
	apt upgrade -y && \
	apt-get install nginx \
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
	git \
	vim -y
#	apt-get -y install wget curl vim openssl;# \
#		nginx \
#		mariadb-server mariadb-client \
#		php-cgi php-common php-fpm php-pear php-mbstring php-zip php-net
#	rm -rf /var/lib/apt/lists
#CMD ["nginx", "-g", "daemon off;"]
#RUN apt-get update && apt-get install -y nginx
#EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
