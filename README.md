DNMP（Docker + Nginx + MySQL + PHP）是一款全功能的LNMP环境一键安装程序，可多版本

> 使用前最好阅读一遍下面的说明文件，以便快速上手，遇到问题也能及时排查

### QQ交流群: 544315207

### 快速使用
1. 本地安装
   - `git`
   - `Docker`
   - `docker-compose 2.0.0+`
2. `clone` 项目
   ```shell
   git clone https://github.com/xiaoyu98628/dnmp.git
   # 或者
   git clone https://gitee.com/xiaoyucc521/dnmp.git
   ```
3. 拷贝并命名配置文件，启动：
   ```shell
   # 进入项目目录
   cd dnmp
   # 复制并改名 .env 配置文件
   cp sample.env .env
   # 复制并改名 compose.yml 配置文件
   cp compose.sample.yml compose.yml
   # 复制并改名 vhost文件
   cp servers/panel/vhost/nginx/nginx1.21/localhost.conf.sample servers/panel/vhost/nginx/nginx1.21/您的域名.conf
   
   # 执行 docker compose up 之前，建议看一下compose.yml 文件，以便快速上手。
   docker compose up                                # 启动服务
   ```
4. 启动之后查看PHP版本
   ```
   http[s]://[你的域名]/72       # PHP72
   http[s]://[你的域名]/73       # PHP73
   http[s]://[你的域名]/74       # PHP74
   http[s]://[你的域名]/80       # PHP80
   http[s]://[你的域名]/81       # PHP81
   http[s]://[你的域名]/82       # PHP82
   http[s]://[你的域名]/83       # PHP83
   ```
# 目录
- [1 目录结构](#1-目录结构)
- [2 容器](#2-容器)
  - [2.1 PHP](#21-php)
    - [2.1.1 docker容器里安装PHP扩展常用命令](#211-docker容器里安装php扩展常用命令)
    - [2.1.2 PHP容器中的composer镜像修改](#212-php容器中的composer镜像修改)
    - [2.1.3 phpstorm 配置 xdebug](#213-phpstorm-配置-xdebug)
    - [2.1.4 宿主机中使用PHP命令行](#214-宿主机中使用php命令行)
    - [2.1.5 容器中PHP慢日志没有记录问题](#215-容器中php慢日志没有记录问题)
  - [2.2 Nginx](#22-nginx)
    - [2.2.1 添加新的站点](#221-添加新的站点)
    - [2.2.2 切换PHP版本](#222-切换php版本)
    - [2.2.3 站点根目录挂载](#223-站点根目录挂载)
    - [2.2.4 配置https](#224-配置https)
  - [2.3 Elasticsearch](#23-elasticsearch)
    - [2.3.1 Elasticsearch账号密码设置](#231-elasticsearch账号密码设置)
  - [2.4 Kibana](#24-kibana)
    - [2.4.1 Kibana连接Elasticsearch问题](#241-kibana连接elasticsearch问题)
  - [2.5 Mongo](#25-mongo)
    - [2.5.1 system.sessions文档没权限访问](#251-systemsessions文档没权限访问)
  - [2.6 Redis](#26-redis)
    - [2.6.1 redis 密码问题](#261-redis-密码问题)
  - [2.7 MySQL](#27-mysql)
    - [2.7.1 mysql 密码问题](#271-mysql-密码问题)
    - [2.7.2 权限问题](#272-权限问题)
- [3 容器挂载路径权限问题](#3-容器挂载路径权限问题)
  - [3.1 mysql](#31-mysql)
  - [3.2 Elasticsearch](#32-elasticsearch)
  - [3.3 Mongo](#33-mongo)
  - [3.4 RabbitMQ](#34-rabbitmq)
- [4 管理命令](#4-管理命令)
  - [4.1 服务器启动和构建命令](#41-服务器启动和构建命令)
  - [4.2 镜像（容器）的导入与导出](#42-镜像容器的导入与导出)
    - [4.2.1 save 导出镜像（export 导出容器）](#421-save-导出镜像export-导出容器)
    - [4.2.2 load 导入镜像（import 导入容器）](#422-load-导入镜像import-导入容器)
    - [4.2.3 save, load, export, import 区别与联系](#423-save-load-export-import-区别与联系)
- [5 其他问题](#5-其他问题)
  - [5.1 compose.sample.yml 文件中 volumes 的 rw、ro详解](#51-composesampleyml-文件中-volumes-的-rwro详解)
  - [5.2 容器内时间问题](#52-容器内时间问题)
  - [5.3 SQLSTATE[HY000] [1044] Access denied for user '你的用户名'@'%' to database 'mysql'](#53-sqlstatehy000-1044-access-denied-for-user-你的用户名-to-database-mysql)
  - [5.4 [output clipped, Log limit 1MiB reached] 日志限制达到1MiB](#54-output-clipped-log-limit-1mib-reached-日志限制达到1mib)
- [6. alpine 镜像内 apk 部分命令详解](#6-alpine-镜像内-apk-部分命令详解)
## 1 目录结构
```markdown
|-- data                         数据库数据目录
|     |--- mysql                      mysql 数据目录（多版本）
|     |     |--- mysql8.0                  mysql8.0 数据目录
|--- logs                        日志目录
|     |--- mysql                      mysql 日志目录（多版本）
|     |     |--- mysql8.0                  mysql8.0 日志目录
|--- plugins                     插件目录
|     |--- elasticsearch              elasticsearch 插件目录（多版本）
|     |     |--- elasticsearch8.4          elasticsearch8.4 插件目录
|--- resource                    资源目录(存放图片和.md的说明文件)
|--- servers                     服务构建文件和配置文件目录
|     |--- elasticsearch              elasticsearch 配置文件目录（多版本）
|     |--- kibana                     kibana 配置文件目录（多版本）
|     |--- mysql                      mysql 配置文件目录（多版本）
|     |--- mongo                      mongo 配置文件目录（多版本）
|     |--- nginx                      nginx 配置文件目录（多版本）
|     |--- php                        php 配置文件目录（多版本）
|     |     |--- php7.2                    php7.2 配置文件目录
|     |     |--- php7.3                    php7.3 配置文件目录
|     |--- redis                      redis 配置文件目录（多版本）
|     |--- rabbitmq                   rabbitmq 配置文件目录（多版本）
|     |--- panel                      服务面板
|     |     |--- vhost                     站点配置文件目录
|     |     |--- ssl                       https 证书目录
|     |     |--- sock                      套接字文件目录
|--- www                         项目文件目录
|--- bashrc.sample               .bashrc 配置示例文件(宿主机使用容器内命令)
|--- sample.env                  环境配置示例文件
|--- compose.sample.yml   Docker 服务配置示例文件
```
## 2 容器
### 2.1 PHP
#### 2.1.1 docker容器里安装PHP扩展常用命令
1. 方法一：
   * `docker-php-source`
        > 此命令，实际上就是在PHP容器中创建一个`/usr/src/php`的目录，里面放了一些自带的文件而已。我们就把它当作一个从互联网中下载下来的PHP扩展源码的存放目录即可。事实上，所有PHP扩展源码扩展存放的路径： `/usr/src/php/ext` 里面。
   * `docker-php-ext-install`
        > 这个命令，就是用来启动 PHP扩展 的。我们使用pecl安装PHP扩展的时候，默认是没有启动这个扩展的，如果想要使用这个扩展必须要在php.ini这个配置文件中去配置一下才能使用这个PHP扩展。而 `docker-php-ext-enable` 这个命令则是自动给我们来启动PHP扩展的，不需要你去php.ini这个配置文件中去配置。
   * `docker-php-ext-enable`
        > 这个命令，是用来安装并启动PHP扩展的。命令格：`docker-php-ext-install "源码包目录名"`
   * `docker-php-ext-configure`
        > 一般都是需要跟 docker-php-ext-install搭配使用的。它的作用就是，当你安装扩展的时候，需要自定义配置时，就可以使用它来帮你做到。
   * [**Docker容器里 PHP安装扩展**](resource/php-install-ext.md)
2. 方法二：
    * 快速安装 PHP 扩展
      ```shell
       docker exec -it php71 sh
       install-php-extensions redis
       ```
   * [**支持快速安装扩展列表**](resource/install-php-extensions.md)
        > <a href="https://github.com/mlocati/docker-php-extension-installer" target="_blank">**此扩展来自 docker-php-extension-installer 参考示例文件**</a>
>**注意：以上两种方式是在容器内安装扩展，容器删除，扩展也会随之删除，建议在镜像层安装扩展，在.env文件里添加对应的扩展，然后重新 `docker compose build php72` 构建镜像即可**
```dotenv
# +--------------+
# PHP7.2
# +--------------+
#
# +--------------------------------------------------------------------------------------------+
# Default installed:
#
# Core,ctype,curl,date,dom,fileinfo,filter,ftp,hash,iconv,json,libxml,mbstring,mysqlnd,openssl,pcre,PDO,
# pdo_sqlite,Phar,posix,readline,Reflection,session,SimpleXML,sodium,SPL,sqlite3,standard,tokenizer,xml,
# xmlreader,xmlwriter,zlib
#
# Available PHP_EXTENSIONS:
#
# pdo_mysql,pcntl,mysqli,exif,bcmath,opcache,gettext,gd,sockets,shmop,intl,bz2,soap,zip,sysvmsg,sysvsem,
# sysvshm,xsl,calendar,tidy,snmp,
# amqp,apcu,rdkafka,redis,swoole,memcached,xdebug,mongodb,protobuf,grpc,xlswriter,igbinary,psr,phalcon,
# mcrypt,yaml
#
# You can let it empty to avoid installing any extensions,
# +--------------------------------------------------------------------------------------------+
PHP_EXTENSIONS_72=pdo_mysql,mysqli,gd,redis,zip,bcmath,xlswriter
```
#### 2.1.2 PHP容器中的composer镜像修改
1. composer查看全局设置
   ```shell
   composer config -gl
   ```
2. 设置composer镜像为国内镜像,全局模式
   ```shell
   # phpcomposer镜像源
   composer config -g repo.packagist composer https://packagist.phpcomposer.com
   # 阿里云composer镜像源
   composer config -g repo.packagist composer https://mirrors.aliyun.com/composer
   # 腾讯云composer镜像源
   composer config -g repo.packagist composer https://mirrors.cloud.tencent.com/composer
   ```
3. 恢复composer默认镜像
   ```shell
   composer config -g --unset repos.packagist
   ```
#### 2.1.3 phpstorm 配置 xdebug
[**phpstorm 配置 xdebug**](resource/phpstorm-xdebug.md)
#### 2.1.4 宿主机中使用PHP命令行
1. 参考[bashrc.sample](bashrc.sample)示例文件，将对应的php-cli函数拷贝到主机的 `~/.bashrc` 文件中。
2. 让文件起效：
   ```shell
   source ~/.bashrc
   ```
3. 然后就可以在主机中执行PHP命令了：
   ```shell
   [root@centos ~]# php72 -v
   PHP 7.2.34 (cli) (built: Dec 17 2020 10:32:53) ( NTS )
   Copyright (c) 1997-2018 The PHP Group
   Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
   [root@centos ~]#
   ```
#### 2.1.5 容器中PHP慢日志没有记录问题
在Linux系统中，PHP-FPM使用 SYS_PTRACE 跟踪worker进程，但是docker容器默认又不启用这个功能，所以就导致了这个问题。  
**解决**：
1. 如果用命令行，在命令上加上： `--cap-add=SYS_PTRACE`  
2. 如果用docker-compose.yml文件，在服务中加上：
   ```yaml
   php72:
     # ...
     cap_add:
        - SYS_PTRACE
     # ...
   ```
### 2.2 Nginx
#### 2.2.1 添加新的站点
新增的 `.conf` 文件应放在 `servers/panel/vhost/nginx/nginx版本` 文件夹下
#### 2.2.2 切换PHP版本
比如切换为PHP8.3，打开 `./servers/panel/vhost/nginx/nginx版本` 下对应的Nginx站点配置文件，找到 `include enable-php-80.conf` 改成 `include enable-php-83.conf` 即可  
例如：
```
location ~ [^/]\.php(/|$) {
   ...
   include enable-php-80.conf;
   ...
}
```
改为：
```
location ~ [^/]\.php(/|$) {
   ...
   include enable-php-83.conf;
   ...
}
```
> 注意：修改了nginx配置文件，使之生效必须要 **重启 Nginx 容器** 或者 **在容器中执行 `nginx -s reload`**
#### 2.2.3 站点根目录挂载
为什么站点根目录在Nginx和PHP-FPM都需要挂载？
```
# php 挂载目录
- "../www:/var/www/html"
# nginx 挂载目录
- "../www:/usr/share/nginx/html"
```
我们知道，Nginx配置都有这样一项：
```
fastcgi_param  SCRIPT_FILENAME    $document_root$fastcgi_script_name;
```
其中，`$document_root` 就是server块下 `root` 所指的路径：
```
server {
   ...
   root /var/www/html;
   ...
}
```
这里 `$document_root` 就是/var/www/html。 如果Nginx和PHP-FPM在同一主机，Nginx会通过9000端口（或套接字文件）把这个目录值和脚本URI传给PHP-FPM。
PHP-FPM再通过9000端口（或套接字文件）接收Nginx发过来的目录值和脚本URI，发给PHP解析。
PHP收到后，就到指定的目录下查找PHP文件并解析，完成后再通过9000端口（或套接字文件）返回给Nginx。
**如果Nginx和PHP-FPM在同一个主机里面，PHP就总能找到Nginx指定的目录。**   
**但是，如果他们在不同的容器呢？**   
未做任何处理的情况，Nginx容器中的站点根目录，PHP-FPM容器肯定不存在。 所以，这里需要保证Nginx和PHP-FPM都挂载了宿主机的 `./www`。 （当然，你也可以指定别的目录）
#### 2.2.4 配置https
1. `ssl` 证书存放位置
   ```
   ./servers/panel/ssl/nginx/nginx版本/站点名称/证书
   ```
2. `nginx.conf` 配置文件修改
   ```
   server {
      listen       80;
      listen  [::]:80;
      server_name  xxx; # 您的域名
   
      # 跳转  实现 http 强转 https
      rewrite ^(.*)$ https://${server_name}$1 permanent;
      
      ...
   }
   
   server {
      listen       443 ssl;
      listen  [::]:443 ssl;
      server_name  xxx; # 您的域名和上面的域名一致
   
      #ssl证书地址
      ssl_certificate /usr/panel/ssl/nginx/nginx版本/站点名称/xxx; # 公钥
      ssl_certificate_key /usr/panel/ssl/nginx/nginx版本/站点名称/xxx; # 私钥

      #ssl验证相关配置
      ssl_session_timeout  5m;    #缓存有效期
      ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;    #加密算法
      ssl_protocols TLSv1 TLSv1.1 TLSv1.2;    #安全链接可选的加密协议
      ssl_prefer_server_ciphers on;   #使用服务器端的首选算法
      
      ...
   }
   ```
3. 修改完成重启（重载）即可
   ```shell
   # 方式一：重启 docker compose restart 服务ID
   docker compose restart nginx1.21
   # 方式二：重载 docker exec 容器ID nginx -s reload
   docker exec nginx1.21 nginx -s reload
   ```
### 2.3 Elasticsearch
#### 2.3.1 Elasticsearch账号密码设置
```shell
# 自动生成密码
./bin/elasticsearch-setup-passwords auto
# 手动设置密码
./bin/elasticsearch-setup-passwords interactive
```
执行后会自动生成密码
```
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
### 2.4 Kibana
#### 2.4.1 Kibana连接Elasticsearch问题
```
elasticsearch.username: "kibana_system或kibana"
elasticsearch.password: "上面Elasticsearch生成的密码"
```
### 2.5 Mongo
#### 2.5.1 `system.sessions`文档没权限访问
授权
```
db.grantRolesToUser('userName',[{role:"<role>",db:"<database>"}])
// 例如
db.grantRolesToUser('root',[{role:"__system",db:"admin"}])
```
### 2.6 Redis
#### 2.6.1 redis 密码问题
当前redis容器是 `启用密码` 的，默认密码 `123456` 如需修改密码直接在 `.env` 文件中找到下面配置项，修改即可
```dotenv
# +--------------+
# mysql6.2
# +--------------+
REDIS_PASSWORD_62=123456
```
### 2.7 MySQL
#### 2.7.1 mysql 密码问题
当前mysql容器提供两个账户，`root账户`，默认在容器内部访问 `xiaoyu账户` 默认权限不足
```dotenv
# +--------------+
# mysql8.0
# +--------------+
MYSQL_ROOT_PASSWORD_80=root
MYSQL_ROOT_HOST_80=localhost
MYSQL_USER_80=xiaoyu
MYSQL_PASSWORD_80=xiaoyu
```
如需修改请在 `.env` 文件中找到相应配置，对应修改  
- `MYSQL_ROOT_PASSWORD_80` 默认账户 `root` 对应的密码
- `MYSQL_ROOT_HOST_80` 默认账户 `root` 对应的访问权限
- `MYSQL_USER_80` 新建账户 `xiaoyu` 用户名
- `MYSQL_PASSWORD_80` 新建账户 `xiaoyu` 对应的密码
#### 2.7.2 权限问题
如需修改权限，对照下面命令修改
```sql
-- privileges：用户的操作权限，如SELECT，INSERT，UPDATE等，如果要授予所的权限则使用ALL
-- database_name：数据库名
-- table_name：表名，如果要授予该用户对所有数据库和表的相应操作权限则可用*表示，如*.*
GRANT privileges ON database_name.table_name TO 'username'@'host';

-- 例子：
GRANT SELECT,INSERT ON test.user TO 'xiaoyu'@'%';
GRANT ALL ON *.* TO 'xiaoyu'@'%';
GRANT ALL ON maindataplus.* TO 'xiaoyu'@'%';
```
## 3 容器挂载路径权限问题
由于数据卷和日志卷分离的原因，部分容器启动需要对应的权限，然而宿主机上没有与之对应的权限，所以我们直接赋予`777`权限即可
### 3.1 mysql
需要给 `./logs/mysql` 文件夹赋予权限 `chmod -R 777 ./logs/mysql` 重启即可
### 3.2 Elasticsearch
需要给 `./data/elasticsearch`、 `./logs/elasticsearch` 文件夹赋予权限 `chmod -R 777 ./data/elasticsearch ./logs/elasticsearch` 重启即可
### 3.3 Mongo
需要给 `./data/mongo`、 `./logs/mongo` 文件夹赋予权限 `chmod -R 777 ./data/mongo ./logs/mongo` 重启即可
### 3.4 RabbitMQ
需要给 `./data/rabbitmq`、 `./logs/rabbitmq` 文件夹赋予权限 `chmod -R 777 ./data/rabbitmq ./logs/rabbitmq` 重启即可
## 4 管理命令
### 4.1 服务器启动和构建命令
如需管理服务，请在命令后面加上服务器名称，例如：
```shell
docker compose up                       # 创建并启动所有服务
docker compose up -d                    # 创建并以后台运行方式启动所有服务
docker compose up "服务名..."            # 创建并启动服务
docker compose up -d "服务名..."         # 创建并以后台运行的方式启动服务

docker compose start "服务名..."         # 启动服务
docker compose stop "服务名..."          # 停止服务
docker compose restart "服务名..."       # 重启服务

docker compose build "服务名..."         # 构建或者重新构建服务

docker compose rm "服务名..."            # 删除并停止

docker compose down                     # 停止并删除容器，网络，图像和挂载卷
```
### 4.2 镜像（容器）的导入与导出
Docker 镜像（容器）的导入导出，用于迁移，备份，升级等场景。涉及的命令有 `save`, `load`, `export`, `import`
#### 4.2.1 save 导出镜像（export 导出容器）
```shell
# docker save [可选项] 镜像名称1 [镜像名称2...]
# 可选项:
#   -o, --output string   Write to a file, instead of STDOUT

docker save -o dnmp-php72.tar dnmp-php72

# docker export [可选项] 容器
# 可选项：
#   -o, --output string   Write to a file, instead of STDOUT
docker export -o php72.tar php72
```
> 注意：dnmp-php72 是本地已经存在的镜像。完成后会在本地生成一个 dnmp-php72.tar 的压缩包文件
#### 4.2.2 load 导入镜像（import 导入容器）
```shell
# docker load [可选项]
# 可选项:
#   -i, --input string   Read from tar archive file, instead of STDIN
#   -q, --quiet          Suppress the load output

docker load -i dnmp-php72.tar

# docker import [可选项] file|URL|- [REPOSITORY[:TAG]]
# 可选项:
#   -c, --change list       Apply Dockerfile instruction to the created image
#   -m, --message string    Set commit message for imported image
#       --platform string   Set platform if server is multi-platform capable
docker import php72.tar php72:v1
```
> 注意：导入之前记得删除本地和导入重名的镜像
#### 4.2.3 `save`, `load`, `export`, `import` 区别与联系
- docker save 保存的是镜像（image），docker export 保存的是容器（container）
- docker load 用来导入镜像包，必须是一个分层文件系统，必须是 docker save 的包，
- docker import 用来导入容器包，但两者都会恢复为镜像
- docker load 不能对导入的镜像重命名，而 docker import 可以为镜像指定新名称
- docker export 的包会比 docker save 的包小，原因是 docker save 导出的是一个分层的文件系统，docker export 导出的是一个 linux系统的文件目录
## 5 其他问题
### 5.1 `compose.sample.yml` 文件中 `volumes` 的 rw、ro详解
众所周知，如果启动容器不使用挂载宿主机的文件或文件夹，容器中的配置文件只能进入容器才能修改，输出的日志文件也是在容器里面，查看不方便，也不利于日志收集，所以一般都是使用参数来挂载文件或文件夹。  
而其中的**rw**、**ro**和**不指定**模式，是比较重要的一个环节，关系到宿主机与容器的文件、文件夹变化关系，下面来一一详解
1. **不指定**  
   (1)文件：宿主机修改该文件后容器里面看不到变化；容器里面修改该文件，宿主机也看不到变化   
   (2)文件夹：不管是宿主机还是容器内修改，新增，删除，都会同步
2. **ro**  
   (1)文件：容器内不能修改，会提示readonly  
   (2)文件夹：容器内不能修改，新增，删除文件夹中的文件，会提示readonly
3. **rw**  
   (1)文件：不管是宿主机还是容器内修改，都会相互同步，但容器内不允许删除，会提示Device or resource busy；宿主机删除文件，容器内的不会被同步  
   (2)文件夹：不管是宿主机还是容器内修改，新增，删除都会相互同步
### 5.2 容器内时间问题
容器时间在.env文件中配置`TZ`变量，所有支持的时区请查看 <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones" target="_blank">**时区列表·维基百科**</a> 或者 <a href="https://www.php.net/manual/zh/timezones.php" target="_blank">**PHP所支持的时区列表·PHP官网**</a>。
### 5.3 `SQLSTATE[HY000] [1044] Access denied for user '你的用户名'@'%' to database 'mysql'`
1. 如果在`compose.yml`文件中或者`docker run -e`中，设置并且有且仅有`MYSQL_ROOT_PASSWORD`这个参数，你将不会出现这个问题
2. 如果在`compose.yml`文件中或者`docker run -e`中，设置了`MYSQL_ROOT_PASSWORD`、`MYSQL_ROOT_HOST`、`MYSQL_USER`、`MYSQL_PASSWORD`，并且你的连接不是使用`root`用户连接的将会出现这个问题  
   (1)：问题：权限问题(默认只有`information_schema`这个库的权限)  
   (2)：解决办法：[**MySQL数据库远程连接创建用户权限等**](./resource/MySQL-user-Permissions.md)
### 5.4 `[output clipped, Log limit 1MiB reached]` 日志限制达到1MiB
如果在 `docker compose build "服务名"` 出现了这句话并且构建失败，命令改成 ` COMPOSE_DOCKER_CLI_BUILD=0 DOCKER_BUILDKIT=0 docker compose build "服务名"` 可以看到的错误信息，方便修改
## 6 alpine 镜像内 apk 部分命令详解
[**apk 部分命令详解**](resource/apk-details.md)
## 致谢
该项目起初参考了很多**开源项目**的**解决方案，开源不易，感谢分享**
* 该项目参考 **yeszao/dnmp** 仓库：<a href="https://github.com/yeszao/dnmp" target="_blank"> https://github.com/yeszao/dnmp </a>
* 该项目使用了 **docker-php-extension-installer** 快速安装PHP扩展脚本：<a href="https://github.com/mlocati/docker-php-extension-installer" target="_blank"> https://github.com/mlocati/docker-php-extension-installer </a>
## 开源共建
开源项目离不开大家的支持，如果您有好的想法，遇到一些 BUG 并修复了，欢迎小伙伴们提交 Pull Request 参与开源贡献
1. **fork** 本项目到自己的 **repo**
2. 把 **fork** 过去的项目也就是你仓库中的项目 **clone** 到你的本地
3. 修改代码
4. **commit** 后 **push** 到自己的库
5. 发起**PR（ pull request）** 请求，提交到 **develop** 分支
6. 等待作者合并
感谢每一位使用代码的朋友。
如果对您有帮助，您可以点右上角 💘Star💘 支持,提前感谢 😁
## 开源协议
[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0.html)


[![Star History Chart](https://api.star-history.com/svg?repos=xiaoyu98628/dnmp&type=Date)](https://star-history.com/#xiaoyu98628/dnmp&Date)
