FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and PHP 8.3 from official Ubuntu 24.04 repos
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        gosu curl ca-certificates zip unzip libcap2-bin libpng-dev build-essential \
        libxml2-dev libssl-dev libcurl4-openssl-dev pkg-config mysql-client \
        php8.3-bcmath \
        php8.3-cli \
        php8.3-common \
        php8.3-curl \
        php8.3-dev \
        php8.3-fpm \
        php8.3-gd \
        php8.3-intl \
        php8.3-ldap \
        php8.3-mbstring \
        php8.3-mysql \
        php8.3-readline \
        php8.3-soap \
        php8.3-xml \
        php8.3-zip \
        php-pear \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*


# Install build tools and libraries for PECL extensions
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libmagickwand-dev libmemcached-dev zlib1g-dev libpng-dev \
        libwebp-dev libjpeg-dev libfreetype6-dev libzip-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PECL extensions for PHP 8.3, including swoole
RUN pecl install imagick memcached redis xdebug excimer swoole \
    && echo "extension=imagick.so"   > /etc/php/8.3/mods-available/imagick.ini \
    && echo "extension=memcached.so" > /etc/php/8.3/mods-available/memcached.ini \
    && echo "extension=redis.so"     > /etc/php/8.3/mods-available/redis.ini \
    && echo "zend_extension=xdebug.so" > /etc/php/8.3/mods-available/xdebug.ini \
    && echo "extension=excimer.so"   > /etc/php/8.3/mods-available/excimer.ini \
    && echo "extension=swoole.so"   > /etc/php/8.3/mods-available/swoole.ini \
    && ln -s /etc/php/8.3/mods-available/imagick.ini /etc/php/8.3/cli/conf.d/20-imagick.ini \
    && ln -s /etc/php/8.3/mods-available/imagick.ini /etc/php/8.3/fpm/conf.d/20-imagick.ini \
    && ln -s /etc/php/8.3/mods-available/memcached.ini /etc/php/8.3/cli/conf.d/20-memcached.ini \
    && ln -s /etc/php/8.3/mods-available/memcached.ini /etc/php/8.3/fpm/conf.d/20-memcached.ini \
    && ln -s /etc/php/8.3/mods-available/redis.ini /etc/php/8.3/cli/conf.d/20-redis.ini \
    && ln -s /etc/php/8.3/mods-available/redis.ini /etc/php/8.3/fpm/conf.d/20-redis.ini \
    && ln -s /etc/php/8.3/mods-available/xdebug.ini /etc/php/8.3/cli/conf.d/20-xdebug.ini \
    && ln -s /etc/php/8.3/mods-available/xdebug.ini /etc/php/8.3/fpm/conf.d/20-xdebug.ini \
    && ln -s /etc/php/8.3/mods-available/excimer.ini /etc/php/8.3/cli/conf.d/20-excimer.ini \
    && ln -s /etc/php/8.3/mods-available/excimer.ini /etc/php/8.3/fpm/conf.d/20-excimer.ini \
    && ln -s /etc/php/8.3/mods-available/swoole.ini /etc/php/8.3/cli/conf.d/20-swoole.ini \
    && ln -s /etc/php/8.3/mods-available/swoole.ini /etc/php/8.3/fpm/conf.d/20-swoole.ini

RUN sed -i \
    -e "s~^;cgi.fix_pathinfo.*$~cgi.fix_pathinfo=0~g" \
    /etc/php/8.3/fpm/php.ini

RUN sed -i \
    -e "s/^pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s/^;pid\(.*\)/pid = run\/php-fpm.pid/g" \
    -e "s~^;daemonize = yes*$~daemonize = no~g" \
    /etc/php/8.3/fpm/php-fpm.conf

RUN sed -i \
    -e "s/^group = nobody/group = www-data/g" \
    -e "s/^user = nobody/user = www-data/g" \
    -e "s/^;listen.owner = nobody/listen.owner = www-data/g" \
    -e "s/^;listen.group = nogroup/listen.group = www-data/g" \
    -e "s/^listen\(.*\)/listen = 0.0.0.0:9000/g" \
    -e "s/^;security.limit_extensions = */security.limit_extensions = /g" \
    /etc/php/8.3/fpm/pool.d/www.conf

# Configure nano and inputrc
RUN printf "set nowrap\nset tabsize 2" > /etc/nanorc \
    && printf "set completion-ignore-case On" >> /etc/inputrc

STOPSIGNAL SIGQUIT
EXPOSE 9000

CMD ["php-fpm"]