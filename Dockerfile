FROM ubuntu:18.04
MAINTAINER Avni Rexhepi <arexhepi@gmail.com>


ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LANG C.UTF-8
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


RUN apt-get update && apt-get -qy upgrade && \
    apt-get install -qy --no-install-recommends \
            ca-certificates \
            php7.2-cli \
            php7.2-gd \
            php7.2-curl \
            php7.2-mysql \
            php7.2-fpm \
            php7.2-imap \
            php7.2-json \
            php7.2-xml \
            php7.2-mbstring \
            php-memcached \
            mysql-client \
            zip \
            unzip && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN sed -i \
        -e "s~^display_errors.*$~display_errors = Off~g" \
        -e "s~^display_startup_errors.*$~display_startup_errors = Off~g" \
        -e "s~^track_errors.*$~track_errors = Off~g" \
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


RUN echo "zend_extension=opcache.so" >> /etc/php/7.2/fpm/php.ini
RUN echo "\n\nopcache.memory_consumption=128" >> /etc/php/7.2/mods-available/opcache.ini && \
    echo "opcache.interned_strings_buffer=8" >> /etc/php/7.2/mods-available/opcache.ini && \
    echo "opcache.max_accelerated_files=4000" >> /etc/php/7.2/mods-available/opcache.ini && \
    echo "opcache.revalidate_freq=60" >> /etc/php/7.2/mods-available/opcache.ini && \
    echo "opcache.fast_shutdown=1" >> /etc/php/7.2/mods-available/opcache.ini && \
    echo "opcache.enable_file_override=1" >> /etc/php/7.2/mods-available/opcache.ini && \
    echo "opcache.save_comments=0" >> /etc/php/7.2/mods-available/opcache.ini


# We need to create an empty file, otherwise the volume will belong to root.
RUN mkdir -p /var/www/ && touch /var/www/placeholder && chown -R www-data:www-data /var/www


VOLUME /var/www
WORKDIR /var/www


EXPOSE 9000


CMD ["/usr/sbin/php-fpm7.2", "-FO"]