# 指定基于 php:7.3-fpm-alpine3.13 创建
FROM php:7.3-fpm-alpine3.13

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

ARG CONTAINER_PACKAGE_URL

# 资源替换 阿里云镜像
RUN if [ ${CONTAINER_PACKAGE_URL} ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

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
    # intl库扩展 相关依赖
    icu-dev \
    # xsl库扩展 相关依赖
    libxml2-dev \
    libxslt-dev \
    # sodium库扩展 相关依赖
    libsodium-dev \
    # bz2库扩展 相关依赖
    bzip2-dev \
    # soap库扩展 相关依赖
    libxml2-dev \
    # gettext库扩展 相关依赖
    gettext-dev \
    # swoole扩展 相关依赖
    libstdc++ \
    # 安装扩展
    && docker-php-source extract \
    && docker-php-ext-configure gd \
    --with-freetype-dir=/usr/include \
    --with-jpeg-dir=/usr/include \
    --with-png-dir=/usr/include \
    --with-webp-dir=/usr/include \
    && docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli opcache sockets zip intl xsl shmop pcntl sodium bz2 soap gettext \
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