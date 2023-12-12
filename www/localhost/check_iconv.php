<?php
/**
 * 检测 iconv 扩展是否有问题
 * @desc 检测字符串是不是繁体
 * @return void
 */
function test () {
    $text = "再次恐惧，Sragen Ngawi警方因预计PSHT骚扰";
    $strGbk = iconv("UTF-8", "GBK//IGNORE", $text);
    $strGb2312 = iconv("UTF-8", "GB2312//IGNORE", $text);

    if ($strGbk == $strGb2312) {
        echo '简体';
    } else {
        echo '繁体';
    }
}

test();