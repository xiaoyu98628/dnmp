# 指定基于 php:7.4-fpm-alpine 创建
FROM php:7.4-fpm-alpine

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

# 资源替换 阿里云镜像
RUN if [ $CONTAINER_PACKAGE_URL ] ; then sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories ; fi

# 修改时间
RUN apk add --no-cache --virtual .build-deps \
    tzdata \
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone

RUN apk add --no-cache --virtual .build-deps \
            # 相关依赖必须手动安装
            gcc make g++ vim \
            autoconf \
            libpng \
            libpng-dev \
            freetype \
            freetype-dev \
            libwebp \
            libwebp-dev \
            libjpeg \
            jpeg-dev \
            libjpeg-turbo \
            libjpeg-turbo-dev \
            && docker-php-source extract  \
            # 如果安装的扩展需要自定义配置时
            && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
            && docker-php-ext-install -j$(nproc) gd \
#            && docker-php-ext-configure gd --with-gd --with-webp-dir --with-jpeg-dir --with-png-dir --with-zlib-dir --with-freetype-dir -enable-gd-native-ttf \
#            && NUMPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
#            && docker-php-ext-install -j${NUMPROC} gd

            # 扩展安装完成执行
#            && docker-php-source delete  \
            # 删除 apk 临时文件
            && apk del .build-deps