DNMP（Docker + Nginx + MySQL + PHP）是一款全功能的LNMP环境一键安装程序，可多版本

### 项目特点
1. 开源
2. 遵循Docker标准
3. 支持**多版本PHP**共存，可任意切换
4. 支持绑定**任意多个域名**
5. **PHP源代码、MySQL数据、配置文件、日志文件**都可在主机中直接修改查看
6. 默认支持`pdo_mysql`、`mysqli`、`mbstring`、`gd`、`curl`、`opcache`等常用热门扩展，根据环境灵活配置
7. 可一键配置常用服务（后续会增加）
    - 多PHP版本：PHP7.3、PHP7.4、PHP8.0、PHP8.1
    - Web服务：Nginx
    - 数据库：MySQL8.0、Redis6、Elasticsearch
    - 辅助工具：Kibana
8. 实际项目中应用，确保可用
9. 一次配置，**Windows、Linux、MacOs**皆可用

### 1.目录结构
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
|--- .env                        环境配置示例文件
|--- docker-compose.yml          Docker 服务配置示例文件
```

### 2.管理命令
#### 2.1. 服务器启动和构建命令
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

### 3.PHP
#### 3.1 关于windows下使用PHP
将PHP的版本改成apline3.12，否则pecl安装的扩展都会失败，[原因](https://www.editcode.net/thread-404502-1-1.html)

### 4.关于log
Log文件生成的位置依赖于conf下各log配置的值
#### 4.1. mysql日志
- 因为MySQL容器中的MySQL使用的是mysql用户启动，它无法自行在/var/log下的增加日志文件。所以，我们把MySQL的日志放在与data一样的目录，即项目的mysql目录下，对应容器中的/var/lib/mysql/目录。
- 如果真的需要分开，在启动mysql服务后，进入容器在执行：` chown -R mysql:mysql /var/log/mysql ` 然后在` servers/mysql/mysql8.0/conf.d/docker.cnf ` 文件中去掉关于日志的注释，重启即可，日志数据卷默认挂载