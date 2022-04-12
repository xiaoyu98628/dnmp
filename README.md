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
|     |--- MySQL                      MySQL 数据目录（多版本）
|--- logs                        日志目录
|--- servers                     服务构建文件和配置文件目录
|     |--- MySQL                      MySQL 配置文件目录（多版本）
|     |--- Nginx                      Nginx 配置文件目录（多版本）
|     |--- PHP                        PHP 配置文件目录（多版本）
|     |--- Redis                      Redis 配置文件目录（多版本）
|     |--- panel                      PHP 套接字文件目录
|--- www                         项目文件目录
|--- .env                        环境配置示例文件
|--- docker-compose.yml          Docker 服务配置示例文件
```

#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
