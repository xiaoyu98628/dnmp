# 指定基于 php:7.4-fpm-alpine 创建
FROM php:7.4-fpm-alpine

# 声明作者
LABEL MAINTAINER="XiaoYu <1765841705@qq.com>"

# 资源替换 阿里云镜像
RUN sed -i "s/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g" /etc/apk/repositories

# 安装依赖
RUN apk add --no-cache --virtual .build-deps \
            tzdata \
            gcc \
            make \
            vim \

# 修改时间

# 安装扩展

# 删除 apk 临时文件
RUN apk del .build-deps