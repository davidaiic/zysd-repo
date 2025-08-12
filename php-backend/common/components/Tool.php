<?php

namespace common\components;

class Tool
{
    /**
     * 检测手机号码
     * @param string $phone 手机号码
     * @return bool
     */
    public static function checkPhone($phone)
    {
        if (!isset($phone)) return false;

        if (!preg_match('/^1[0-9]{10}$/', $phone)) return false;

        return true;
    }

    /**
     * 检测密码
     * @param string $password 密码
     * @return bool
     */
    public static function checkPassword($password)
    {
        if (!isset($password)) return false;

        if (!preg_match('/^(?![0-9]+$)(?![a-zA-Z]+$)(?!([^(0-9a-zA-Z)])+$).{6,}$/', $password)) return false;

        return true;
    }

    /**
     * 检测商品金额
     * @param string $price 金额
     * @return bool
     */
    public static function checkPrice($price)
    {
        if (!isset($price)) return false;

        if (!preg_match('/^[0-9]+(.[0-9]{1,2})?$/', $price)) return false;

        return true;
    }

    /**
     * 过滤特殊字符
     * @param string $keyword 关键词
     * @return string
     */
    public static function filterKeyword($keyword)
    {
        return str_replace(array(';','&','*','%','$','#','@','~','`',',','，','\\','=','_','-','[',']','|',':','^','\'','～','。'), '', $keyword);
    }

    /**
     * 药品名称过滤字符
     * @param string $goodsName 药品名称
     * @return string
     */
    public static function filterGoodsName($goodsName)
    {
        return str_replace(array('甲磺酸','胶囊'), '', $goodsName);
    }

    /**
     * 手机号掩码处理
     * @param string $phone 手机号
     * @return string
     */
    public static function getPhoneHide($phone)
    {
        return substr_replace($phone, '****', 3, 4);
    }

    /**
     * 随机生成长度字符串
     * @param int $length 长度
     * @return string
     */
    public static function getRandomStr($length)
    {
        $pattern = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        $str = '';
        for ($i = 0; $i < $length; $i++) {
            $str .= $pattern{mt_rand(0, 35)};
        }
        return $str;
    }

    /**
     * 只保留字符串首尾字符，隐藏中间用*代替(两个字符时只显示第一个)
     * @param string $username 用户名
     * @return string
     */
    public static function substrCut($username)
    {
        $strlen = mb_strlen($username, 'utf-8');
        $firstStr = mb_substr($username, 0, 1, 'utf-8');
        $lastStr = mb_substr($username, -1, 1, 'utf-8');
        if ($strlen == 2) return $firstStr . str_repeat('*', mb_strlen($username, 'utf-8') - 1);
        return $firstStr . str_repeat('*', $strlen - 2) . $lastStr;
    }

    /**
     * 获取时间文案
     * @param int $created 时间戳
     * @return false|string
     */
    public static function getTimeText($created)
    {
        $nowTime = time();
        $durTime = $nowTime - $created;

        if ($durTime < 60) {
            return '刚刚';
        } else if ($durTime < 3600) {
            return floor($durTime / 60) . '分钟前';
        } else if ($durTime < 86400) {
            return floor($durTime / 3600) . '小时前';
        } else if ($durTime < 259200) {
            return floor($durTime / 86400) . '天前';
        } else {
            return date('m-d', $created);
        }
    }

    /**
     * 获取起始位置
     * @param int $page 页数
     * @param int $limit 数量
     * @return float|int
     */
    public static function getOffset($page, $limit)
    {
        return ($page - 1) * $limit;
    }

    /**
     * 图片类型
     * @return array
     */
    public static function getImageType()
    {
        return ['jpeg', 'jpg', 'png', 'gif', 'docx', 'doc', 'pdf'];
    }

    /**
     * 上市区域
     */
    public static function getMarketPlace()
    {
        return ['美国上市', '欧盟上市', '日本上市', '中国香港上市', '中国大陆上市'];
    }

    /**
     * 药品说明书目录
     */
    public static function getInstrCorrespond()
    {
        return [
            'composition' => '主要成份',
            'character' => '性状',
            'specs' => '规格',
            'indication' => '适应症',
            'usageDosage' => '用法用量',
            'reaction' => '不良反应',
            'taboo' => '禁忌',
            'attention' => '注意事项',
            'womanDosage' => '孕妇及哺乳期妇女用药',
            'childrenDosage' => '儿童用药',
            'elderlyDosage' => '老年患者用药',
            'interactions' => '药物相互作用',
            'toxicology' => '药理毒理',
            'pharmacokinetics' => '药代动力学',
            'drugOverdose' => '药物过量',
            'clinicalTrial' => '临床试验',
            'storage' => '贮藏',
            'unit' => '包装单位',
            'period' => '有效期',
            'number' => '批准文号',
            'importNumber' => '进口药品注册证号',
            'licenseHolder' => '药品上市许可持有人',
            'licenseAddress' => '药品上市许可持有人地址',
            'importCompany' => '进口分装企业',
            'image' => '图片',
            'other' => '其他'
        ];
    }

    /**
     * 创建文件夹
     * @param string $folder 文件夹名称
     * @param int $mode 模式
     * @return bool
     */
    public static function mkdirFolder($folder, $mode = 0777)
    {
        if (!is_dir($folder)) {
            mkdir($folder, $mode, true);
        }

        return true;
    }

    /**
     * 返回http还是https
     * @return string
     */
    public static function getHttpHost()
    {
        if (isset($_SERVER['HTTP_X_CLIENT_SCHEME'])) {
            $scheme = $_SERVER['HTTP_X_CLIENT_SCHEME'] . '://';
        } else if (isset($_SERVER['REQUEST_SCHEME'])) {
            $scheme = $_SERVER['REQUEST_SCHEME'] . '://';
        } else {
            $scheme = 'http://';
        }

        return $scheme;
    }

    /**
     * 获取时间
     * @param bool $x
     * @return float|string
     */
    public static function getMillisecond($x = false)
    {
        list($t1, $t2) = explode(' ', microtime());
        $str = (float)sprintf('%.0f', (floatval($t1) + floatval($t2)) * 1000);
        $str = $x ? $str . rand(1000, 9999) : $str;
        return $str;
    }

    /**
     * 生成日期数据格式
     * @param int $num 多少个月
     * @return array
     */
    public static function generateDateData($num)
    {
        $today = date('Y-m-d');
        $oldDay = strtotime("-$num month", strtotime($today));
        $dateList = [];
        $priceList = [];
        for ($i = 0; $i <= $num; ++$i) {
            $t = strtotime("+$i month", $oldDay);
            $dateList[] = date('n月', $t);
            $priceList[] = '';
        }
        return ['dateList' => $dateList, 'priceList' => $priceList];
    }

    /**
     * 排序条件
     */
    public static function getSortCondition()
    {
        return [[
            'sortId' => '1',
            'name'   => '最新'
        ]];
    }

    /**
     * 获取访问者ip
     */
    public static function getRealIp()
    {
        $ip = false;

        if (!empty($_SERVER["HTTP_CLIENT_IP"])) {
            $ip = $_SERVER["HTTP_CLIENT_IP"];
        }

        if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
            $ips = explode (", ", $_SERVER['HTTP_X_FORWARDED_FOR']);

            if ($ip) {
                array_unshift($ips, $ip);
                $ip = false;
            }

            for ($i = 0; $i < count($ips); $i++) {
                if (!preg_match("/^(10│172.16│192.168)./", $ips[$i])) {
                    $ip = $ips[$i];
                    break;
                }
            }
        }

        return $ip ? $ip : $_SERVER['REMOTE_ADDR'];
    }

    /**
     * CURL发送Request请求,含POST和REQUEST
     * @param string $url 请求的链接
     * @param mixed $params 传递的参数
     * @param string $method 请求的方法
     * @param mixed $options CURL的参数
     * @return bool|string
     */
    public static function sendRequest($url, $params = [], $method = 'POST', $options = [])
    {
        //孟加拉海湾制药特殊请求
        if (isset($params['mengjialahaiwanzhiyao'])) {
            $special = 1;
            unset($params['mengjialahaiwanzhiyao']);
            $params = json_encode($params);
        } else {
            $special = 0;
        }

        $method = strtoupper($method);
        $protocol = substr($url, 0, 5);
        $query_string = is_array($params) ? http_build_query($params) : $params;

        $ch = curl_init();
        $defaults = [];
        if ('GET' == $method) {
            $geturl = $query_string ? $url . (stripos($url, "?") !== false ? "&" : "?") . $query_string : $url;
            $defaults[CURLOPT_URL] = $geturl;
        } else {
            $defaults[CURLOPT_URL] = $url;
            if ($method == 'POST') {
                $defaults[CURLOPT_POST] = 1;
            } else {
                $defaults[CURLOPT_CUSTOMREQUEST] = $method;
            }
            $defaults[CURLOPT_POSTFIELDS] = $params;
        }

        $defaults[CURLOPT_HEADER] = false;
        $defaults[CURLOPT_USERAGENT] = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.98 Safari/537.36";
        $defaults[CURLOPT_FOLLOWLOCATION] = true;
        $defaults[CURLOPT_RETURNTRANSFER] = true;
        $defaults[CURLOPT_CONNECTTIMEOUT] = 3;
        $defaults[CURLOPT_TIMEOUT] = 3;

        // disable 100-continue
        if ($special == 1) {
            curl_setopt($ch, CURLOPT_HTTPHEADER, array('Expect:', 'authorization: Basic amVucGhhcl9hcGlfc3ZyOlhAMGU4MUNmUEdM'));
        } else {
            curl_setopt($ch, CURLOPT_HTTPHEADER, array('Expect:'));
        }

        if ('https' == $protocol) {
            $defaults[CURLOPT_SSL_VERIFYPEER] = false;
            $defaults[CURLOPT_SSL_VERIFYHOST] = false;
        }

        curl_setopt_array($ch, (array)$options + $defaults);

        $ret = curl_exec($ch);
        curl_close($ch);

        return $ret;
    }
}
