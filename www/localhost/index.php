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
echo '</ul>';

echo '<h2>已安装扩展：</h2>';
printExtensions();

// 获取本地时间
echo '
<script src="./js/moment.min.js"></script>
<script>
// 获取元素
let currentTimeEle = document.getElementById("current-time");

// 定时器，动态更新时间
setInterval(function(){
    // 获取当前时间
    let date = new Date();

    // 设置元素的文本
    currentTimeEle.innerHTML = moment(date).format("YYYY-MM-DD HH:mm:ss");
}, 1000); // 每秒更新一次
</script>
';

/**
 * 获取MySQL版本
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
 * 获取Redis版本
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
 * 获取MongoDB版本
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
 * 获取已安装扩展列表
 */
function printExtensions(): void
{
    echo '<ol>';
    foreach (get_loaded_extensions() as $name) {
        echo "<li>", $name, '=', phpversion($name), '</li>';
    }
    echo '</ol>';
}
