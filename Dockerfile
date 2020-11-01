FROM ubuntu:20.04
LABEL maintainer="arexhepi@gmail.com"


ENV DEBIAN_FRONTEND noninteractive


RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        php7.4-cli \
        php7.4-curl \
        php7.4-fpm \
        php7.4-gd \
        php7.4-json \
        php7.4-ldap \
        php7.4-mbstring \
        php7.4-opcache \
        php7.4-readline \
        php7.4-xml \
        php7.4-memcached \
        php7.4-mysql \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


RUN sed -i \
    -e "s~^;cgi.fix_pathinfo.*$~cgi.fix_pathinfo=0~g" \
    /etc/php/7.4/fpm/php.ini


RUN sed -i \
    -e "s/^pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s/^;pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s~^;daemonize = yes*$~daemonize = no~g" \      
    /etc/php/7.4/fpm/php-fpm.conf


RUN sed -i \
    -e "s/^group = nobody/group = www-data/g" \
    -e "s/^user = nobody/user = www-data/g" \
    -e "s/^;listen.owner = nobody/listen.owner = www-data/g" \
    -e "s/^;listen.group = nogroup/listen.group = www-data/g" \
    -e "s/^listen\(.*\)/listen = 0.0.0.0:9000/g" \
    /etc/php/7.4/fpm/pool.d/www.conf


RUN printf "set nowrap\nset tabsize 2" > /etc/nanorc
RUN printf "set completion-ignore-case On" >> /etc/inputrc


EXPOSE 9000


CMD ["php-fpm7.4"]