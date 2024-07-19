# 一. 创建用户
## 1. 命令:

```sql
CREATE USER 'username'@'host' IDENTIFIED BY 'password';
```

## 2. 说明：

 - username：你将创建的用户名
 - host：指定该用户在哪个主机上可以登陆，如果是本地用户可用localhost，如果想让该用户可以从**任意远程主机登陆**，可以使用通配符%
 - password：该用户的登陆密码，密码可以为空，如果为空则该用户可以不需要密码登陆服务器
## 3. 例子：

```sql
CREATE USER 'dog'@'localhost' IDENTIFIED BY '123456';
CREATE USER 'pig'@'36.7.0.0' IDENDIFIED BY '123456';
CREATE USER 'pig'@'%' IDENTIFIED BY '123456';
CREATE USER 'pig'@'%' IDENTIFIED BY '';
CREATE USER 'pig'@'%';
```

# 二. 授权:
## 1. 命令:

```sql
GRANT privileges ON database_name.table_name TO 'username'@'host';
```

## 2. 说明:
 - privileges：用户的操作权限，如SELECT，INSERT，UPDATE等，如果要授予所的权限则使用ALL
 - database_name：数据库名
 - table_name：表名，如果要授予该用户对所有数据库和表的相应操作权限则可用\*表示，如\*.\*
## 3. 例子:

```sql
GRANT SELECT,INSERT ON test.user TO 'pig'@'%';
GRANT ALL ON *.* TO 'pig'@'%';
GRANT ALL ON test.* TO 'pig'@'%';
```
## 4. 注意:
用以上命令授权的用户不能给其它用户授权，如果想让该用户可以授权，用以下命令:

```sql
GRANT privileges ON database_name.table_name TO 'username'@'host' WITH GRANT OPTION;
```
## 5. 刷新权限

```sql
FLUSH PRIVILEGES; 
```
# 三.设置与更改用户密码
## 1. 命令:

```sql
SET PASSWORD FOR 'username'@'host' = PASSWORD('new_password');
```
如果是当前登陆用户用:

```sql
SET PASSWORD = PASSWORD("new_password");
```
## 2. 例子:

```sql
SET PASSWORD FOR 'pig'@'%' = PASSWORD("123456");
```
# 四. 撤销用户权限
## 1. 命令:
```sql
REVOKE privilege ON database_name.table_name FROM 'username'@'host';
```
## 2. 说明:
privilege, database_name, table_name：同授权部分
## 3. 例子:

```sql
REVOKE SELECT ON *.* FROM 'pig'@'%';
```
## 4. 注意:
假如你在给用户'pig'@'%'授权的时候是这样的（或类似的）：GRANT SELECT ON test.user TO 'pig'@'%'，则在使用REVOKE SELECT ON *.* FROM 'pig'@'%';命令并不能撤销该用户对test数据库中user表的SELECT 操作。相反，如果授权使用的是GRANT SELECT ON *.* TO 'pig'@'%';则REVOKE SELECT ON test.user FROM 'pig'@'%';命令也不能撤销该用户对test数据库中user表的Select权限。

具体信息可以用命令SHOW GRANTS FOR 'pig'@'%'; 查看。
# 五.删除用户
## 1. 命令:

```sql
DROP USER 'username'@'host';
```