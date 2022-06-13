# 指定基于 php:8.0-fpm-alpine3.13 创建
FROM php:8.0-fpm-alpine3.13

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

ARG CONTAINER_PACKAGE_URL
ARG PHP80_EXTENSIONS

ENV EXTENSIONS=",${PHP80_EXTENSIONS},"

# 资源替换 阿里云镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 安装扩展
RUN apk update \
    && docker-php-source extract \
    && if [ "${PHP80_EXTENSIONS}" != "" ]; \
        then \
            apk --update --no-cache add --virtual .build-deps autoconf g++ make; \
        fi \
    && if [[ -z "${EXTENSIONS##*,pdo_mysql,*}" ]]; \
        then \
            echo "---------- Install pdo_mysql ----------"; \
            docker-php-ext-install -j$(nproc) pdo_mysql; \
        fi \
    && if [[ -z "${EXTENSIONS##*,pcntl,*}" ]]; \
        then \
            echo "---------- Install pcntl ----------"; \
            docker-php-ext-install -j$(nproc) pcntl; \
        fi \
    && if [[ -z "${EXTENSIONS##*,mysqli,*}" ]]; \
        then \
            echo "---------- Install mysqli ----------"; \
            docker-php-ext-install -j$(nproc) mysqli; \
        fi \
    && if [[ -z "${EXTENSIONS##*,mbstring,*}" ]]; \
        then \
            echo "---------- Install mbstring ----------"; \
            docker-php-ext-install -j$(nproc) mbstring; \
        fi \
    && if [[ -z "${EXTENSIONS##*,exif,*}" ]]; \
        then \
            echo "---------- Install exif ----------"; \
            docker-php-ext-install -j$(nproc) exif; \
        fi \
    && if [[ -z "${EXTENSIONS##*,bcmath,*}" ]]; \
        then \
            echo "---------- Install bcmath ----------"; \
            docker-php-ext-install -j$(nproc) bcmath; \
        fi \
    && if [[ -z "${EXTENSIONS##*,opcache,*}" ]]; \
        then \
            echo "---------- Install opcache ----------"; \
            docker-php-ext-install -j$(nproc) opcache; \
        fi \
    && if [[ -z "${EXTENSIONS##*,gd,*}" ]]; \
        then \
            echo "---------- Install gd ----------"; \
            apk --no-cache add libjpeg-turbo-dev libwebp-dev libpng-dev freetype-dev; \
            docker-php-ext-configure gd --with-freetype=/usr/include --with-jpeg=/usr/include --with-webp=/usr/include; \
            docker-php-ext-install -j$(nproc) gd; \
        fi \
    && if [[ -z "${EXTENSIONS##*,sockets,*}" ]]; \
        then \
            echo "---------- Install sockets ----------"; \
            docker-php-ext-install -j$(nproc) sockets; \
        fi \
    && if [[ -z "${EXTENSIONS##*,redis,*}" ]]; \
        then \
            echo "---------- Install redis ----------"; \
            pecl install redis; \
            docker-php-ext-enable redis; \
        fi \
    && if [[ -z "${EXTENSIONS##*,swoole,*}" ]]; \
        then \
            echo "---------- Install swoole ----------"; \
            pecl install swoole; \
            docker-php-ext-enable swoole; \
        fi \
    && docker-php-source delete \
    && pecl clear-cache

# 安装composer
RUN apk --no-cache add --virtual .build-deps curl \
    && curl -sS https://getcomposer.org/installer | php \
    && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer \
    && apk del .build-deps



## 不可删除的依赖
#RUN apk add --no-cache \
#    # zip扩展 相关依赖
#    libzip-dev \
#    # GD库扩展 相关依赖
#    libjpeg-turbo-dev \
#    libwebp-dev \
#    libpng-dev \
#    freetype-dev \
#    # swoole扩展 相关依赖
#    libstdc++ \
#    # 安装扩展
#    && docker-php-source extract \
#    && docker-php-ext-configure gd \
#    --with-freetype=/usr/include \
#    --with-jpeg=/usr/include \
#    --with-webp=/usr/include \
#    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli sockets zip \
#    # 外部扩展
#    && pecl install redis swoole \
#    && docker-php-ext-enable redis swoole \
#    && docker-php-source delete \
#    && pecl clear-cache