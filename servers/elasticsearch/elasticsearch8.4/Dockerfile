# 指定基于 elasticsearch:8.4.0 创建
FROM elasticsearch:8.4.0

ARG CONTAINER_PACKAGE_URL
ARG ELASTICSEARCH_PLUGINS_8_4
ARG TZ

ENV PLUGINS=",${ELASTICSEARCH_PLUGINS_8_4},"

# 资源替换 阿里云镜像
RUN sed -i "s/dl-cdn.alpinelinux.org/${CONTAINER_PACKAGE_URL}/g" /etc/apk/repositories

# 更新apk 修改时间
RUN apk update && apk upgrade \
    && apk add --no-cache --virtual .build-deps tzdata \
    && cp -r "/usr/share/zoneinfo/${TZ}" /etc/localtime \
    && echo "${TZ}" > /etc/timezone

# 安装插件
RUN if [ -z "${PLUGINS##*,amazon-ec2,*}" ]; \
    then \
        echo "---------- Install amazon-ec2 ----------" \
        && printf "y\n" | elasticsearch-plugin install amazon-ec2; \
    fi \
    && if [ -z "${PLUGINS##*,analysis-icu,*}" ]; \
    then \
        echo "---------- Install analysis-icu ----------" \
        && printf "y\n" | elasticsearch-plugin install analysis-icu; \
    fi \
    && if [ -z "${PLUGINS##*,analysis-kuromoji,*}" ]; \
    then \
        echo "---------- Install analysis-kuromoji ----------" \
        && printf "y\n" | elasticsearch-plugin install analysis-kuromoji; \
    fi \
    && if [ -z "${PLUGINS##*,analysis-nori,*}" ]; \
    then \
        echo "---------- Install analysis-nori ----------" \
        && printf "y\n" | elasticsearch-plugin install analysis-nori; \
    fi \
    && if [ -z "${PLUGINS##*,analysis-phonetic,*}" ]; \
    then \
        echo "---------- Install analysis-phonetic ----------" \
        && printf "y\n" | elasticsearch-plugin install analysis-phonetic; \
    fi \
    && if [ -z "${PLUGINS##*,analysis-smartcn,*}" ]; \
    then \
        echo "---------- Install analysis-smartcn ----------" \
        && printf "y\n" | elasticsearch-plugin install analysis-smartcn; \
    fi \
    && if [ -z "${PLUGINS##*,analysis-stempel,*}" ]; \
    then \
        echo "---------- Install analysis-stempel ----------" \
        && printf "y\n" | elasticsearch-plugin install analysis-stempel; \
    fi \
    && if [ -z "${PLUGINS##*,analysis-ukrainian,*}" ]; \
    then \
        echo "---------- Install analysis-ukrainian ----------" \
        && printf "y\n" | elasticsearch-plugin install analysis-ukrainian; \
    fi \
    && if [ -z "${PLUGINS##*,discovery-azure-classic,*}" ]; \
    then \
        echo "---------- Install discovery-azure-classic ----------" \
        && printf "y\n" | elasticsearch-plugin install discovery-azure-classic; \
    fi \
    && if [ -z "${PLUGINS##*,discovery-ec2,*}" ]; \
    then \
        echo "---------- Install discovery-ec2 ----------" \
        && printf "y\n" | elasticsearch-plugin install discovery-ec2; \
    fi \
    && if [ -z "${PLUGINS##*,discovery-file,*}" ]; \
    then \
        echo "---------- Install discovery-file ----------" \
        && printf "y\n" | elasticsearch-plugin install discovery-file; \
    fi \
    && if [ -z "${PLUGINS##*,discovery-gce,*}" ]; \
    then \
        echo "---------- Install discovery-gce ----------" \
        && printf "y\n" | elasticsearch-plugin install discovery-gce; \
    fi \
    && if [ -z "${PLUGINS##*,google-cloud-storage,*}" ]; \
    then \
        echo "---------- Install google-cloud-storage ----------" \
        && printf "y\n" | elasticsearch-plugin install google-cloud-storage; \
    fi \
    && if [ -z "${PLUGINS##*,ingest-attachment,*}" ]; \
    then \
        echo "---------- Install ingest-attachment ----------" \
        && printf "y\n" | elasticsearch-plugin install ingest-attachment; \
    fi \
    && if [ -z "${PLUGINS##*,ingest-geoip,*}" ]; \
    then \
        echo "---------- Install ingest-geoip ----------" \
        && printf "y\n" | elasticsearch-plugin install ingest-geoip; \
    fi \
    && if [ -z "${PLUGINS##*,ingest-user-agent,*}" ]; \
    then \
        echo "---------- Install ingest-user-agent ----------" \
        && printf "y\n" | elasticsearch-plugin install ingest-user-agent; \
    fi \
    && if [ -z "${PLUGINS##*,mapper-murmur3,*}" ]; \
    then \
        echo "---------- Install mapper-murmur3 ----------" \
        && printf "y\n" | elasticsearch-plugin install mapper-murmur3; \
    fi \
    && if [ -z "${PLUGINS##*,mapper-size,*}" ]; \
    then \
        echo "---------- Install mapper-size ----------" \
        && printf "y\n" | elasticsearch-plugin install mapper-size; \
    fi \
    && if [ -z "${PLUGINS##*,microsoft-azure-storage,*}" ]; \
    then \
        echo "---------- Install microsoft-azure-storage ----------" \
        && printf "y\n" | elasticsearch-plugin install microsoft-azure-storage; \
    fi \
    && if [ -z "${PLUGINS##*,qa,*}" ]; \
    then \
        echo "---------- Install qa ----------" \
        && printf "y\n" | elasticsearch-plugin install qa; \
    fi \
    && if [ -z "${PLUGINS##*,repository-azure,*}" ]; \
    then \
        echo "---------- Install repository-azure ----------" \
        && printf "y\n" | elasticsearch-plugin install repository-azure; \
    fi \
    && if [ -z "${PLUGINS##*,repository-gcs,*}" ]; \
    then \
        echo "---------- Install repository-gcs ----------" \
        && printf "y\n" | elasticsearch-plugin install repository-gcs; \
    fi \
    && if [ -z "${PLUGINS##*,repository-hdfs,*}" ]; \
    then \
        echo "---------- Install repository-hdfs ----------" \
        && printf "y\n" | elasticsearch-plugin install repository-hdfs; \
    fi \
    && if [ -z "${PLUGINS##*,repository-s3,*}" ]; \
    then \
        echo "---------- Install repository-s3 ----------" \
        && printf "y\n" | elasticsearch-plugin install repository-s3; \
    fi \
    && if [ -z "${PLUGINS##*,store-smb,*}" ]; \
    then \
        echo "---------- Install store-smb ----------" \
        && printf "y\n" | elasticsearch-plugin install store-smb; \
    fi \
    && if [ -z "${PLUGINS##*,analysis-ik,*}" ]; \
    then \
        echo "---------- Install analysis-ik ----------" \
        && printf "y\n" | elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v8.4.0/elasticsearch-analysis-ik-8.4.0.zip; \
    fi \
    && if [ -z "${PLUGINS##*,analysis-pinyin,*}" ]; \
    then \
        echo "---------- Install analysis-pinyin ----------" \
        && printf "y\n" | elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-pinyin/releases/download/v8.4.0/elasticsearch-analysis-pinyin-8.4.0.zip; \
    fi