### supervisor.conf配置文件说明
```ini
[unix_http_server]
file=/tmp/supervisor.sock   ;UNIX socket 文件，supervisorctl 会使用
;chmod=0700                 ;socket文件的mode，默认是0700
;chown=nobody:nogroup       ;socket文件的owner，格式：uid:gid

;[inet_http_server]         ;HTTP服务器，提供web管理界面
;port=127.0.0.1:9001        ;Web管理后台运行的IP和端口，如果开放到公网，需要注意安全性
;username=user              ;登录管理后台的用户名
;password=123               ;登录管理后台的密码

[supervisord]
logfile=/tmp/supervisord.log ;日志文件，默认是 $CWD/supervisord.log
logfile_maxbytes=50MB        ;日志文件大小，超出会rotate，默认 50MB，如果设成0，表示不限制大小
logfile_backups=10           ;日志文件保留备份数量默认10，设为0表示不备份
loglevel=info                ;日志级别，默认info，其它: debug,warn,trace
pidfile=/tmp/supervisord.pid ;pid 文件
nodaemon=false               ;是否在前台启动，默认是false，即以 daemon 的方式启动
minfds=1024                  ;可以打开的文件描述符的最小值，默认 1024
minprocs=200                 ;可以打开的进程数的最小值，默认 200

[supervisorctl]
serverurl=unix:///tmp/supervisor.sock ;通过UNIX socket连接supervisord，路径与unix_http_server部分的file一致
;serverurl=http://127.0.0.1:9001 ; 通过HTTP的方式连接supervisord

; [program:xx]是被管理的进程配置参数，xx是进程的名称
[program:xx]
command=/opt/apache-tomcat-8.0.35/bin/catalina.sh run  ; 程序启动命令
autostart=true       ; 在supervisord启动的时候也自动启动
startsecs=10         ; 启动10秒后没有异常退出，就表示进程正常启动了，默认为1秒
autorestart=true     ; 程序退出后自动重启,可选值：[unexpected,true,false]，默认为unexpected，表示进程意外杀死后才重启
startretries=3       ; 启动失败自动重试次数，默认是3
user=tomcat          ; 用哪个用户启动进程，默认是root
priority=999         ; 进程启动优先级，默认999，值小的优先启动
redirect_stderr=true ; 把stderr重定向到stdout，默认false
stdout_logfile_maxbytes=20MB  ; stdout 日志文件大小，默认50MB
stdout_logfile_backups = 20   ; stdout 日志文件备份数，默认是10
; stdout 日志文件，需要注意当指定目录不存在时无法正常启动，所以需要手动创建目录（supervisord 会自动创建日志文件）
stdout_logfile=/opt/apache-tomcat-8.0.35/logs/catalina.out
stopasgroup=false     ;默认为false,进程被杀死时，是否向这个进程组发送stop信号，包括子进程
killasgroup=false     ;默认为false，向进程组发送kill信号，包括子进程

;包含其它配置文件
[include]
files = relative/directory/*.ini    ;可以指定一个或多个以.ini结束的配置文件
```

### 项目配置文件说明
> 给需要管理的子进程（程序）编写一个配置文件，放在`./servers/panel/plugins/php/php7.2/supervisor.d/`目录下，以`.ini`作为扩展名（每个进程的配置文件都可以单独分拆也可以把相关项目的脚本放一起）。
```ini
;要和文件名称相同
[program:blog]
;启动该程序时将运行的命令
command=
;表示command命令的执行目录
directory=
;supervisor 启动的时候是否随着同时启动，默认 True
autostart=true
;当程序exit的时候，这个program不会自动重启,默认unexpected，设置子进程挂掉后自动重启的情况，有三个选项，false,unexpected和true。如果为false不会被重新启动，如果为unexpected表示程序退出信号不在 `exitcodes` 中，则自动重启，如果为true自动重启，默认为unexpected
autorestart=false
;启动后程序需要保持运行的总秒数，以认为启动成功(将进程从STARTING状态移动到running状态)。设置为0表示程序不需要在任何特定的时间内保持运行
startsecs=3
;启动失败时的最多重试次数
startretries=3
;输出日志文件路径
stdout_logfile=/var/log/php/supervisor/项目名称.out.log
;错误日志文件路径
stderr_logfile=/var/log/php/supervisor/项目名称.err.log
;设置stdout_logfile的文件大小
stdout_logfile_maxbytes=2MB
;设置stderr_logfile的文件大小
stderr_logfile_maxbytes=2MB
;指定运行的用户
user=root
;程序在启动和关闭顺序中的相对优先级
priority=999
;启动进程的数目。当不为1时，就是进程池的概念，注意process_name的设置 默认为1    。。非必须设置
numprocs=1
;这个是进程名，如果我们下面的numprocs参数为1的话，就不用管这个参数了，它默认值%(program_name)s也就是上面的那个program冒号后面的名字，
;但是如果numprocs为多个的话，那就不能这么干了。想想也知道，不可能每个进程都用同一个进程名吧。
process_name=%(program_name)s_%(process_num)02d
;当设置为 true 时，Supervisor 在停止进程时会将信号发送到进程组的所有进程。这意味着，如果你有一个主进程和它的子进程，停止主进程时，Supervisor 会同时停止所有与主进程关联的子进程。
stopasgroup=true
;当设置为 true 时，Supervisor 在杀死进程时会将信号发送到进程组的所有进程。这确保了进程组内的所有进程都会被终止，而不仅仅是主进程。
killasgroup=true
```