DNMP（Docker + Nginx + MySQL + PHP）是一款全功能的LNMP环境一键安装程序，可多版本

其中部分代码参考[[**yeszao/dnmp(github)**]](https://github.com/yeszao/dnmp) 或 [[**yeszao/dnmp(gitee)**]](https://gitee.com/yeszao/dnmp)

> 使用前最好阅读一遍下面的说明文件，以便快速上手，遇到问题也能及时排查

### 项目特点
1. 开源
2. 遵循Docker标准
3. 支持**多版本PHP**共存，可任意切换
4. 支持绑定**任意多个域名**
5. **PHP源代码、MySQL数据、配置文件、日志文件**都可在主机中直接修改查看
6. 默认支持`pdo_mysql`、`mysqli`、`mbstring`、`gd`、`curl`等常用热门扩展，根据环境灵活配置
7. 可一键配置常用服务（后续会增加）
    - 多PHP版本：PHP7.2、PHP7.3、PHP7.4、PHP8.0、PHP8.1
    - Web服务：Nginx
    - 数据库：MySQL、Redis、Elasticsearch、Mongo、
    - 消息队列：RabbitMQ
    - 辅助工具：Kibana、mongo-express
8. 实际项目中应用，确保`100%`可用
9. 所有镜像源于[**Docker官方仓库**](https://hub.docker.com)，安全可靠
10. 一次配置，**Windows、Linux、MacOs**皆可用

## 1. 目录结构
```markdown
|-- data                         数据库数据目录
|     |--- mysql                      mysql 数据目录（多版本）
|--- logs                        日志目录
|     |--- mysql                      mysql 数据目录（多版本）
|--- plugins                     插件目录
|     |--- elasticsearch              elasticsearch 插件目录（多版本）
|--- resource                    资源目录(存放图片和.md的说明文件)
|--- servers                     服务构建文件和配置文件目录
|     |--- elasticsearch              elasticsearch 配置文件目录（多版本）
|     |--- kibana                     kibana 配置文件目录（多版本）
|     |--- mysql                      mysql 配置文件目录（多版本）
|     |--- mongo                      mongo 配置文件目录（多版本）
|     |--- nginx                      nginx 配置文件目录（多版本）
|     |--- php                        php 配置文件目录（多版本）
|     |--- redis                      redis 配置文件目录（多版本）
|     |--- rabbitmq                   rabbitmq 配置文件目录（多版本）
|     |--- panel                      php 套接字文件目录
|--- www                         项目文件目录
|--- bashrc.sample               .bashrc 配置示例文件(宿主机使用容器内命令)
|--- sample.env                  环境配置示例文件
|--- docker-compose.sample.yml   Docker 服务配置示例文件
```

## 2. 快速使用
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
   cd dnmp                                          # 进入项目目录
   cp sample.env .env                               # 复制并改名 .env 配置文件
   cp docker-compose.sample.yml docker-compose.yml  # 复制并改名 docker-compose.yml 配置文件
   
   # 执行 docker-compose up 之前，建议看一下docker-compose.yml 文件，以便快速上手。
   docker-compose up                                # 启动服务
   ```

4. 启动之后查看PHP版本
   ```shell script
   http://localhost/         # PHP72
   http://localhost/73       # PHP73
   http://localhost/74       # PHP74
   http://localhost/80       # PHP80
   http://localhost/81       # PHP81
   ```

## 3. 关于容器

### 3.1 PHP 
#### 3.1.1 docker容器里安装PHP扩展常用命令
* `docker-php-source`
   > 此命令，实际上就是在PHP容器中创建一个`/usr/src/php`的目录，里面放了一些自带的文件而已。我们就把它当作一个从互联网中下载下来的PHP扩展源码的存放目录即可。事实上，所有PHP扩展源码扩展存放的路径： `/usr/src/php/ext` 里面。
* `docker-php-ext-install`
   > 这个命令，就是用来启动 PHP扩展 的。我们使用pecl安装PHP扩展的时候，默认是没有启动这个扩展的，如果想要使用这个扩展必须要在php.ini这个配置文件中去配置一下才能使用这个PHP扩展。而 `docker-php-ext-enable` 这个命令则是自动给我们来启动PHP扩展的，不需要你去php.ini这个配置文件中去配置。
* `docker-php-ext-enable`
   > 这个命令，是用来安装并启动PHP扩展的。命令格：`docker-php-ext-install "源码包目录名"`
* `docker-php-ext-configure`
   > 一般都是需要跟 docker-php-ext-install搭配使用的。它的作用就是，当你安装扩展的时候，需要自定义配置时，就可以使用它来帮你做到。
* [**Docker容器里 PHP安装扩展**](resource/php-install-ext.md)  
   >**注意：如果是在容器内安装扩展，容器删除，扩展会失效，建议直接在.env文件里对应的版本下添加对应的扩展，然后重新`docker-compose build php72`**
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
   # pdo_mysql,pcntl,mysqli,exif,bcmath,opcache,gettext,gd,sockets,shmop,intl,bz2,soap,zip,xsl
   # redis,swoole,memcached,xdebug,mongodb,amqp
   #
   # You can let it empty to avoid installing any extensions,
   # +--------------------------------------------------------------------------------------------+
   PHP_EXTENSIONS_72=pdo_mysql,mysqli,gd,redis
   ```

#### 3.1.2 PHP容器中的composer镜像修改
1. composer查看全局设置
   ```shell script
   composer config -gl
   ```
2. 设置composer镜像为国内镜像
   ```shell script
   composer config -g repo.packagist composer https://packagist.phpcomposer.com
   # 或
   composer config -g repo.packagist composer https://mirrors.aliyun.com/composer
   ```

#### 3.1.3 phpstorm 配置 xdebug
[**phpstorm 配置 xdebug**](resource/phpstorm-xdebug.md)

#### 3.1.4 宿主机中使用PHP命令行
1. 参考[bashrc.sample](bashrc.sample)示例文件，将对应的php-cli函数拷贝到主机的 `~/.bashrc` 文件中。
2. 让文件起效：
   ```shell script
   source ~/.bashrc
   ```
3. 然后就可以在主机中执行PHP命令了：
   ```shell script
   [root@centos ~]# php72 -v
   PHP 7.2.34 (cli) (built: Dec 17 2020 10:32:53) ( NTS )
   Copyright (c) 1997-2018 The PHP Group
   Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
   [root@centos ~]#
   ```

### 3.2 Nginx
#### 3.2.1 切换PHP版本
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

### 3.3 Elasticsearch
#### 3.3.1 Elasticsearch账号密码设置
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

### 3.4 Kibana
#### 3.4.1 Kibana连接Elasticsearch问题
```shell script
 elasticsearch.username: "kibana_system或kibana"
 elasticsearch.password: "上面Elasticsearch生成的密码"
```

### 3.5 Mongo
#### 3.5.1 `system.sessions`文档没权限访问
授权
```javascript
db.grantRolesToUser('userName',[{role:"<role>",db:"<database>"}])

// 例如
db.grantRolesToUser('root',[{role:"__system",db:"admin"}])
```

## 4. 关于挂载权限问题
由于数据卷和日志卷分离的原因，部分容器启动需要对应的权限，然而宿主机上没有与之对应的权限，所以我们直接赋予`777`权限即可
### 4.1. mysql
需要给 `./logs/mysql` 文件夹赋予权限 `chmod -R 777 ./logs/mysql` 重启即可

### 4.2 Elasticsearch
需要给 `./data/elasticsearch`、 `./logs/elasticsearch` 文件夹赋予权限 `chmod -R 777 ./data/elasticsearch ./logs/elasticsearch` 重启即可

### 4.3 Mongo 
需要给 `./data/mongo`、 `./logs/mongo` 文件夹赋予权限 `chmod -R 777 ./data/mongo ./logs/mongo` 重启即可

### 4.4 RabbitMQ
需要给 `./data/rabbitmq`、 `./logs/rabbitmq` 文件夹赋予权限 `chmod -R 777 ./data/rabbitmq ./logs/rabbitmq` 重启即可

## 5. 管理命令
### 5.1. 服务器启动和构建命令
如需管理服务，请在命令后面加上服务器名称，例如：
```shell script
docker-compose up                       # 创建并启动所有服务
docker-compose up -d                    # 创建并以后台运行方式启动所有服务
docker-compose up "服务名..."            # 创建并启动服务
docker-compose up -d "服务名..."         # 创建并以后台运行的方式启动服务

docker-compose start "服务名..."         # 启动服务
docker-compose stop "服务名..."          # 停止服务
docker-compose restart "服务名..."       # 重启服务

docker-compose build "服务名..."         # 构建或者重新构建服务

docker-compose rm "服务名..."            # 删除并停止

docker-compose down                     # 停止并删除容器，网络，图像和挂载卷
```

## 6. 其他问题
### 6.1 `docker-compose.sample.yml` 文件中 `volumes` 的 rw、ro详解
众所周知，如果启动容器不使用挂载宿主机的文件或文件夹，容器中的配置文件只能进入容器才能修改，输出的日志文件也是在容器里面，查看不方便，也不利于日志收集，所以一般都是使用参数来挂载文件或文件夹。  
而其中的**rw**、**ro**和**不指定**模式，是比较重要的一个环节，关系到宿主机与容器的文件、文件夹变化关系，下面来一一详解
1. **不指定**  
   (1)文件：宿主机修改该文件后容器里面看不到变化；容器里面修改该文件，宿主机也看不到变化   
   (2)文件夹：不管是宿主机还是容器内修改，新增，删除，都会同步
2. **ro**  
   (1)文件：容器内不能修改，会提示readonly  
   (2)文件夹：容器内不能修改，新增，删除文件夹中的文件，会提示readonly
3. **rw**  
   (1)文件：不管是宿主机还是容器内修改，都会相互同步，但容器内不允许删除，会提示Devivce or resource busy；宿主机删除文件，容器内的不会被同步  
   (2)文件夹：不管是宿主机还是容器内修改，新增，删除都会相互同步

### 6.2 容器内时间问题
容器时间在.env文件中配置`TZ`变量，所有支持的时区请查看[**时区列表·维基百科**](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) 或者 [**PHP所支持的时区列表·PHP官网**](https://www.php.net/manual/zh/timezones.php) 。

### 6.3 windows下使用PHP
PHP镜像构建失败的建议将PHP的版本改成apline3.12，否则pecl安装的扩展都会失败，[**原因**](https://www.editcode.net/thread-404502-1-1.html)

### 6.4 SQLSTATE[HY000] [1044] Access denied for user '你的用户名'@'%' to database 'mysql'
1. 如果在`docker-compose.yml`文件中或者`docker run -e`中，设置并且有且仅有`MYSQL_ROOT_PASSWORD`这个参数，你将不会出现这个问题
2. 如果在`docker-compose.yml`文件中或者`docker run -e`中，设置了`MYSQL_ROOT_PASSWORD`、`MYSQL_ROOT_HOST`、`MYSQL_USER`、`MYSQL_PASSWORD`，并且你的连接不是使用`root`用户连接的将会出现这个问题  
   (1)：问题：权限问题(默认只有`information_schema`这个库的权限)  
   (2)：解决办法：[**MySQL数据库远程连接创建用户权限等**](./resource/MySQL-user-Permissions.md)

### 6.5 `[output clipped, Log limit 1MiB reached]` 日志限制达到1MiB
如果在 `docker-compose build "服务名"` 出现了这句话并且构建失败，命令改成 ` COMPOSE_DOCKER_CLI_BUILD=0 DOCKER_BUILDKIT=0 docker-compose build "服务名"` 可以看到的错误信息，方便修改

## 7. 正式环境中使用
1. 权限认证
2. 日志文件  
以上两点，服务中都存在，如果还是感觉哪里不妥，请自行修改

## License
MIT