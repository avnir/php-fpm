FROM ubuntu:18.04
LABEL maintainer="arexhepi@gmail.com"


ENV TERM="xterm"


RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y software-properties-common ca-certificates
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    php7.3-bcmath \
    php7.3-cli \
    php7.3-common \
    php7.3-curl \
    php7.3-fpm \
    php7.3-gd \
    php7.3-imap \
    php7.3-json \
    php7.3-mbstring \
    php7.3-memcached \
    php7.3-mysql \
    php7.3-opcache \
    php7.3-pdo \
    php7.3-sqlite3 \
    php7.3-xml \
    php7.3-zip \
    php-xdebug \
    make \
    mysql-client \
    tzdata \
    unzip \
    zip && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN sed -i \
    -e "s~^;cgi.fix_pathinfo.*$~cgi.fix_pathinfo=0~g" \
    /etc/php/7.3/fpm/php.ini


RUN sed -i \
    -e "s/^pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s/^;pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s~^;daemonize = yes*$~daemonize = no~g" \	
    /etc/php/7.3/fpm/php-fpm.conf


RUN sed -i \
    -e "s/^group = nobody/group = www-data/g" \
    -e "s/^user = nobody/user = www-data/g" \
    -e "s/^;listen.owner = nobody/listen.owner = www-data/g" \
    -e "s/^;listen.group = nogroup/listen.group = www-data/g" \
    -e "s/^listen\(.*\)/listen = 0.0.0.0:9000/g" \
    /etc/php/7.3/fpm/pool.d/www.conf


VOLUME /var/www
WORKDIR /var/www
EXPOSE 9000


CMD ["php-fpm7.3"]