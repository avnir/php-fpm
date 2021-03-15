FROM ubuntu:20.04
LABEL maintainer="arexhepi@gmail.com"


ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update \
    && apt-get install software-properties-common -y \
    && add-apt-repository ppa:ondrej/php

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        php8.0 \
        php8.0-cli \
        php8.0-curl \
        php8.0-fpm \
        php8.0-gd \
        php8.0-ldap \
        php8.0-mbstring \
        php8.0-opcache \
        php8.0-readline \
        php8.0-xml \
        php8.0-memcached \
        php8.0-mysql \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


RUN sed -i \
    -e "s~^;cgi.fix_pathinfo.*$~cgi.fix_pathinfo=0~g" \
    /etc/php/8.0/fpm/php.ini


RUN sed -i \
    -e "s/^pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s/^;pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s~^;daemonize = yes*$~daemonize = no~g" \      
    /etc/php/8.0/fpm/php-fpm.conf


RUN sed -i \
    -e "s/^group = nobody/group = www-data/g" \
    -e "s/^user = nobody/user = www-data/g" \
    -e "s/^;listen.owner = nobody/listen.owner = www-data/g" \
    -e "s/^;listen.group = nogroup/listen.group = www-data/g" \
    -e "s/^listen\(.*\)/listen = 0.0.0.0:9000/g" \
    -e "s/^;security.limit_extensions = */security.limit_extensions = /g" \
    /etc/php/8.0/fpm/pool.d/www.conf


RUN printf "set nowrap\nset tabsize 2" > /etc/nanorc
RUN printf "set completion-ignore-case On" >> /etc/inputrc


EXPOSE 9000


CMD ["php-fpm8.0"]