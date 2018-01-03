FROM ubuntu:16.04
MAINTAINER Avni Rexhepi <arexhepi@gmail.com>


ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm
ENV LANG C.UTF-8
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


RUN apt-get update && apt-get install -qy software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update && apt-get install -y \
            php5.6-cli \
            php5.6-gd \
            php5.6-curl \
            php5.6-mcrypt \
            php5.6-mysql \
            php5.6-fpm \
            php5.6-imap \
            php5.6-json \
            php5.6-xml \
            php5.6-mbstring \
            php5.6-zip \
            unzip \
            --no-install-recommends && \
    apt-get remove -y --purge software-properties-common && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# error_reporting and display_errors should be enabled on development only
RUN sed -i \
        -e "s~display_errors.*~display_errors = Off~g" \
        -e "s~display_startup_errors.*~display_startup_errors = Off~g" \
        -e "s~track_errors.*~track_errors = Off~g" \
        -e "s~;date.timezone.*~date.timezone = UTC~g" \
        -e "s~;cgi.fix_pathinfo.*~cgi.fix_pathinfo=0~g" \
            /etc/php/5.6/fpm/php.ini


RUN sed -i \
        -e "s/^pid\(.*\)/pid = run\/php-fpm.pid/g" \
        -e "s/^;pid\(.*\)/pid = run\/php-fpm.pid/g" \
        -e "s~^;daemonize = yes*$~daemonize = no~g" \
        -e "s~^;emergency_restart_threshold.*$~emergency_restart_threshold = 10~g" \
        -e "s~^;emergency_restart_interval.*$~emergency_restart_interval = 1m~g" \
        -e "s~^;process_control_timeout.*$~process_control_timeout = 10s~g" \
            /etc/php/5.6/fpm/php-fpm.conf


RUN sed -i \
        -e "s/^group = nobody/group = www-data/g" \
        -e "s/^user = nobody/user = www-data/g" \
        -e "s/^;listen.owner = nobody/listen.owner = www-data/g" \
        -e "s/^;listen.group = nogroup/listen.group = www-data/g" \
        -e "s/^;listen.mode = 0660/listen.mode = 0750/g" \
        -e "s/^listen\(.*\)/listen = 0.0.0.0:9000/g" \
        -e "s/^;slowlog/slowlog/g" \
        -e "s/^slowlog\(.*\)/slowlog = \/var\/log\/slowlog.log/g" \
        -e "s/^;request_slowlog_timeout/request_slowlog_timeout/g" \
        -e "s/^;pm.status_path/pm.status_path/g" \
        -e "s/^;request_terminate_timeout/request_terminate_timeout/g" \
        -e "s/^;catch_workers_output/catch_workers_output/g" \
            /etc/php/5.6/fpm/pool.d/www.conf


#curl -s https://raw.githubusercontent.com/ryantenney/php7/master/php.ini-production -o /usr/local/php7/lib/php.ini
RUN echo "zend_extension=opcache.so" >> /etc/php/5.6/fpm/php.ini
RUN echo "\n\nopcache.memory_consumption=128" >> /etc/php/5.6/mods-available/opcache.ini && \
    echo "opcache.interned_strings_buffer=8" >> /etc/php/5.6/mods-available/opcache.ini && \
    echo "opcache.max_accelerated_files=4000" >> /etc/php/5.6/mods-available/opcache.ini && \
    echo "opcache.revalidate_freq=60" >> /etc/php/5.6/mods-available/opcache.ini && \
    echo "opcache.fast_shutdown=1" >> /etc/php/5.6/mods-available/opcache.ini && \
    echo "opcache.enable_file_override=1" >> /etc/php/5.6/mods-available/opcache.ini && \
    echo "opcache.save_comments=0" >> /etc/php/5.6/mods-available/opcache.ini



# We need to create an empty file, otherwise the volume will belong to root.
RUN mkdir -p /var/www/ && touch /var/www/placeholder && chown -R www-data:www-data /var/www


VOLUME /var/www
WORKDIR /var/www


EXPOSE 9000


CMD ["/usr/sbin/php-fpm5.6", "-FO"]