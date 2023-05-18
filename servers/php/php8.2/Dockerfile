# 指定基于 php:8.2-fpm-alpine 创建
FROM php:8.2-fpm-alpine

LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

ARG CONTAINER_PACKAGE_URL
ARG PHP_EXTENSIONS_82
ARG COMPOSER_IMAGE_URL
ARG TZ

ENV EXTENSIONS=",${PHP_EXTENSIONS_82},"

# 资源替换 阿里云镜像
RUN if [ ${CONTAINER_PACKAGE_URL} ]; \
    then \
      sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories; \
    fi

# 更新apk 修改时间
RUN apk update && apk upgrade \
    && apk add --no-cache --virtual .build-deps tzdata \
    && cp -r "/usr/share/zoneinfo/${TZ}" /etc/localtime \
    && echo "${TZ}" > /etc/timezone

# 安装扩展
RUN docker-php-source extract \
    && if [ "${PHP_EXTENSIONS_82}" != "" ]; \
        then \
            apk add --no-cache --virtual .build-deps autoconf g++ make libtool linux-headers \
            && apk add --no-cache libstdc++; \
        fi \
    && if [ -z "${EXTENSIONS##*,pdo_mysql,*}" ]; \
        then \
            echo "---------- Install pdo_mysql ----------" \
            && docker-php-ext-install -j$(nproc) pdo_mysql; \
        fi \
    && if [ -z "${EXTENSIONS##*,pcntl,*}" ]; \
        then \
            echo "---------- Install pcntl ----------" \
            && docker-php-ext-install -j$(nproc) pcntl; \
        fi \
    && if [ -z "${EXTENSIONS##*,mysqli,*}" ]; \
        then \
            echo "---------- Install mysqli ----------" \
            && docker-php-ext-install -j$(nproc) mysqli; \
        fi \
    && if [ -z "${EXTENSIONS##*,exif,*}" ]; \
        then \
            echo "---------- Install exif ----------" \
            && docker-php-ext-install -j$(nproc) exif; \
        fi \
    && if [ -z "${EXTENSIONS##*,bcmath,*}" ]; \
        then \
            echo "---------- Install bcmath ----------" \
            && docker-php-ext-install -j$(nproc) bcmath; \
        fi \
    && if [ -z "${EXTENSIONS##*,opcache,*}" ]; \
        then \
            echo "---------- Install opcache ----------" \
            && docker-php-ext-install -j$(nproc) opcache; \
        fi \
    && if [ -z "${EXTENSIONS##*,gettext,*}" ]; \
        then \
            echo "---------- Install gettext ----------" \
            && apk add --no-cache gettext-dev \
            && docker-php-ext-install -j$(nproc) gettext; \
        fi \
    && if [ -z "${EXTENSIONS##*,gd,*}" ]; \
        then \
            echo "---------- Install gd ----------" \
            && apk add --no-cache libjpeg-turbo-dev libwebp-dev libpng-dev freetype-dev \
            && docker-php-ext-configure gd --with-freetype=/usr/include --with-jpeg=/usr/include --with-webp=/usr/include \
            && docker-php-ext-install -j$(nproc) gd; \
        fi \
    && if [ -z "${EXTENSIONS##*,sockets,*}" ]; \
        then \
            echo "---------- Install sockets ----------" \
            && docker-php-ext-install -j$(nproc) sockets; \
        fi \
    && if [ -z "${EXTENSIONS##*,shmop,*}" ]; \
        then \
            echo "---------- Install shmop ----------" \
            && docker-php-ext-install -j$(nproc) shmop; \
        fi \
    && if [ -z "${EXTENSIONS##*,intl,*}" ]; \
        then \
            echo "---------- Install intl ----------" \
            && apk add --no-cache icu-dev \
            && docker-php-ext-install -j$(nproc) intl; \
        fi \
    && if [ -z "${EXTENSIONS##*,bz2,*}" ]; \
        then \
            echo "---------- Install bz2 ----------" \
            && apk add --no-cache bzip2-dev \
            && docker-php-ext-install -j$(nproc) bz2; \
        fi \
    && if [ -z "${EXTENSIONS##*,calendar,*}" ]; \
        then \
            echo "---------- Install calendar ----------" \
            && docker-php-ext-install -j$(nproc) calendar; \
        fi \
    && if [ -z "${EXTENSIONS##*,soap,*}" ]; \
        then \
            echo "---------- Install soap ----------" \
            && apk add --no-cache libxml2-dev \
            && docker-php-ext-install -j$(nproc) soap; \
        fi \
    && if [ -z "${EXTENSIONS##*,sysvsem,*}" ]; \
        then \
            echo "---------- Install sysvsem ----------" \
            && docker-php-ext-install -j$(nproc) sysvsem; \
        fi \
    && if [ -z "${EXTENSIONS##*,sysvshm,*}" ]; \
        then \
            echo "---------- Install sysvshm ----------" \
            && docker-php-ext-install -j$(nproc) sysvshm; \
        fi \
    && if [ -z "${EXTENSIONS##*,sysvmsg,*}" ]; \
        then \
            echo "---------- Install sysvmsg ----------" \
            && docker-php-ext-install -j$(nproc) sysvmsg; \
        fi \
    && if [ -z "${EXTENSIONS##*,zip,*}" ]; \
        then \
            echo "---------- Install zip ----------" \
            && apk add --no-cache libzip-dev \
            && docker-php-ext-install -j$(nproc) zip; \
        fi \
    && if [ -z "${EXTENSIONS##*,xsl,*}" ]; \
        then \
            echo "---------- Install xsl ----------" \
            && apk add --no-cache libxml2-dev libxslt-dev \
            && docker-php-ext-install -j$(nproc) xsl; \
        fi \
    && if [ -z "${EXTENSIONS##*,redis,*}" ]; \
        then \
            echo "---------- Install redis ----------" \
            && printf "\n" | pecl install redis \
            && docker-php-ext-enable redis; \
        fi \
    && if [ -z "${EXTENSIONS##*,swoole,*}" ]; \
        then \
            echo "---------- Install swoole ----------" \
            && printf "\n" | pecl install swoole \
            && docker-php-ext-enable swoole; \
        fi \
    && if [ -z "${EXTENSIONS##*,memcached,*}" ]; \
        then \
            echo "---------- Install memcached ----------" \
            && apk add --no-cache libmemcached-dev zlib-dev \
            && printf "\n" | pecl install memcached \
            && docker-php-ext-enable memcached; \
        fi \
    && if [ -z "${EXTENSIONS##*,xdebug,*}" ]; \
        then \
            echo "---------- Install xdebug ----------" \
            && printf "\n" | pecl install xdebug-3.1.6 \
            && docker-php-ext-enable xdebug \
            && echo "[xdebug]" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.client_port = 9010" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
            && echo "xdebug.client_host = host.docker.internal ;phpstorm 官方文档上面有写 https://www.jetbrains.com/help/phpstorm/configuring-xdebug.html#feac0d97" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
        fi \
    && if [ -z "${EXTENSIONS##*,mongodb,*}" ]; \
        then \
            echo "---------- Install mongodb ----------" \
            && apk add --no-cache curl-dev openssl-dev \
            && printf "\n" | pecl install mongodb \
            && docker-php-ext-enable mongodb; \
        fi \
    && if [ -z "${EXTENSIONS##*,amqp,*}" ]; \
        then \
            echo "---------- Install amqp ----------" \
            && apk add --no-cache rabbitmq-c-dev \
            && printf "\n" | pecl install amqp \
            && docker-php-ext-enable amqp; \
        fi \
    && if [ -z "${EXTENSIONS##*,psr,*}" ]; \
        then \
            echo "---------- Install psr ----------" \
            && printf "\n" | pecl install psr \
            && docker-php-ext-enable psr; \
        fi \
    && if [ -z "${EXTENSIONS##*,phalcon,*}" ]; \
        then \
            echo "---------- Install phalcon ----------" \
            # 对于 phalcon 4.x，需要完成诸如安装 psr 之类的附加步骤 可参考php7.3/Dockerfile
            # 查看 pecl支持的版本 https://pecl.php.net/package/phalcon
            && printf "\n" | pecl install phalcon \
            && docker-php-ext-enable phalcon; \
        fi \
    && if [ -z "${EXTENSIONS##*,protobuf,*}" ]; \
        then \
            echo "---------- Install protobuf ----------" \
            && printf "\n" | pecl install protobuf \
            && docker-php-ext-enable protobuf; \
        fi \
    && if [ -z "${EXTENSIONS##*,grpc,*}" ]; \
        then \
            echo "---------- Install grpc ----------" \
            && apk add --no-cache zlib-dev \
            && printf "\n" | pecl install grpc \
            && docker-php-ext-enable grpc; \
        fi \
    && if [ -z "${EXTENSIONS##*,igbinary,*}" ]; \
        then \
            echo "---------- Install igbinary ----------" \
            && printf "\n" | pecl install igbinary \
            && docker-php-ext-enable igbinary; \
        fi \
    && if [ -z "${EXTENSIONS##*,xlswriter,*}" ]; \
        then \
            echo "---------- Install xlswriter ----------" \
            && apk add --no-cache zlib-dev \
            && printf "\n" | pecl install xlswriter \
            && docker-php-ext-enable xlswriter; \
        fi \
    # 安装composer
    && apk add --no-cache --virtual .build-deps curl \
    && curl -sS https://getcomposer.org/installer | php \
    && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer \
    && if [ ${COMPOSER_IMAGE_URL} ]; then composer config -g repo.packagist composer ${COMPOSER_IMAGE_URL}; fi \
    && docker-php-source delete \
    && apk del .build-deps

# https://github.com/docker-library/php/issues/240
RUN apk add --no-cache --repository https://${CONTAINER_PACKAGE_URL}/alpine/edge/testing gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php