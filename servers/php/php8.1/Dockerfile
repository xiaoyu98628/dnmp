# 指定基于 php:8.1-fpm-alpine 创建
FROM php:8.1-fpm-alpine

ARG CONTAINER_PACKAGE_URL
ARG PHP81_EXTENSIONS

ENV EXTENSIONS=",${PHP81_EXTENSIONS},"

# 资源替换 阿里云镜像
RUN if [ ${CONTAINER_PACKAGE_URL} ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装扩展
RUN apk update \
    && docker-php-source extract \
    && if [ "${PHP81_EXTENSIONS}" != "" ]; \
        then \
            apk add --no-cache --virtual .build-deps autoconf g++ make libstdc++; \
        fi \
    && if [[ -z "${EXTENSIONS##*,pdo_mysql,*}" ]]; \
        then \
            echo "---------- Install pdo_mysql ----------" \
            && docker-php-ext-install -j$(nproc) pdo_mysql; \
        fi \
    && if [[ -z "${EXTENSIONS##*,pcntl,*}" ]]; \
        then \
            echo "---------- Install pcntl ----------" \
            && docker-php-ext-install -j$(nproc) pcntl; \
        fi \
    && if [[ -z "${EXTENSIONS##*,mysqli,*}" ]]; \
        then \
            echo "---------- Install mysqli ----------" \
            && docker-php-ext-install -j$(nproc) mysqli; \
        fi \
    && if [[ -z "${EXTENSIONS##*,exif,*}" ]]; \
        then \
            echo "---------- Install exif ----------" \
            && docker-php-ext-install -j$(nproc) exif; \
        fi \
    && if [[ -z "${EXTENSIONS##*,bcmath,*}" ]]; \
        then \
            echo "---------- Install bcmath ----------" \
            && docker-php-ext-install -j$(nproc) bcmath; \
        fi \
    && if [[ -z "${EXTENSIONS##*,opcache,*}" ]]; \
        then \
            echo "---------- Install opcache ----------" \
            && docker-php-ext-install -j$(nproc) opcache; \
        fi \
    && if [[ -z "${EXTENSIONS##*,gettext,*}" ]]; \
        then \
            echo "---------- Install gettext ----------" \
            && apk add --no-cache gettext-dev \
            && docker-php-ext-install -j$(nproc) gettext; \
        fi \
    && if [[ -z "${EXTENSIONS##*,gd,*}" ]]; \
        then \
            echo "---------- Install gd ----------" \
            && apk add --no-cache libjpeg-turbo-dev libwebp-dev libpng-dev freetype-dev \
            && docker-php-ext-configure gd --with-freetype=/usr/include --with-jpeg=/usr/include --with-webp=/usr/include \
            && docker-php-ext-install -j$(nproc) gd; \
        fi \
    && if [[ -z "${EXTENSIONS##*,sockets,*}" ]]; \
        then \
            echo "---------- Install sockets ----------" \
            && docker-php-ext-install -j$(nproc) sockets; \
        fi \
    && if [[ -z "${EXTENSIONS##*,shmop,*}" ]]; \
        then \
            echo "---------- Install shmop ----------" \
            && docker-php-ext-install -j$(nproc) shmop; \
        fi \
    && if [[ -z "${EXTENSIONS##*,intl,*}" ]]; \
        then \
            echo "---------- Install intl ----------" \
            && apk add --no-cache icu-dev \
            && docker-php-ext-install -j$(nproc) intl; \
        fi \
    && if [[ -z "${EXTENSIONS##*,bz2,*}" ]]; \
        then \
            echo "---------- Install bz2 ----------" \
            && apk add --no-cache bzip2-dev \
            && docker-php-ext-install -j$(nproc) bz2; \
        fi \
    && if [[ -z "${EXTENSIONS##*,soap,*}" ]]; \
        then \
            echo "---------- Install soap ----------" \
            && apk add --no-cache libxml2-dev \
            && docker-php-ext-install -j$(nproc) soap; \
        fi \
    && if [[ -z "${EXTENSIONS##*,zip,*}" ]]; \
        then \
            echo "---------- Install zip ----------" \
            && apk add --no-cache libzip-dev \
            && docker-php-ext-install -j$(nproc) zip; \
        fi \
    && if [[ -z "${EXTENSIONS##*,xsl,*}" ]]; \
        then \
            echo "---------- Install xsl ----------" \
            && apk add --no-cache libxml2-dev libxslt-dev \
            && docker-php-ext-install -j$(nproc) xsl; \
        fi \
    && if [[ -z "${EXTENSIONS##*,redis,*}" ]]; \
        then \
            echo "---------- Install redis ----------" \
            && printf "\n" | pecl install redis \
            && docker-php-ext-enable redis; \
        fi \
    && if [[ -z "${EXTENSIONS##*,swoole,*}" ]]; \
        then \
            echo "---------- Install swoole ----------" \
            && printf "\n" | pecl install swoole \
            && docker-php-ext-enable swoole; \
        fi \
    && if [[ -z "${EXTENSIONS##*,memcached,*}" ]]; \
        then \
            echo "---------- Install memcached ----------" \
            && apk add --no-cache libmemcached-dev zlib-dev \
            && printf "\n" | pecl install memcached \
            && docker-php-ext-enable memcached; \
        fi \
    && if [[ -z "${EXTENSIONS##*,xdebug,*}" ]]; \
        then \
            echo "---------- Install xdebug ----------" \
            && printf "\n" | pecl install xdebug \
            && docker-php-ext-enable xdebug; \
        fi \
    && if [[ -z "${EXTENSIONS##*,mongodb,*}" ]]; \
        then \
            echo "---------- Install mongodb ----------" \
            && printf "\n" | pecl install mongodb \
            && docker-php-ext-enable mongodb; \
        fi \
    # 安装composer
    && apk add --no-cache --virtual .build-deps curl \
    && curl -sS https://getcomposer.org/installer | php \
    && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer \
    && docker-php-source delete \
    && apk del .build-deps