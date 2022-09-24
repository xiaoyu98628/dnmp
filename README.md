DNMP（Docker + Nginx + MySQL + PHP）是一款全功能的LNMP环境一键安装程序，可多版本

> 使用前最好阅读一遍下面的说明文件，以便快速上手，遇到问题也能及时排查

### 项目特点
1. 开源
2. 遵循Docker标准
3. 支持**多版本PHP**共存，可任意切换
4. 支持绑定**任意多个域名**
5. **PHP源代码、MySQL数据、配置文件、日志文件**都可在主机中直接修改查看
6. 默认支持`pdo_mysql`、`mysqli`、`mbstring`、`gd`、`curl`、`opcache`等常用热门扩展，根据环境灵活配置
7. 可一键配置常用服务（后续会增加）
    - 多PHP版本：PHP7.2、PHP7.3、PHP7.4、PHP8.0、PHP8.1
    - Web服务：Nginx
    - 数据库：MySQL8.0、Redis6、Elasticsearch
    - 辅助工具：Kibana
8. 实际项目中应用，确保可用
9. 一次配置，**Windows、Linux、MacOs**皆可用

## 1.目录结构
```
|-- data                         数据库数据目录
|     |--- mysql                      mysql 数据目录（多版本）
|--- logs                        日志目录
|--- plugins                     插件目录
|--- servers                     服务构建文件和配置文件目录
|     |--- elasticsearch              elasticsearch 配置文件目录（多版本）
|     |--- kibana                     kibana 配置文件目录（多版本）
|     |--- mysql                      mysql 配置文件目录（多版本）
|     |--- nginx                      nginx 配置文件目录（多版本）
|     |--- php                        php 配置文件目录（多版本）
|     |--- redis                      redis 配置文件目录（多版本）
|     |--- panel                      php 套接字文件目录
|--- www                         项目文件目录
|--- sample.env                  环境配置示例文件
|--- docker-compose.sample.yml   Docker 服务配置示例文件
```

## 2.快速使用
1. 本地安装
    - `git`
    - `Docker`
    - `docker-compose`
2. `clone` 项目
    ```gitignore
    git clone https://gitee.com/xiaoyucc521/dnmp.git
    ```
3. 拷贝并命名配置文件，启动：
    ```shell script
    cd dnmp                                            # 进入项目目录
    cp sample.env .env                                 # 复制并改名 .env 配置文件
    cp docker-compose.sample.yml docker-compose.yml    # 复制并改名 docker-compose.yml 配置文件
    
    # 执行 docker-compose up 之前，建议看一下docker-compose.yml 文件，以便快速上手。
    docker-compose up                                  # 启动服务
    ```
4.启动之后查看PHP版本
```shell script
http://localhost/         # PHP72
http://localhost/73       # PHP73
http://localhost/74       # PHP74
http://localhost/80       # PHP80
http://localhost/81       # PHP81
```

## 3.关于容器
### 3.1 PHP 
#### 3.1.1. windows下使用PHP
将PHP的版本改成apline3.12，否则pecl安装的扩展都会失败，[原因](https://www.editcode.net/thread-404502-1-1.html)

#### 3.1.2 切换Nginx使用PHP版本
比如切换为PHP7.2
打开Nginx配置conf.d下对应的配置文件`include enable-php-74.conf`改成`include enable-php-72.conf` 即可，如下：
```shell script
location ~ [^/]\.php(/|$) {
    ...
    include enable-php-74.conf;
    ...
}
```
改为：
```shell script
location ~ [^/]\.php(/|$) {
    ...
    include enable-php-72.conf;
    ...
}
```
最后 **重启 Nginx** 生效

#### 3.1.3 PHP容器中的conposer镜像修改
1. composer查看全局设置
    ```shell script
    composer config -gl
    ```
2. 设置composer镜像为国内镜像
    ```shell script
    composer config -g repo.packagist composer https://packagist.phpcomposer.com
    #或
    composer config -g repo.packagist composer https://mirrors.aliyun.com/composer
    ```

### 3.2 Elasticsearch
1. Elasticsearch 挂载目录权限问题，需要给 `./data/elasticsearch`、 `./logs/elasticsearch` 这两个文件夹赋予权限 `chmod -R 777 ./data/elasticsearch ./logs/elasticsearch` 重启即可
2. 账号密码设置
    ```shell script
     #自动生成密码
     ./bin/elasticsearch-setup-passwords auto
     #手动设置密码
     ./bin/elasticsearch-setup-passwords interactive
    ```
    执行后会自动生成密码
    ```shell script
     Changed password for user apm_system
     PASSWORD apm_system = {密码}
    
     Changed password for user kibana_system
     PASSWORD kibana_system = {密码}
    
     Changed password for user kibana
     PASSWORD kibana = {密码}
    
     Changed password for user logstash_system
     PASSWORD logstash_system = {密码}
    
     Changed password for user beats_system
     PASSWORD beats_system = {密码}
    
     Changed password for user remote_monitoring_user
     PASSWORD remote_monitoring_user = {密码}
    
     Changed password for user elastic
     PASSWORD elastic = {密码}
    ```
    然后修改对应的Kibana.yml文件
    ```shell script
     elasticsearch.username: "kibana_system或kibana"
     elasticsearch.password: "你生成的密码"
    ```
    
## 4.关于log
Log文件生成的位置依赖于conf下各log配置的值
### 4.1. mysql日志
- 因为MySQL容器中的MySQL使用的是mysql用户启动，它无法自行在/var/log下的增加日志文件。所以，我们把MySQL的日志放在与data一样的目录，即项目的mysql目录下，对应容器中的/var/lib/mysql/目录。
- 如果真的需要分开，在启动mysql服务后，进入容器在执行：` chown -R mysql:mysql /var/log/mysql ` 然后在` ./servers/mysql/mysql8.0/conf.d/docker.cnf ` 文件中去掉关于日志的注释，重启即可，日志数据卷默认挂载

## 5.管理命令
### 5.1. 服务器启动和构建命令
如需管理服务，请在命令后面加上服务器名称，例如：
```shell script
docker-compose up         # 创建并启动所有容器
docker-compose up -d      # 创建并后台运行方式启动所有容器
docker-compose up nginx php mysql # 创建并启动nginx、php、mysql的多个容器
docker-compose up -d nginx php mysql     # 创建并已后台运行的方式启动nginx、php、mysql容器

docker-compose start php                  # 启动php服务
docker-compose stop php                   # 停止php服务
docker-compose restart php                # 重启php服务

docker-compose build php                  # 构建或者重新构建服务

docker-compose rm php                     # 删除并停止php容器

docker-compose down                       # 停止并删除容器，网络，图像和挂载卷
```
