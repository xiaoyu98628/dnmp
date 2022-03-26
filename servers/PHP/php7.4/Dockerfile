# 指定基于 php:7.4-fpm-alpine3.13 创建
FROM php:7.4-fpm-alpine3.13

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

ARG CONTAINER_PACKAGE_URL

# 资源替换 阿里云镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 相关依赖必须手动安装 可删除
RUN apk update \
    && apk add --no-cache --virtual .build-deps \
    autoconf \
    g++ \
    make

# 不可删除的依赖
RUN apk add --no-cache \
    # zip扩展 相关依赖
    libzip-dev \
    # GD库扩展 相关依赖
    libjpeg-turbo-dev \
    libwebp-dev \
    libpng-dev \
    freetype-dev \
    # swoole扩展 相关依赖
    libstdc++ \
    # 安装扩展
    && docker-php-source extract \
    && docker-php-ext-configure gd \
    --with-freetype=/usr/include \
    --with-jpeg=/usr/include \
    --with-webp=/usr/include \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli sockets zip \
    # 外部扩展
    && pecl install redis swoole \
    && docker-php-ext-enable redis swoole \
    && docker-php-source delete \
    && pecl clear-cache

# 安装composer
RUN apk add --no-cache --virtual .build-deps curl \
    && curl -sS https://getcomposer.org/installer | php \
    && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer \
    && apk del .build-deps