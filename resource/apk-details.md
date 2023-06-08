## 阿里云仓库地址 [https://mirrors.aliyun.com/alpine](https://mirrors.aliyun.com/alpine)
## 官方仓库(需要科学上网) [https://pkgs.alpinelinux.org/packages](https://pkgs.alpinelinux.org/packages)

# 一. alpine 镜像内 apk 命令详解

## 1. apk add 
### 安装PACKAGES并自动解决依赖关系
```shell
# 安装软件包
$ apk add [包名]

# --no-cache 不使用缓存（推荐) 不使用缓存能减少容器中的尺寸
$ apk add --no-cache [包名]

# --update-cache 更新缓存
$ apk add --update-cache --repository https://mirrors.aliyun.com/alpine/edge/main --allow-untrusted

# -U 选项表示在安装软件包之前更新软件包索引
$ apk add -U [包名]

# --allow-untrusted 允许安装未经数字签名或无法通过包管理器验证签名的软件包,例如从第三方存储库或来源安装软件包
$ apk add --allow-untrusted [包名]

# 安装指定版本软件包
$ apk add asterisk=1.6.0.21-r0
$ apk add 'asterisk<1.6.1'
$ apk add 'asterisk>1.6.1'
```

## 2. apk del
### 卸载并删除PACKAGES
```shell
# 卸载包
$ apk del [包名]
```

## 3. apk update
### 从远程镜像源中更新本地镜像源索引
```shell
# 更新最新本地镜像源
$ apk update
```

## 4. apk search
### 搜索软件包
```shell
# 查找所有可用软件包
$ apk search [包名]

# 通过软件包名称查找软件包 以 acf 开头的包名
$ apk search -v 'acf*'

# 通过描述文件查找特定的软件包 包含 docker 的包名
$ apk search -v -d 'docker'
```

## 5. apk upgrade
### 升级已经安装过的包
```shell
# 升级全部软件
$ apk upgrade

# 指定升级软件包
$ apk add --upgrade [包名]

# 指定升级软件包 同上
$ apk add -u [包名] 
```

## 6. apk info
### 列出PACKAGES或镜像源的详细信息
```shell
# 列出所有已安装的软件包
$ apk info

# 显示完整的软件包信息
$ apk info -a [包名]

# 显示指定文件属于的包
$ apk info --who-owns [文件路径] # 例如 /sbin/apk
```

## 7. 其他
```shell
# 清理缓存
$ apk cache clean

## -v 显示详情
$ apk -v cache clean
```

# 二. 关于 apk add --no-cache --virtual .build-deps [包名] 命令详解
```shell
-t, --virtual NAME    Create virtual package NAME with given dependencies
```
这意味着当您安装软件包时，这些软件包不会添加到全局软件包中。这种变化可以很容易地恢复。所以，如果我需要gcc来编译程序，但是一旦程序被编译，我就不再需要gcc了。  
我可以在虚拟包中安装gcc和其他必需的包，并且可以删除所有依赖项，并删除此虚拟包名称。以下是示例用法
```shell
apk add --virtual mypacks gcc vim
apk del mypacks
```
使用第一个命令安装的所有18个软件包将被下一个命令删除