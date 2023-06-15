FROM ubuntu:22.04
LABEL maintainer="arexhepi@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y gnupg gosu curl make zip unzip ca-certificates zip unzip libcap2-bin libpng-dev python2 dnsutils \
    && curl -sS 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c' | gpg --dearmor | tee /usr/share/keyrings/ppa_ondrej_php.gpg > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/ppa_ondrej_php.gpg] https://ppa.launchpadcontent.net/ondrej/php/ubuntu jammy main" > /etc/apt/sources.list.d/ppa_ondrej_php.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        php8.2-bcmath \
        php8.2-cli \
        php8.2-curl \
        php8.2-dev \
        php8.2-gd \
        php8.2-igbinary \
        php8.2-imagick \
        php8.2-imap \
        php8.2-intl \
        php8.2-ldap \
        php8.2-mbstring \
        php8.2-memcached \
        php8.2-msgpack \
        php8.2-mysql \
        php8.2-pcov \
        php8.2-readline \
        php8.2-redis \
        php8.2-soap \
        php8.2-swoole \
        php8.2-xdebug \
        php8.2-xml \
        php8.2-zip \
        php8.2-fpm \
    && apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


RUN sed -i \
    -e "s~^;cgi.fix_pathinfo.*$~cgi.fix_pathinfo=0~g" \
    /etc/php/8.2/fpm/php.ini


RUN sed -i \
    -e "s/^pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s/^;pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s~^;daemonize = yes*$~daemonize = no~g" \      
    /etc/php/8.2/fpm/php-fpm.conf


RUN sed -i \
    -e "s/^group = nobody/group = www-data/g" \
    -e "s/^user = nobody/user = www-data/g" \
    -e "s/^;listen.owner = nobody/listen.owner = www-data/g" \
    -e "s/^;listen.group = nogroup/listen.group = www-data/g" \
    -e "s/^listen\(.*\)/listen = 0.0.0.0:9000/g" \
    -e "s/^;security.limit_extensions = */security.limit_extensions = /g" \
    /etc/php/8.2/fpm/pool.d/www.conf


RUN printf "set nowrap\nset tabsize 2" > /etc/nanorc
RUN printf "set completion-ignore-case On" >> /etc/inputrc


STOPSIGNAL SIGQUIT
EXPOSE 9000


CMD ["php-fpm"]