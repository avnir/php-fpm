FROM ubuntu:20.04
MAINTAINER Avni Rexhepi <arexhepi@gmail.com>


ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests gnupg \
    && echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu bionic main" > /etc/apt/sources.list.d/ondrej-php.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4F4EA0AAE5267A6C


RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        curl \
        php7.0-cli \
        php7.0-curl \
        php7.0-fpm \
        php7.0-gd \
        php7.0-json \
        php7.0-opcache \
        php7.0-readline \
        php7.0-xml \
        php7.0-zip \
        php7.0-mbstring \
        php7.0-mcrypt \
        php7.0-mysql \
        php-memcached \
        php-xdebug \
        mysql-client \
        zip \
        unzip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer clear-cache \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN sed -i \
        -e "s~^;cgi.fix_pathinfo.*$~cgi.fix_pathinfo=0~g" \
            /etc/php/7.0/fpm/php.ini


RUN sed -i \
        -e "s/^pid\(.*\)/pid = run\/php-fpm.pid/g" \
        -e "s/^;pid\(.*\)/pid = run\/php-fpm.pid/g" \
        -e "s~^;daemonize = yes*$~daemonize = no~g" \
        /etc/php/7.0/fpm/php-fpm.conf


RUN sed -i \
        -e "s/^group = nobody/group = www-data/g" \
        -e "s/^user = nobody/user = www-data/g" \
        -e "s/^;listen.owner = nobody/listen.owner = www-data/g" \
        -e "s/^;listen.group = nogroup/listen.group = www-data/g" \
        -e "s/^listen\(.*\)/listen = 0.0.0.0:9000/g" \
        /etc/php/7.0/fpm/pool.d/www.conf


RUN printf "set nowrap\nset tabsize 2" > /etc/nanorc
RUN printf "set completion-ignore-case On" >> /etc/inputrc


ADD start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container


EXPOSE 9000


ENTRYPOINT ["start-container"]
CMD ["php-fpm7.0"]