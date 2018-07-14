FROM centos:centos7
LABEL maintainer="Carlos José Vaz <carlosjvaz@gmail.com>"

RUN yum -y update &&\
    yum -y install wget &&\
    yum -y install deltarpm &&\
    yum -y install epel-release &&\
    wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm &&\
    rpm -Uvh remi-release-7*.rpm &&\
    yum-config-manager --enable extras &&\
    yum-config-manager --enable epel &&\
    yum-config-manager --enable remi &&\
    yum-config-manager --disable remi-php55 &&\
    yum-config-manager --disable remi-php56 &&\
    yum-config-manager --disable remi-php70 

RUN yum -y install \
    php  \
    php-cli \
    php-fpm  \
    php-gd  \
    php-imap  \
    php-ldap \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-pdo \
    php-pear  \
    php-pgsql \
    php-process \
    php-redis \
    php-soap \
    php-sqlite  \
    php-xcache \
    php-xml \
    php-xmlrpc \
    php-pecl-xdebug \
    php-pecl-memcache \
    php-pecl-memcached 

RUN yum -y autoremove &&\
    yum clean metadata &&\
    yum clean all &&\
    (rm /var/cache/yum/x86_64/7/timedhosts 2>/dev/null || true) &&\
    (rm /var/cache/yum/x86_64/7/timedhosts.txt 2>/dev/null || true)

#RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php.ini 
RUN sed -i 's/;date.timezone =.*/date.timezone = "America\/Sao_Paulo"/' /etc/php.ini &&\
    sed -i -e 's/;daemonize\s*=\s*yes/daemonize = no/g' /etc/php-fpm.conf &&\
    sed -i 's/post_max_size = 8M/post_max_size = 64M/g' /etc/php.ini &&\
    sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini &&\
    sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php.ini &&\
    sed -i 's/short_open_tag = Off/short_open_tag = On/' /etc/php.ini &&\
    sed -i '/^listen = /clisten = 0.0.0.0:9000' /etc/php-fpm.d/www.conf &&\
    sed -i '/^listen.allowed_clients/c;listen.allowed_clients =' /etc/php-fpm.d/www.conf &&\
    sed -i '/^;catch_workers_output/ccatch_workers_output = yes' /etc/php-fpm.d/www.conf &&\
    sed -i "s/php_admin_flag\[log_errors\] = .*/;php_admin_flag[log_errors] =/" /etc/php-fpm.d/www.conf &&\
    sed -i "s/php_admin_value\[error_log\] =.*/;php_admin_value[error_log] =/" /etc/php-fpm.d/www.conf &&\
    sed -i "s/php_admin_value\[error_log\] =.*/;php_admin_value[error_log] =/" /etc/php-fpm.d/www.conf &&\
    echo "php_admin_value[display_errors] = 'stderr'" >> /etc/php-fpm.d/www.conf &&\
    echo "xdebug.remote_port=9000" >> /etc/php.d/xdebug.ini &&\
    echo "xdebug.remote_enable=on" >> /etc/php.d/xdebug.ini &&\
    echo "xdebug.remote_autostart=off" >> /etc/php.d/xdebug.ini &&\
    echo "xdebug.remote_connect_back = 1" >> /etc/php.d/xdebug.ini &&\
    echo "xdebug.remote_log=/var/log/xdebug.log" >> /etc/php.d/xdebug.ini

RUN mkdir -p /var/www/html
VOLUME ["/var/www/html"]

EXPOSE 9000

CMD ["/usr/sbin/php-fpm", "-F"]
