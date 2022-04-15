DNMP（Docker + Nginx + MySQL + PHP）是一款全功能的LNMP环境一键安装程序，可多版本

#### 项目特点
1. 开源
2. 遵循Docker标准
3. 支持**多版本PHP**共存，可任意切换（目前只有73,74 后续会增加）
4. 支持绑定**任意多个域名**
5. **PHP源代码、MySQL数据、配置文件、日志文件**都可在主机中直接修改查看
6. 默认支持`pdo_mysql`、`mysqli`、`mbstring`、`gd`、`curl`、`opcache`等常用热门扩展，根据环境灵活配置
7. 可一键配置常用服务（后续会增加）
    - 多PHP版本：PHP7.3、PHP7.4
    - Web服务：Nginx
    - 数据库：MySQL8.0、Redis6
8. 实际项目中应用，确保可用
9. 一次配置，**Windows、Linux、MacOs**皆可用

#### 目录结构
```
|-- data                         数据库数据目录
|     |--- mysql                      mysql 数据目录（多版本）
|--- logs                        日志目录
|--- servers                     服务构建文件和配置文件目录
|     |--- mysql                      mysql 配置文件目录（多版本）
|     |--- nginx                      nginx 配置文件目录（多版本）
|     |--- php                        php 配置文件目录（多版本）
|     |--- redis                      redis 配置文件目录（多版本）
|     |--- panel                      php 套接字文件目录
|--- www                         项目文件目录
|--- .env                        环境配置示例文件
|--- docker-compose.yml          Docker 服务配置示例文件
```