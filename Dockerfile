FROM ubuntu:latest
MAINTAINER Avni Rexhepi <arexhepi@gmail.com>


ENV TERM xterm
ENV LANG C.UTF-8


RUN apt-get update && apt-get install -y \
            php7.0-cli \
            php7.0-gd \
            php7.0-curl \
            php7.0-mcrypt \
            php7.0-mysql \
            php7.0-fpm \
            php7.0-imap \
            php7.0-json \
            php7.0-xml \
            php7.0-mbstring \
            php7.0-sqlite3 \
            php-memcached \
            mysql-client \
            zip \
            unzip \
            --no-install-recommends && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


VOLUME /var/www
WORKDIR /var/www


EXPOSE 9000


CMD ["/usr/sbin/php-fpm7.0", "-FO"]