FROM ubuntu:18.04
MAINTAINER Avni Rexhepi <arexhepi@gmail.com>

ENV DEBIAN_FRONTEND noninteractive\
TERM="xterm" \
LANG C.UTF-8 \
PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


RUN apt-get update && apt-get -qy upgrade && \
    apt-get install -qy --no-install-recommends \
            ca-certificates \
            php-cli \
            php-curl \
            php-fpm \
            php-gd \
            php-imap \
            php-json \
            php-mbstring \
            php-mongodb \
            php-mysql \
            php-pdo \
            php-xml \
            php-zip \
            php-memcached \
            mysql-client \
            zip \
            unzip && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN sed -i \
        -e "s~^;cgi.fix_pathinfo.*$~cgi.fix_pathinfo=0~g" \
            /etc/php/7.2/fpm/php.ini


RUN sed -i \
        -e "s/^pid\(.*\)/pid = run\/php-fpm.pid/g" \
        -e "s/^;pid\(.*\)/pid = run\/php-fpm.pid/g" \
        -e "s~^;daemonize = yes*$~daemonize = no~g" \
            /etc/php/7.2/fpm/php-fpm.conf


RUN sed -i \
        -e "s/^group = nobody/group = www-data/g" \
        -e "s/^user = nobody/user = www-data/g" \
        -e "s/^;listen.owner = nobody/listen.owner = www-data/g" \
        -e "s/^;listen.group = nogroup/listen.group = www-data/g" \
        -e "s/^listen\(.*\)/listen = 0.0.0.0:9000/g" \
            /etc/php/7.2/fpm/pool.d/www.conf


# We need to create an empty file, otherwise the volume will belong to root.
RUN mkdir -p /var/www/ && touch /var/www/placeholder && chown -R www-data:www-data /var/www


VOLUME /var/www
WORKDIR /var/www


EXPOSE 9000


CMD ["/usr/sbin/php-fpm7.2", "-FO"]