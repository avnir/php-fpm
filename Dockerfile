FROM ubuntu:18.04
MAINTAINER Avni Rexhepi <arexhepi@gmail.com>


#ENV locale-gen EN_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV TERM="xterm"
#ENV LANG EN_US.UTF-8
#ENV LC_ALL EN_US.UTF-8


RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y software-properties-common ca-certificates
RUN add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
    php7.3-bcmath \
    php7.3-cli \
    php7.3-curl \
    php7.3-fpm \
    php7.3-gd \
    php7.3-json \
    php7.3-mbstring \
    php7.3-memcached \
    php7.3-mysql \
    php7.3-pdo \
    php7.3-xml \
    php7.3-zip \
    make \
    mysql-client \
    zip \
    unzip && \
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


# We need to create an empty file, otherwise the volume will belong to root.
RUN mkdir -p /var/www/ && touch /var/www/placeholder && chown -R www-data:www-data /var/www


VOLUME /var/www
WORKDIR /var/www
EXPOSE 9000

CMD ["php-fpm7.3"]