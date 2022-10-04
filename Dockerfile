FROM ubuntu:22.10
LABEL maintainer="arexhepi@gmail.com"


RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        php8.1 \
        php8.1-cli \
        php8.1-curl \
        php8.1-fpm \
        php8.1-gd \
        php8.1-ldap \
        php8.1-mbstring \
        php8.1-opcache \
        php8.1-readline \
        php8.1-xml \
        php8.1-memcached \
        php8.1-mysql \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


RUN sed -i \
    -e "s~^;cgi.fix_pathinfo.*$~cgi.fix_pathinfo=0~g" \
    /etc/php/8.1/fpm/php.ini


RUN sed -i \
    -e "s/^pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s/^;pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s~^;daemonize = yes*$~daemonize = no~g" \      
    /etc/php/8.1/fpm/php-fpm.conf


RUN sed -i \
    -e "s/^group = nobody/group = www-data/g" \
    -e "s/^user = nobody/user = www-data/g" \
    -e "s/^;listen.owner = nobody/listen.owner = www-data/g" \
    -e "s/^;listen.group = nogroup/listen.group = www-data/g" \
    -e "s/^listen\(.*\)/listen = 0.0.0.0:9000/g" \
    -e "s/^;security.limit_extensions = */security.limit_extensions = /g" \
    /etc/php/8.1/fpm/pool.d/www.conf


RUN printf "set nowrap\nset tabsize 2" > /etc/nanorc
RUN printf "set completion-ignore-case On" >> /etc/inputrc


STOPSIGNAL SIGQUIT
EXPOSE 9000


CMD ["php-fpm"]