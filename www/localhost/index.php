<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo '<h1 style="text-align: center;">欢迎使用DNMP！</h1>';
echo '<h2>当前时间：<span id="current-time">'  . date("Y-m-d H:i:s") .  '</span></h2>';

echo '<div style="display: flex;justify-content: space-between;font-size: 24px;font-weight: bolder">';
echo '<div>版本选择：</div>';
echo '<div><a href="/">Home</a></div>';
echo '<div><a href="/72/">PHP7.2</a></div>';
echo '<div><a href="/73/">PHP7.3</a></div>';
echo '<div><a href="/74/">PHP7.4</a></div>';
echo '<div><a href="/80/">PHP8.0</a></div>';
echo '<div><a href="/81/">PHP8.1</a></div>';
echo '<div><a href="/82/">PHP8.2</a></div>';
echo '<div><a href="/83/">PHP8.3</a></div>';
echo '<div><a href="/84/">PHP8.4</a></div>';
echo '</div>';

echo '<h2>版本信息：</h2>';
echo '<ul>';
echo '<li>PHP版本：', PHP_VERSION, '</li>';
echo '<li>服务器软件信息：', $_SERVER['SERVER_SOFTWARE'], '</li>';
echo '<li>MySQL服务器版本：', getMysqlVersion(), '</li>';
echo '<li>Redis服务器版本：', getRedisVersion(), '</li>';
echo '<li>MongoDB服务器版本：', getMongoVersion(), '</li>';
echo '<li>RabbitMQ服务器版本：', getRabbitMQVersion(), '</li>';
echo '</ul>';

echo '<h2>PHP状态监控：</h2>';
getPhpFpmStatus();

echo '<h2>已安装扩展：</h2>';
printExtensions();

// 获取本地时间
echo '
<script src="./js/moment.min.js"></script>
<script>
// 获取元素
let currentTimeEle = document.getElementById("current-time");

function getTime() {
    // 获取当前时间
    let date = new Date();
    // 设置元素的文本
    currentTimeEle.innerHTML = moment(date).format("YYYY-MM-DD HH:mm:ss");
}

// 定时器，动态更新时间
setInterval(getTime, 1000); // 每秒更新一次

// 初始化时间
getTime();
</script>
';

/**
 * PHP 状态监控
 * @return void
 */
function getPhpFpmStatus()
{
    $url = 'http://nginx1.28/'.PHP_MAJOR_VERSION.PHP_MINOR_VERSION.'/fpm-status';

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT, 5); // 设置超时时间 5 秒
    $response = curl_exec($ch);
    $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($http_code !== 200 || empty($response)) {
        echo '无法获取 PHP-FPM 状态';
        return;
    }

    // 解析返回的文本内容
    $lines = explode("\n", $response);

    echo '<style>
            table { width: 100%; border-collapse: collapse; }
            th, td { padding: 8px; text-align: left; }
            th { font-weight: bold; }
            tr:nth-child(even) { background-color: #f9f9f9; }
          </style>';
    echo '<table>';

    foreach ($lines as $line) {
        $line = trim($line);
        if (empty($line)) continue; // 跳过空行

        // 按 `:` 分割字段
        $parts = explode(":", $line, 2);
        if (count($parts) < 2) continue; // 如果没有 `:`，跳过该行

        $key = trim($parts[0]);
        $value = trim($parts[1]);

        // 添加中文注释
        switch ($key) {
            case 'pool':
                $comment = '进程池名称';
                break;
            case 'process manager':
                $comment = '进程管理模式（static、dynamic 或 ondemand）';
                break;
            case 'start time':
                $comment = '启动时间';
                break;
            case 'start since':
                $comment = '运行时长（秒）';
                break;
            case 'accepted conn':
                $comment = '已接受的连接数';
                break;
            case 'listen queue':
                $comment = '当前等待处理的请求数';
                break;
            case 'max listen queue':
                $comment = '历史最大等待请求数';
                break;
            case 'listen queue len':
                $comment = 'socket 监听队列长度';
                break;
            case 'active processes':
                $comment = '活跃进程数';
                break;
            case 'idle processes':
                $comment = '空闲进程数';
                break;
            case 'total processes':
                $comment = '总进程数';
                break;
            case 'max active processes':
                $comment = '历史最大活跃进程数';
                break;
            case 'max children reached':
                $comment = '达到进程上限次数';
                break;
            case 'slow requests':
                $comment = '慢请求数';
                break;
            case 'memory peak':
                $comment = '内存峰值（字节）';
                break;
            default:
                $comment = '未知参数';
                break;
        }
        echo "<tr>
                <td>" . htmlspecialchars($key) . "</td>
                <td>" . htmlspecialchars($value) . "</td>
                <td>" . htmlspecialchars($comment) . "</td>
              </tr>";
    }
    echo '</table>';
}

/**
 * 获取 MySQL 版本
 * @return string
 */
function getMysqlVersion(): string
{
    if (extension_loaded('PDO_MYSQL')) {
        try {
            $connect = new PDO('mysql:host=mysql80;dbname=mysql', 'xiaoyu', 'xiaoyu');
            return $connect->getAttribute(PDO::ATTR_SERVER_VERSION);
        } catch (PDOException $e) {
            return $e->getMessage();
        }
    } else {
        return 'PDO_MYSQL 扩展未安装 ×';
    }
}

/**
 * 获取 Redis 版本
 * @return string
 */
function getRedisVersion(): string
{
    if (extension_loaded('redis')) {
        try {
            $redis = new Redis();
            $redis->connect('redis62');
            $redis->auth('123456');
            $info = $redis->info();
            return $info['redis_version'];
        } catch (Exception $e) {
            return $e->getMessage();
        }
    } else {
        return 'Redis 扩展未安装 ×';
    }
}

/**
 * 获取 MongoDB 版本
 * @return string
 */
function getMongoVersion(): string
{
    if (extension_loaded('mongodb')) {
        try {
            $manager = new MongoDB\Driver\Manager('mongodb://root:root@mongodb60:27017');
            $command = new MongoDB\Driver\Command(array('serverStatus'=>true));

            $cursor = $manager->executeCommand('admin', $command)->toArray();

            return $cursor[0]->version;
        }  catch (\MongoDB\Driver\Exception\Exception $e) {
            return $e->getMessage();
        }catch (Exception $e) {
            return $e->getMessage();
        }
    } else {
        return 'MongoDB 扩展未安装 ×';
    }
}

/**
 * 获取 rabbitmq 版本
 * @return string
 */
function getRabbitMQVersion(): string
{
    if (extension_loaded('curl')) {
        try {
            $url = "http://rabbitmq3.11:15672/api/overview";
            // 使用 cURL 获取 RabbitMQ 版本信息
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_USERPWD, "root:root");
            curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
            curl_setopt($ch, CURLOPT_HTTPHEADER, ["Accept: application/json"]);
            curl_setopt($ch, CURLOPT_TIMEOUT, 5); // 5秒超时，避免长时间无响应

            $response = curl_exec($ch);
            $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);

            if ($http_code <= 0) {
                return "容器未启动";
            }

            if (empty($response)) {
                return "无法获取 RabbitMQ 版本，请检查 HTTP API 是否开启。";
            }

            $data = json_decode($response, true);
            return $data['rabbitmq_version'];
        } catch (\Exception $e) {
            return $e->getMessage();
        }
    } else {
        return 'curl 扩展未安装 ×';
    }
}

/**
 * 获取已安装扩展列表
 * @return void
 */
function printExtensions(): void
{
    echo '<ol>';
    foreach (get_loaded_extensions() as $name) {
        echo '<li>', $name, '=', phpversion($name), '</li>';
    }
    echo '</ol>';
}