<?php

namespace frontend\models\service;

use common\components\BarCode;
use common\components\Ocr;
use common\components\Tool;
use DOMDocument;
use DOMXPath;
use frontend\components\Helper;
use frontend\models\home\Article;
use frontend\models\home\ArticleLike;
use frontend\models\home\Goods;
use frontend\models\home\GoodsClass;
use frontend\models\home\GoodsServer;
use frontend\models\plugin\Setting;
use frontend\models\query\Channel;
use frontend\models\query\Company;
use frontend\models\query\CompanySearch;
use frontend\models\query\ComparePrice;
use frontend\models\query\GoodsErrorDirectory;
use frontend\models\query\ImageRecognition;
use frontend\models\query\Photo;
use frontend\models\query\PriceSearch;
use frontend\models\query\ScanLog;
use frontend\models\user\QueryLog;
use Yii;
use yii\base\ExitException;
use yii\db\Expression;
use yii\db\Query;

/**
 * 查询
 */
class QueryService
{
    /**
     * 获取人工查询信息
     * @return array
     */
    public static function getManualInfo()
    {
        //获取拍照上传服务时间
        $photoServiceTime = Setting::findByKeyword('photo_service_time');

        //获取拍照上传反馈时间
        $photoFeedbackTime = Setting::findByKeyword('photo_feedback_time');

        //获取拍照上传查询次数
        $photoQueryNum = HomeService::getManualVerifyNum();

        //获取客服微信服务时间
        $wxServiceTime = Setting::findByKeyword('wx_service_time');

        //获取客服微信反馈时间
        $wxFeedbackTime = Setting::findByKeyword('wx_feedback_time');

        //获取客服微信查询次数
        $wxQueryNum = Setting::findByKeyword('wx_query');

        return [
            'photoServiceTime'  => $photoServiceTime ? $photoServiceTime['value'] : '',
            'photoFeedbackTime' => $photoFeedbackTime ? $photoFeedbackTime['value'] : '',
            'photoQueryNum'     => $photoQueryNum,
            'wxServiceTime'     => $wxServiceTime ? $wxServiceTime['value'] : '',
            'wxFeedbackTime'    => $wxFeedbackTime ? $wxFeedbackTime['value'] : '',
            'wxQueryNum'        => $wxQueryNum ? (int)$wxQueryNum['value'] : 0
        ];
    }

    /**
     * 照片查询
     * @param int $uid 用户id
     * @param string $positive 正面
     * @param string $leftSide 左侧面
     * @param string $rightSide 右侧面
     * @param string $back 背面
     * @param string $other 其余照片
     * @param string $mobile 手机号码
     * @return array|bool
     */
    public static function uploadPhoto($uid, $positive, $leftSide, $rightSide, $back, $other, $mobile)
    {
        $photo = new Photo();
        $photo->uid = (int)$uid;
        $photo->positive = $positive;
        $photo->left_side = $leftSide;
        $photo->right_side = $rightSide;
        $photo->back = $back;
        $photo->other = $other;
        $photo->mobile = $mobile;
        $photo->created = time();

        if (!$photo->save()) return false;

        //获取拍照上传反馈时间
        $photoFeedbackTime = Setting::findByKeyword('photo_feedback_time');

        $text = '';

        if ($photoFeedbackTime && $photoFeedbackTime['value']) {
            $text = '我们会在' . str_replace('反馈', '以短信形式反馈结果', $photoFeedbackTime['value']);
        }

        //获取今天已经查询次数
        $todayNum = Photo::findTodayNum();
        $todayNum = (int)$todayNum + 1;

        //获取总共查询次数
        $totalNum = Photo::findTotalNum();
        $totalNum = (int)$totalNum * 15;

        return ['text' => $text, 'rank' => $todayNum, 'total' => $totalNum];
    }

    /**
     * 获取药厂列表
     * @param int $type 类型：0-全部，1-对接了第三方查询的药厂，2-价格相关药厂列表
     * @param string $goodsName 药品名称，type=2时传
     * @param int $page 页数
     * @return array
     */
    public static function getCompanyList($type, $goodsName, $page)
    {
        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        if ($type == 2) {
            if (!$goodsName) return [];

            $goodsNameArr = explode(' ', $goodsName);
            $goodsName = !empty($goodsNameArr) ? $goodsNameArr[0] : '';

            //搜索条件
            $condition = 'goods.enable = 0 and goods.is_delete = 0 and goods.min_price > 0 and company.enable = 0 and company.is_delete = 0 and (goods.goods_name like :keyword or goods.en_name like :keyword or goods.common_name like :keyword or goods.other_name like :keyword)';
            $params = [':keyword' => '%' . $goodsName . '%'];

            //获取相关药厂列表
            $query = new Query();
            $company = $query->select(['distinct(company.id) as companyId'])
                ->from('ky_goods as goods')
                ->innerJoin('ky_company as company', 'company.id = goods.company_id')
                ->where($condition)
                ->addParams($params)
                ->orderBy('goods.sort desc,goods.id desc')
                ->all();

            $companyList = [];
            if ($company) {
                foreach ($company as $key => $value) {
                    //获取药厂信息
                    $companyInfo = Company::findByCompanyId($value['companyId']);

                    if ($companyInfo) {
                        $companyList[] = [
                            'companyId'    => $companyInfo['id'],
                            'companyName'  => $companyInfo['company_name'],
                            'companyImage' => $companyInfo['company_image']
                        ];
                    }
                }
            }
        } else {
            $company = Company::findAllCompany($type, $offset, $pageSize);
            $companyList = self::operateCompanyData($company);
        }

        return $companyList;
    }

    /**
     * 获取药厂防伪码查询文案
     * @param int $companyId 药厂id
     * @return array
     * @throws ExitException
     */
    public static function getCompanyCodeQuery($companyId)
    {
        //获取药厂信息
        $companyInfo = Company::findCompanyDetail($companyId);

        if (!$companyInfo) Helper::responseError(1013);

        return ['codeQuery' => $companyInfo['code_query']];
    }

    /**
     * 药厂查询
     * @param int $uid 用户id
     * @param int $goodsId 药品id
     * @param string $goodsName 药品名称
     * @param int $companyId 药厂id
     * @param string $code 防伪码
     * @return array
     * @throws ExitException
     */
    public static function getCompanySearchInfo($uid, $goodsId, $goodsName, $companyId, $code)
    {
        //获取药厂信息
        $companyInfo = Company::findCompanyDetail($companyId);

        if (!$companyInfo) Helper::responseError(1013);

        if (!$companyInfo['request_url']) Helper::responseError(1014);

        //区别请求方式
        if ($companyInfo['request_method'] == 'POST') {
            if (strpos($companyInfo['request_url'], 'secid.in') !== false) {
                $paramsArr = ['code' => $code, 'ipAddress' => Tool::getRealIp(), 'mengjialahaiwanzhiyao' => 1];
            } else if (strpos($companyInfo['request_url'], 'generalpharma.com') !== false) {
                $paramsArr = ['form' => ['generate_num' => $code, '_token' => '8-iuxhbxPNfkGyAN2llGOOlwXylv5ih_O8i6JFUPik0']];
            } else {
                $paramsArr = ['code' => $code, 'time' => time()];
            }
            $response = Tool::sendRequest($companyInfo['request_url'], $paramsArr, 'POST');
        } else {
            $requestUrl = str_replace('XXXXXX', $code, $companyInfo['request_url']);

            if (strpos($companyInfo['request_url'], 'phokam.com') !== false) {
                $response = file_get_contents($requestUrl);
            } else {
                $response = Tool::sendRequest($requestUrl, [], 'GET');
            }
        }

        //默认无法识别
        $resultType = 0;

        //默认药品名称
        if ($goodsName) {
            $goodsNameArr = explode(' ', $goodsName);
            $goodsName = !empty($goodsNameArr) ? $goodsNameArr[0] : '';
        } else {
            $goodsName = '';
        }

        //各个厂家分别判断结果
        if (strpos($companyInfo['request_url'], 'beaconverify.com') !== false) {
            //孟加拉碧康制药
            $res = self::getMjlbkzyResult($response);
            $response = $res['content'];
            $resultType = $res['resultType'];
        } else if (strpos($companyInfo['request_url'], 'drug-international.com') !== false) {
            //孟加拉耀品国际药厂
            $res = self::getMjlypgjycResult($response);
            $response = $res['content'];
            $resultType = $res['resultType'];
        } else if (strpos($companyInfo['request_url'], 'secid.in') !== false) {
            //孟加拉海湾制药
            $res = self::getMjlhwzyResult($response);
            $response = $res['content'];
            $resultType = $res['resultType'];
        } else if (strpos($companyInfo['request_url'], 'fw.wechat315.com.cn') !== false) {
            //老挝东盟制药厂
            $res = self::getLwdmzycResult($response, $companyInfo['element']);
            $response = $res['content'];
            $resultType = $res['resultType'];
        } else if (strpos($companyInfo['request_url'], 'phokam.com') !== false) {
            //老挝第二制药厂
            $res = self::getLwdezycResult($response);
            $response = $res['content'];
            $resultType = $res['resultType'];
            if (!$goodsName) {
                $goodsName = $res['goodsName'];
            }
        } else if (strpos($companyInfo['request_url'], 'generalpharma.com') !== false) {
            //孟加拉通用制药
            $res = self::getMjltyzyResult($response);
            $response = $res['content'];
            $resultType = $res['resultType'];
        } else {
            $response = '';
        }

        $time = time();

        $registerInfo = '';
        $dataSources = '';
        $queryTime = '';

        //如果查到信息记录本地
        if ($response) {
            $companySearch = new CompanySearch();
            $companySearch->uid = $uid;
            $companySearch->company_id = $companyId;
            $companySearch->code = $code;
            $companySearch->content = $response;
            $companySearch->result = $resultType;
            $companySearch->created = $time;
            $companySearch->save();

            $relateId = $companySearch->attributes['id'];
        }

        //获取药品信息
        if ($goodsName || $goodsId) {
            if ($goodsId) {
                $info = Goods::findGoodsDetail($goodsId);
            } else {
                $info = Goods::findGoodsInfo($goodsName, $companyId);
            }

            if ($info) {
                $registerInfo = $info['register_info'];
                $dataSources = $info['data_sources'];
                $queryTime = $info['query_time'];

                //保存查询记录
                if (isset($relateId)) {
                    $log = new QueryLog();
                    $log->uid = $uid;
                    $log->goods_name = $info['goods_name'] . ' ' . $info['en_name'];
                    $log->company_name = $companyInfo['company_name'];
                    $log->type = 2;
                    $log->relate_id = $relateId;
                    $log->created = $time;
                    $log->save();
                }

                $goodsSearchNumInfo = Goods::findGoodsDetail($info['id']);

                if ($goodsSearchNumInfo) {
                    $goodsSearchNumInfo->updateCounters(['search_num' => 1]);
                }
            }
        }

        //获取今天已经查询次数
        $todayNum = CompanySearch::findTodayNum();
        $todayNum = (int)$todayNum + 1;

        //获取总共查询次数
        $totalNum = CompanySearch::findTotalNum();
        $totalNum = (int)$totalNum * 15;

        return [
            'info'         => $response ? $response : '',
            'registerInfo' => $registerInfo,
            'dataSources'  => $dataSources,
            'queryTime'    => $queryTime,
            'rank'         => $todayNum,
            'total'        => $totalNum
        ];
    }

    /**
     * 处理孟加拉碧康制药结果
     * @param string $response 获取数据
     * @return array
     */
    public static function getMjlbkzyResult($response)
    {
        $arr = json_decode($response, true);

        $content = '';
        $resultType = 0;

        //孟加拉碧康制药的暂时这个样子
        if (isset($arr['status'])) {
            if ($arr['status'] == 1) {
                $content = '<p>恭喜！</p>
                <p>此驗證碼是有效防偽碼，感謝您選擇了碧康公司正品！</p>
                <p>碧康制藥股份有限公司是孟加拉國最大的抗腫瘤類藥物生產企業，也是孟加拉國發展最快的領先上市制藥公司之一。碧康公司始終關註產品品質，將嚴格的質量標準貫穿到整個生產環節，其優質產品是患者健康的可靠保障。</p>
                <p>感謝您使用碧康產品防偽驗證系統。</p>';
                $resultType = 1;
            } else {
                $content = '<p>This Code can not match with Beacon System. It is NOT valid. Please check for typing errors and then try again!</p>
                <p>B.N.: Don’t purchase without Verifying.</p>
                <p>此驗證碼與碧康公司產品防偽驗證系統不相匹配，屬無效防偽碼。請檢查是否存在輸入錯誤並再試一次！</p>
                <p>如無法驗證，請勿購買和使用，謹防假冒！</p>
                <p>Beacon is the No.1 oncology company and one of the leading and fastest growing public pharmaceuticals companies of Bangladesh and its high-quality products are the base for the patients health!</p>
                <p>Thank you for confirming with Beacon.</p>
                <p>碧康制藥股份有限公司是孟加拉國最大的抗腫瘤類藥物生產企業，也是孟加拉國發展最快的領先上市制藥公司之一。碧康公司始終關註產品品質，將嚴格的質量標準貫穿到整個生產環節，其優質產品是患者健康的可靠保障。</p>
                <p>感謝您使用碧康產品防偽驗證系統。</p>';
            }
            $content = str_replace(PHP_EOL, '', $content);
        }

        return ['content' => $content, 'resultType' => $resultType];
    }

    /**
     * 处理孟加拉耀品国际药厂结果
     * @param string $response 获取数据
     * @return array
     */
    public static function getMjlypgjycResult($response)
    {
        $content = '<p>安全检查信息</p><p>无法识别</p>';
        $resultType = 0;

        //判断是否包含该产品不是正品文案
        if (strpos($response, '该产品是正品') !== false) {
            $content = '<p>安全检查信息</p><p>该产品是正品</p>';
            $resultType = 1;
        } else if (strpos($response, '该产品不是正品') !== false) {
            $content = '<p>安全检查信息</p><p>该产品不是正品</p>';
            $resultType = 2;
        }

        return ['content' => $content, 'resultType' => $resultType];
    }

    /**
     * 处理孟加拉海湾制药结果
     * @param string $response 获取数据
     * @return array
     */
    public static function getMjlhwzyResult($response)
    {
        $arr = json_decode($response, true);

        $content = '';
        $resultType = 0;

        //判断返回json数据
        if (isset($arr['status'])) {
            if ($arr['status'] == 701) {
                $content = '<p>' . $arr['message'] . '</p>';
            }
        }

        return ['content' => $content, 'resultType' => $resultType];
    }

    /**
     * 处理老挝东盟制药厂结果
     * @param string $response 获取数据
     * @param string $element 标识元素
     * @return array
     */
    public static function getLwdmzycResult($response, $element)
    {
        $response = ltrim($response, 'jQuery110208796063734604216_1672880752224(');
        $response = rtrim($response, ')');
        $arr = json_decode($response, true);

        $content = '';
        $resultType = 0;

        //判断返回json数据
        if (isset($arr[$element])) {
            $content = '<p>' . $arr[$element] . '</p>';
        }

        return ['content' => $content, 'resultType' => $resultType];
    }

    /**
     * 处理老挝第二制药厂结果
     * @param string $response 获取数据
     * @return array
     */
    public static function getLwdezycResult($response)
    {
        $response = substr($response, 0, strrpos($response, '<script>'));
        $dom = new DOMDocument();
        $dom->loadHTML($response);
        $xpath = new DOMXPath($dom);

        $content = '';
        $resultType = 0;
        $goodsName = '';
        foreach ($xpath->evaluate('//div[@class="content "]/node()') as $key => $childNode) {
            $childElement = $dom->saveHtml($childNode);
            $content .= $childElement;

            if ($key == 2) {
                $arr = explode('<li>', $childElement);

                if (!empty($arr)) {
                    foreach ($arr as $n => $m) {
                        if (strpos($m, 'Product Name（产品名称）') !== false) {
                            $goodsName = trim(str_replace(['Product Name（产品名称）：<span>', '</span>', '</li>'], '', $m));
                        }
                    }
                }
            }
        }

        //判断是否为正品
        if (strpos($content, '该药品为正品') !== false) {
            $resultType = 1;
        }

        $content = '<div>' . $content . '</div>';

        $content = str_replace(PHP_EOL, '', preg_replace('@\n@', '', $content));

        return ['content' => $content, 'resultType' => $resultType, 'goodsName' => $goodsName];
    }

    /**
     * 处理孟加拉通用制药结果
     * @param string $response 获取数据
     * @return array
     */
    public static function getMjltyzyResult($response)
    {
        $response = strstr($response, '<div class="alert alert-primary d-flex align-items-center" role="alert">');
        $response = strstr($response, '</section>', true);
        $response = trim($response);
        $dom = new DOMDocument();
        $dom->loadHTML($response);
        $xpath = new DOMXPath($dom);

        $content = '';
        $resultType = 0;
        foreach ($xpath->evaluate('//div[@class="alert alert-primary d-flex align-items-center"]/node()') as $key => $childNode) {
            $childElement = $dom->saveHtml($childNode);
            $content .= $childElement;
        }

        $content = '<div>' . $content . '</div>';

        $content = str_replace(PHP_EOL, '', preg_replace('@\n@', '', $content));

        return ['content' => $content, 'resultType' => $resultType];
    }

    /**
     * 价格查询
     * @param int $uid 用户id
     * @param string $goodsName 药品名称
     * @param string $price 药品价格
     * @param int $companyId 药厂id
     * @param int $channelId 渠道id
     * @param string $specs 规格名称
     * @param int $goodsId 药品id
     * @return array
     * @throws ExitException
     */
    public static function getPriceSearchInfo($uid, $goodsName, $price, $companyId, $channelId, $specs, $goodsId)
    {
        //获取药厂信息
        $companyInfo = Company::findCompanyDetail($companyId);

        if (!$companyInfo) Helper::responseError(1013);

        $goodsNameArr = explode(' ', $goodsName);
        $goodsName = !empty($goodsNameArr) ? $goodsNameArr[0] : '';

        //获取药品信息
        if ($goodsId) {
            $info = Goods::findGoodsDetail($goodsId);
        } else {
            $info = Goods::findGoodsInfoBySpecs($goodsName, $companyId, $specs);
        }

        $time = time();

        $goodsInfo = [];
        if ($info) {
            //如果查到信息记录本地
            $priceSearch = new PriceSearch();
            $priceSearch->uid = $uid;
            $priceSearch->goods_name = $goodsName;
            $priceSearch->price = $price;
            $priceSearch->company_id = $companyId;
            $priceSearch->channel_id = $channelId;
            $priceSearch->goods_id = $info['id'];
            $priceSearch->created = $time;
            $priceSearch->save();

            $relateId = $priceSearch->attributes['id'];

            //保存查询记录
            $log = new QueryLog();
            $log->uid = $uid;
            $log->goods_name = $info['goods_name'] . ' ' . $info['en_name'];
            $log->company_name = $companyInfo['company_name'];
            $log->type = 3;
            $log->relate_id = $relateId;
            $log->created = $time;
            $log->save();

            $goodsSearchNumInfo = Goods::findGoodsDetail($info['id']);

            if ($goodsSearchNumInfo) {
                $goodsSearchNumInfo->updateCounters(['search_num' => 1]);
            }

            //统计渠道选择次数
            $channelInfo = Channel::findByChannelId($channelId);

            if ($channelInfo) {
                $channelInfo->updateCounters(['select_num' => 1]);
            }

            //价格比较
            if ($price < $info['min_price'] * 0.7) {
                $compareText = '偏低';
            } else {
                $compareText = '合理';

                //判断是否有最高价格
                if ($info['max_price'] > 0) {
                    if ($price > $info['max_price'] * 1.3) {
                        $compareText = '偏高';
                    }
                } else {
                    if ($price > $info['min_price'] * 1.3) {
                        $compareText = '偏高';
                    }
                }
            }

            //立即查询页面-优先跳高风险页面
            if ($info['risk'] == 1) {
                $linkUrl = '#/pages/result/smRisk?goodsId=' . $info['id'];
            } else {
                //优先跳国外有防伪
                if ($companyInfo['request_url']) {
                    $linkUrl = '#/pages/result/gwyfw?goodsId=' . $info['id'];
                } else {
                    //优先跳国外无防伪
                    if ($info['register_info']) {
                        $linkUrl = '#/pages/result/gwwfw?goodsId=' . $info['id'];
                    } else {
                        //国内有防伪
                        $linkUrl = '#/pages/result/gnyfw?companyId=' . $companyId;
                    }
                }
            }

            $goodsInfo = [
                'goodsId'        => $info['id'],
                'goodsName'      => $info['goods_name'],
                'enName'         => $info['en_name'],
                'commonName'     => $info['common_name'],
                'otherName'      => $info['other_name'],
                'goodsImage'     => $info['goods_image'],
                'bigImage'       => $info['big_image'] ? explode(',', $info['big_image']) : [],
                'companyName'    => $companyInfo['company_name'],
                'minPrice'       => $info['min_price'],
                'maxPrice'       => $info['max_price'],
                'minCostPrice'   => $info['min_cost_price'],
                'maxCostPrice'   => $info['max_cost_price'],
                'compareText'    => $compareText,
                'priceTrend'     => $info['price_trend'] ? json_decode($info['price_trend'], true) : [],
                'specs'          => $info['specs'],
                'number'         => $info['number'],
                'period'         => $info['period'],
                'usageDosage'    => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['usage_dosage']),
                'indication'     => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['indication']),
                'reaction'       => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['reaction']),
                'taboo'          => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['taboo']),
                'attention'      => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['attention']),
                'unit'           => $info['unit'],
                'composition'    => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['composition']),
                'character'      => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['character']),
                'storage'        => $info['storage'],
                'womanDosage'    => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['woman_dosage']),
                'childrenDosage' => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['children_dosage']),
                'elderlyDosage'  => str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), "<br>", $info['elderly_dosage']),
                'linkUrl'        => $linkUrl
            ];
        }

        //获取今天已经查询次数
        $todayNum = PriceSearch::findTodayNum();
        $todayNum = (int)$todayNum + 1;

        //获取总共查询次数
        $totalNum = PriceSearch::findTotalNum();
        $totalNum = (int)$totalNum * 15;

        return [
            'goodsInfo' => (object)$goodsInfo,
            'rank'      => $todayNum,
            'total'     => $totalNum
        ];
    }

    /**
     * 获取渠道列表
     * @return array
     */
    public static function getChannelList()
    {
        $channel = Channel::findAllChannel();

        $channelList = [];
        if ($channel) {
            foreach ($channel as $key => $value) {
                $channelList[] = [
                    'channelId'   => $value['id'],
                    'channelName' => $value['channel_name']
                ];
            }
        }

        return $channelList;
    }

    /**
     * 获取规格列表
     * @param string $goodsName 药品名称
     * @param int $companyId 药厂id
     * @return array
     */
    public static function getSpecList($goodsName, $companyId)
    {
        if (!$goodsName || !$companyId) return [];

        $goodsNameArr = explode(' ', $goodsName);
        $goodsName = !empty($goodsNameArr) ? $goodsNameArr[0] : '';

        $query = new Query();
        return $query->select(['distinct(goods.specs) as specs'])
            ->from('ky_goods as goods')
            ->innerJoin('ky_company as company', 'company.id = goods.company_id')
            ->where('(goods.goods_name like :goodsName or goods.en_name like :goodsName or goods.common_name like :goodsName or goods.other_name like :goodsName) and goods.company_id = :companyId and goods.enable = 0 and goods.is_delete = 0 and goods.min_price > 0')
            ->addParams([':goodsName' => '%' . $goodsName . '%', ':companyId' => $companyId])
            ->orderBy('goods.sort desc,goods.id desc')
            ->all();
    }

    /**
     * 获取药品名称列表
     * @param int $companyId 药厂id
     * @param int $page 页数
     * @return array
     */
    public static function getGoodsNameList($companyId, $page)
    {
        if (!$companyId) return [];

        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        $condition = 'goods.enable = 0 and goods.is_delete = 0';

        if ($companyId) {
            $condition .= " and goods.company_id = {$companyId}";
        }

        $query = new Query();
        return $query->select(['distinct(concat(goods.goods_name, " ", goods.en_name)) as goodsName'])
            ->from('ky_goods as goods')
            ->innerJoin('ky_company as company', 'company.id = goods.company_id')
            ->where($condition)
            ->orderBy('goods.sort desc,goods.id desc')
            ->offset($offset)
            ->limit($pageSize)
            ->all();
    }

    /**
     * 新版获取药品名称列表
     * @param string $keyword 搜索词
     * @param int $page 页数
     * @return array
     */
    public static function getRelateGoodsNameList($keyword, $page)
    {
        if (!is_string($keyword) || $keyword == 'undefined' || $keyword == 'object Object') return [];

        $goodsNameArr = explode(' ', $keyword);
        $keyword = !empty($goodsNameArr) ? $goodsNameArr[0] : '';

        //搜索条件
        $condition = 'enable = 0 and is_delete = 0 and min_price > 0 and (goods_name like :keyword or en_name like :keyword or common_name like :keyword or other_name like :keyword)';
        $params = [':keyword' => '%' . $keyword . '%'];

        $query = new Query();

        if ($page > 0) {
            //分页
            $pageSize = Yii::$app->params['pageSize'];
            $offset = ($page - 1) * $pageSize;

            return $query->select(['distinct(goods_name) as goodsName'])
                ->from('ky_goods')
                ->where($condition)
                ->addParams($params)
                ->orderBy('sort desc,id desc')
                ->offset($offset)
                ->limit($pageSize)
                ->all();
        } else {
            //全部
            return $query->select(['distinct(goods_name) as goodsName'])
                ->from('ky_goods')
                ->where($condition)
                ->addParams($params)
                ->orderBy('sort desc,id desc')
                ->all();
        }
    }

    /**
     * 获取图片识别结果
     * @param int $uid 用户id
     * @param string $imageUrl 图片url
     * @return array|bool
     * @throws ExitException
     */
    public static function getImageRecognitionInfo($uid, $imageUrl)
    {
        //ocr图片识别
        $result = Ocr::getOcrInfo($imageUrl);

        if (!$result) Helper::responseError(1053);

        $info = json_decode($result, true);

        $keywords = [];
        $words = [];

        $pattern = "/[^\x{4E00}-\x{9FFF}]+/u";
        $keyArr = [];
        $uniqueArr = [];

        if (isset($info['TextDetections']) && !empty($info['TextDetections'])) {
            foreach ($info['TextDetections'] as $key => $value) {
                $value['DetectedText'] = trim($value['DetectedText']);

                //判断中文
                if ($value['DetectedText']) {
                    $isZw = preg_replace($pattern, '', $value['DetectedText']);

                    if ($isZw === '' ) {
                        //不含中文，整个输出
                        if (!in_array($value['DetectedText'], $uniqueArr)) {
                            $words[] = [
                                'text' => $value['DetectedText']
                            ];
                            array_push($uniqueArr, $value['DetectedText']);
                        }
                    } else {
                        //含中文，一个一个输出
                        for ($i = 0; $i < mb_strlen($value['DetectedText']); $i++) {
                            if (!in_array(mb_substr($value['DetectedText'], $i, 1), $uniqueArr)) {
                                $words[] = [
                                    'text' => mb_substr($value['DetectedText'], $i, 1)
                                ];
                                array_push($uniqueArr, mb_substr($value['DetectedText'], $i, 1));
                            }
                        }
                    }

                    if (!in_array($value['DetectedText'], $keyArr)) {
                        $keywords[] = [
                            'name' => $value['DetectedText']
                        ];
                        array_push($keyArr, $value['DetectedText']);
                    }
                }
            }
        }

        //保存识别记录
        $image = new ImageRecognition();
        $image->uid = $uid;
        $image->image_url = $imageUrl;
        $image->keywords = json_encode($keywords);
        $image->words = json_encode($words);
        $image->created = time();

        if (!$image->save()) return false;

        $imageId = $image->attributes['id'];

        return ['imageId' => $imageId, 'imageUrl' => $imageUrl, 'keywords' => $keywords];
    }

    /**
     * 获取提取文字信息
     * @param int $imageId 图片id
     * @return array
     * @throws ExitException
     */
    public static function getExtractTextInfo($imageId)
    {
        //获取图片记录信息
        $imageInfo = ImageRecognition::findImageInfo($imageId);

        if (!$imageInfo) Helper::responseError(1050);

        $words = json_decode($imageInfo['words'], true);

        return ['words' => $words];
    }

    /**
     * 获取扫一扫结果
     * @param int $uid 用户id
     * @param string $code 条形码
     * @return array|bool
     */
    public static function getScanCodeInfo($uid, $code)
    {
        $result = 0;//结果，0-无结果，1-有结果
        $goodsId = 0;//药品id
        $goodsName = '';//药品名称
        $companyId = 0;//药厂id
        $companyName = '';//药厂名称
        $risk = 0;//风险：0-无风险，1-高风险
        $serverName = '';//跳转页面标题
        $linkUrl = '';//跳转链接

        if ($code) {
            $goodsInfo = Goods::findInfoByCode($code);

            if ($goodsInfo) {
                $result = 1;
                $goodsId = $goodsInfo['id'];
                $goodsName = $goodsInfo['goods_name'];

                //获取药厂信息
                $companyInfo = Company::findByCompanyId($goodsInfo['company_id']);
                $companyId = $goodsInfo['company_id'];
                $companyName = $companyInfo ? $companyInfo['company_name'] : '';

                $risk = $goodsInfo['risk'];
            } else {
                //获取第三方条形码数据
                $thirdInfo = BarCode::getGoodsInfo($code);
                $thirdInfo = json_decode($thirdInfo, true);

                // 成功
                if ($thirdInfo['showapi_res_code'] == 0
                    && isset($thirdInfo['showapi_res_body'])
                    && !empty($thirdInfo['showapi_res_body'])
                    && $thirdInfo['showapi_res_body']['ret_code'] == 0
                ) {
                    $result = 1;

                    //药厂查询
                    if ($thirdInfo['showapi_res_body']['manuName']) {
                        $companyInfo = Company::findByCompanyName($thirdInfo['showapi_res_body']['manuName']);

                        if (!$companyInfo) {
                            //创建药厂
                            $companyTemp = new Company();
                            $companyTemp->company_name = $thirdInfo['showapi_res_body']['manuName'];
                            $companyTemp->created = time();

                            if (!$companyTemp->save()) return false;

                            $companyId = $companyTemp->attributes['id'];
                            $companyName = $thirdInfo['showapi_res_body']['manuName'];

                            $companyInfo = Company::findByCompanyId($companyId);
                        } else {
                            $companyId = $companyInfo['id'];
                            $companyName = $companyInfo['company_name'];
                        }
                    }

                    //药品添加
                    $goodsTemp = new Goods();
                    $goodsTemp->goods_name = $thirdInfo['showapi_res_body']['name'];
                    $goodsTemp->specs = $thirdInfo['showapi_res_body']['spec'];
                    $goodsTemp->taboo = $thirdInfo['showapi_res_body']['taboo'];
                    $goodsTemp->interactions = $thirdInfo['showapi_res_body']['other'];
                    $goodsTemp->composition = $thirdInfo['showapi_res_body']['basis'];
                    $goodsTemp->attention = $thirdInfo['showapi_res_body']['consideration'];
                    $goodsTemp->company_id = $companyId;

                    //图片处理
                    if ($thirdInfo['showapi_res_body']['img']) {
                        $goodsImage = PluginService::changeNetImageLocal($thirdInfo['showapi_res_body']['img'], 'goods');
                        $goodsTemp->goods_image = $goodsImage;
                        $goodsTemp->big_image = $goodsImage;
                    }

                    $goodsTemp->number = $thirdInfo['showapi_res_body']['approval'];
                    $goodsTemp->usage_dosage = $thirdInfo['showapi_res_body']['dosage'];
                    $goodsTemp->goods_code = $thirdInfo['showapi_res_body']['code'];
                    $goodsTemp->ability = $thirdInfo['showapi_res_body']['purpose'];
                    $goodsTemp->character = $thirdInfo['showapi_res_body']['character'];
                    $goodsTemp->common_name = $thirdInfo['showapi_res_body']['trademark'];
                    $goodsTemp->period = $thirdInfo['showapi_res_body']['validity'];
                    $goodsTemp->storage = $thirdInfo['showapi_res_body']['storage'];
                    $goodsTemp->indication = $thirdInfo['showapi_res_body']['note'];
                    $goodsTemp->reaction = '';
                    $goodsTemp->woman_dosage = '';
                    $goodsTemp->children_dosage = '';
                    $goodsTemp->elderly_dosage = '';
                    $goodsTemp->pharmacokinetics = '';
                    $goodsTemp->toxicology = '';
                    $goodsTemp->clinical_trial = '';
                    $goodsTemp->drug_overdose = '';
                    $goodsTemp->register_info = '';
                    $goodsTemp->send_examine = '';
                    $goodsTemp->charitable_donation = '';
                    $goodsTemp->clinical_recruitment = '';
                    $goodsTemp->gene_check = '';
                    $goodsTemp->register_info = '<p>&nbsp; &nbsp; 该产品已在中国国家药品监督管理局（NMPA）<span style="color: #ff0000;"><strong>合法注册上市</strong></span>，可在正规渠道购买，在专业人士指导下或依说明书指导使用！</p><p>信息来源：<u><a href="https://www.nmpa.gov.cn/yaopin/index.html" target="_blank" rel="noopener">https://www.nmpa.gov.cn/yaopin/index.html</a></u></p><p><img src="https://shiyao.yaojk.com.cn/uploads/detail/20230426/5267e1fadf070aa201d5a95a850ed389.gif" /></p>';
                    $goodsTemp->created = time();

                    if (!$goodsTemp->save()) return false;

                    $goodsId = $goodsTemp->attributes['id'];
                    $goodsName = $thirdInfo['showapi_res_body']['name'];

                    $goodsInfo = Goods::findGoodsDetail($goodsId);
                }
            }
        }

        //优先跳高风险页面
        if ($risk == 1) {
            $serverName = '查询完成';
            $linkUrl = '#/pages/result/smRisk?goodsId=' . $goodsId;
        } else {
            //优先跳国外有防伪
            if (isset($companyInfo) && $companyInfo['request_url']) {
                $serverName = '查询完成';
                $linkUrl = '#/pages/result/gwyfw?goodsId=' . $goodsId;
            } else {
                //优先跳国外无防伪
                if (isset($goodsInfo) && $goodsInfo['register_info']) {
                    $serverName = '查询完成';
                    $linkUrl = '#/pages/result/gwwfw?goodsId=' . $goodsId;
                } else {
                    //国内有防伪
                    if ($companyId) {
                        $serverName = '查询完成';
                        $linkUrl = '#/pages/result/gnyfw?companyId=' . $companyId;
                    }
                }
            }
        }

        $time = time();

        //保存扫一扫记录
        $scan = new ScanLog();
        $scan->uid = $uid;
        $scan->code = $code;
        $scan->goods_id = $goodsId;
        $scan->goods_name = $goodsName;
        $scan->company_id = $companyId;
        $scan->company_name = $companyName;
        $scan->risk = $risk;
        $scan->server_name = $serverName;
        $scan->link_url = $linkUrl;
        $scan->created = $time;

        if (!$scan->save()) return false;

        $relateId = $scan->attributes['id'];

        if (isset($goodsInfo) && $goodsInfo && $goodsId) {
            //保存查询记录
            $log = new QueryLog();
            $log->uid = $uid;
            $log->goods_name = $goodsInfo['goods_name'] . ' ' . $goodsInfo['en_name'];
            $log->company_name = $companyName;
            $log->type = 5;
            $log->relate_id = $relateId;
            $log->created = $time;
            $log->save();
        }

        return [
            'result'      => $result,
            'goodsId'     => $goodsId,
            'goodsName'   => $goodsName,
            'companyId'   => $companyId,
            'companyName' => $companyName,
            'risk'        => $risk,
            'serverName'  => $serverName,
            'linkUrl'     => $linkUrl
        ];
    }

    /**
     * 获取条码识别结果
     * @param int $uid 用户id
     * @param string $imageUrl 图片url
     * @return array|bool
     * @throws ExitException
     */
    public static function getScanQRCodeInfo($uid, $imageUrl)
    {
        $applets = Yii::$app->params['applets'];
        $url = $applets['accessToken'] . '?grant_type=client_credential&appid=' . $applets['appid'] . '&secret=' . $applets['appsecret'];
        $result = Tool::sendRequest($url, [], 'GET');
        $result = json_decode($result, true);

        if (!empty($result) && isset($result['errcode']) && $result['errcode'] != 0) Helper::responseErrorMsg($result['errmsg']);

        $accessToken = $result['access_token'];

        $postUrl = $applets['scanQRCode'] . '?access_token=' . $accessToken;

        $data = ['img_url' => $imageUrl];

        $response = Tool::sendRequest($postUrl, $data, 'POST');

        $response = json_decode($response, true);

        if (!empty($response) && isset($response['errcode']) && $response['errcode'] != 0) Helper::responseErrorMsg($response['errmsg']);

        $code = isset($response['code_results']) && !empty($response['code_results']) && isset($response['code_results'][0]['data']) ? $response['code_results'][0]['data'] : '';

        return self::getScanCodeInfo($uid, $code);
    }

    /**
     * 获取药品服务信息
     * @param int $uid 用户id
     * @param int $goodsId 药品id
     * @return array
     * @throws ExitException
     */
    public static function getGoodsServerInfo($uid, $goodsId)
    {
        //获取药品信息
        $goodsInfo = Goods::findGoodsDetail($goodsId);

        if (!$goodsInfo) Helper::responseError(1035);

        //获取药厂信息
        $companyInfo = Company::findByCompanyId($goodsInfo['company_id']);
        $companyName = $companyInfo ? $companyInfo['company_name'] : '';

        if ($uid) {
            //保存查询记录
            $log = new QueryLog();
            $log->uid = $uid;
            $log->goods_name = $goodsInfo['goods_name'] . ' ' . $goodsInfo['en_name'];
            $log->company_name = $companyName;
            $log->type = 4;
            $log->relate_id = 0;
            $log->created = time();
            $log->save();
        }

        $marketPlaceList = Tool::getMarketPlace();

        $info = [
            'goodsId'             => $goodsInfo['id'],
            'goodsName'           => $goodsInfo['goods_name'] . ' ' . $goodsInfo['en_name'],
            'goodsImage'          => $goodsInfo['goods_image'],
            'clinicalStage'       => $goodsInfo['is_market'] == '1' ? $goodsInfo['clinical_stage'] : '',
            'drugProperties'      => $goodsInfo['drug_properties'],
            'drugPropertiesColor' => $goodsInfo['drug_properties'] == '原研药' ? '#0FC8AC' : '#459BF0',
            'companyId'           => $goodsInfo['company_id'],
            'companyName'         => $companyName,
            'specs'               => $goodsInfo['specs'],
            'marketTag'           => $goodsInfo['is_market'] == '1' && $goodsInfo['market_place'] && in_array($goodsInfo['market_place'], $marketPlaceList) ? $goodsInfo['market_place'] : '',
            'medicalTag'          => $goodsInfo['medical_type'] > 0 ? '医保' : '',
            'keyword'             => $goodsInfo['goods_name']
        ];

        //获取服务列表
        $goodsServer = GoodsServer::findAllGoodsServer();
        $serverList = [];

        if ($goodsServer) {
            foreach ($goodsServer as $key => $value) {
                //判断1.价格查询，3.我要比价是否显示
                if (($value['name'] == '价格查询' || $value['name'] == '我要比价') && $goodsInfo['min_price'] <= 0) continue;

                //判断4.患者招募是否显示
                if ($value['name'] == '患者招募' && !$goodsInfo['clinical_recruitment']) continue;

                //判断5.慈善救助是否显示
                if ($value['name'] == '慈善救助' && !$goodsInfo['charitable_donation']) continue;

                //判断7.基因检测是否显示
                if ($value['name'] == '基因检测' && !$goodsInfo['gene_check']) continue;

                //拼接路径参数
                if ($value['name'] != '真伪鉴别') {
                    $value['link_url'] = $value['link_url'] . '?goodsId=' . $goodsId . '&serverId=' . $value['id'];
                }

                //2.真伪鉴别路径判断
                if ($value['name'] == '真伪鉴别') {
                    //优先跳高风险页面
                    if ($goodsInfo['risk'] == 1) {
                        $value['link_url'] = '#/pages/result/smRisk?goodsId=' . $goodsId;
                    } else {
                        //优先跳国外有防伪
                        if (isset($companyInfo) && $companyInfo['request_url']) {
                            $value['link_url'] = '#/pages/result/gwyfw?goodsId=' . $goodsId;
                        } else {
                            //优先跳国外无防伪
                            if ($goodsInfo['register_info']) {
                                $value['link_url'] = '#/pages/result/gwwfw?goodsId=' . $goodsId . '&companyId=' . $goodsInfo['company_id'];
                            } else {
                                //国内有防伪
                                if ($goodsInfo['company_id']) {
                                    $value['link_url'] = '#/pages/result/gnyfw?companyId=' . $goodsInfo['company_id'];
                                }
                            }
                        }
                    }
                }

                $serverList[] = [
                    'serverId'   => $value['id'],
                    'serverName' => $value['name'],
                    'icon'       => $value['icon'],
                    'desc'       => $value['desc'],
                    'linkUrl'    => $value['link_url']
                ];
            }
        }

        //获取关联资讯列表
        $goodsName = Tool::filterGoodsName($goodsInfo['goods_name']);
        $articleList = Article::findByGoodsName($goodsName, $goodsInfo['en_name'], 0, 3);

        if ($articleList) {
            foreach ($articleList as $key => &$value) {
                //标签名称
                $value['label'] = $value['label'] ? explode(',', $value['label']) : [];

                //时间文案
                $value['created'] = Tool::getTimeText($value['created']);

                //判断用户有没有点赞
                $isLike = ArticleLike::findUserLike($value['articleId'], $uid);
                $value['isLike'] = $isLike ? 1 : 0;
            }
        }

        return [
            'goodsInfo'   => $info,
            'serverList'  => $serverList,
            'articleList' => $articleList
        ];
    }

    /**
     * 获取药品信息
     * @param int $goodsId 药品id
     * @return array
     * @throws ExitException
     */
    public static function getGoodsInfo($goodsId)
    {
        //获取药品信息
        $goodsInfo = Goods::findGoodsDetail($goodsId);

        if (!$goodsInfo) Helper::responseError(1035);

        //获取药厂信息
        $companyInfo = Company::findByCompanyId($goodsInfo['company_id']);
        $companyName = $companyInfo ? $companyInfo['company_name'] : '';

        $marketPlaceList = Tool::getMarketPlace();

        $info = [
            'goodsId'             => $goodsInfo['id'],
            'goodsName'           => $goodsInfo['goods_name'] . ' ' . $goodsInfo['en_name'],
            'goodsImage'          => $goodsInfo['goods_image'],
            'clinicalStage'       => $goodsInfo['is_market'] == '1' ? $goodsInfo['clinical_stage'] : '',
            'drugProperties'      => $goodsInfo['drug_properties'],
            'drugPropertiesColor' => $goodsInfo['drug_properties'] == '原研药' ? '#0FC8AC' : '#459BF0',
            'companyId'           => $goodsInfo['company_id'],
            'companyName'         => $companyName,
            'specs'               => $goodsInfo['specs'],
            'marketTag'           => $goodsInfo['is_market'] == '1' && $goodsInfo['market_place'] && in_array($goodsInfo['market_place'], $marketPlaceList) ? $goodsInfo['market_place'] : '',
            'medicalTag'          => $goodsInfo['medical_type'] > 0 ? '医保' : '',
            'keyword'             => $goodsInfo['goods_name']
        ];

        return ['goodsInfo' => $info];
    }

    /**
     * 获取药品风险信息
     * @param int $goodsId 药品id
     * @return array
     * @throws ExitException
     */
    public static function getGoodsRiskInfo($goodsId)
    {
        //获取药品信息
        $goodsInfo = Goods::findGoodsDetail($goodsId);

        if (!$goodsInfo) Helper::responseError(1035);

        $solution = Setting::findByKeyword('solution_text');

        return [
            'queryTime'    => $goodsInfo['query_time'],
            'dataSources'  => $goodsInfo['data_sources'],
            'solutionText' => $solution ? $solution['value'] : ''
        ];
    }

    /**
     * 获取药品专题说明
     * @param int $goodsId 药品id
     * @param int $serverId 服务id
     * @return array
     * @throws ExitException
     */
    public static function getGoodsSubjectInfo($goodsId, $serverId)
    {
        //获取药品信息
        $goodsInfo = Goods::findGoodsDetail($goodsId);

        if ($serverId != 6 && !$goodsInfo) Helper::responseError(1035);

        $dataSources = '';
        $queryTime = '';
        $copyText = '';
        $codeQuery = '';

        switch ($serverId) {
            case 2:
                $content = $goodsInfo['register_info'];
                $dataSources = $goodsInfo['data_sources'];
                $queryTime = $goodsInfo['query_time'];

                //判断文案
                if (strpos($goodsInfo['drug_properties'], '老挝') !== false) {
                    $copyText = "该药品已获得老挝人民民主共和国家(The Lao People's Democratic Republic) 药监局的注册批文 (FDD)，属于合法上市的药品!";
                } else if (strpos($goodsInfo['drug_properties'], '孟加拉') !== false) {
                    $copyText = "该药品已获得孟加拉人民共和国 (The People'sRepublic of Banaladesh) 药监局的注册批文DGDA) ，属于合法上市的药品!";
                }

                //获取药厂防伪码查询文案
                if ($goodsInfo['company_id']) {
                    $companyInfo = Company::findCompanyDetail($goodsInfo['company_id']);

                    if ($companyInfo) {
                        if ($companyInfo['request_url']) {
                            $codeQuery = '当前药品注册上市合法，是否立即查询真伪信息';
                        } else {
                            $codeQuery = $companyInfo['code_query'];
                        }
                    }
                }

                break;
            case 4:
                $content = $goodsInfo['clinical_recruitment'];
                break;
            case 5:
                $content = $goodsInfo['charitable_donation'];
                break;
            case 6:
                //获取我要送检文案
                $sendExamine = PluginService::getContent('sendExamine');
                $content = $sendExamine['content'];
                break;
            case 7:
                $content = $goodsInfo['gene_check'];
                break;
            default:
                $content = '';
                break;
        }

        return [
            'content'     => $content,
            'dataSources' => $dataSources,
            'queryTime'   => $queryTime,
            'copyText'    => $copyText,
            'codeQuery'   => $codeQuery
        ];
    }

    /**
     * 获取药品说明书信息
     * @param int $goodsId 药品id
     * @return array
     * @throws ExitException
     */
    public static function getGoodsInstructions($goodsId)
    {
        //获取药品信息
        $goodsInfo = Goods::findGoodsDetail($goodsId);

        if (!$goodsInfo) Helper::responseError(1035);

        //获取药厂信息
        $companyInfo = Company::findByCompanyId($goodsInfo['company_id']);
        $companyName = $companyInfo ? $companyInfo['company_name'] : '';

        $marketPlaceList = Tool::getMarketPlace();

        //药品类型
        switch ($goodsInfo['goods_type']) {
            case 1:
                $goodsTag = '处方';
                $goodsTagColor = '#FF0000';
                break;
            case 2:
                $goodsTag = 'OTC';
                $goodsTagColor = '#00FF00';
                break;
            case 3:
                $goodsTag = '医疗器械';
                $goodsTagColor = '#C0C0C0';
                break;
            default:
                $goodsTag = '';
                $goodsTagColor = '';
                break;
        }

        $info = [
            'goodsId'             => $goodsInfo['id'],
            'goodsName'           => $goodsInfo['goods_name'],
            'enName'              => $goodsInfo['en_name'],
            'commonName'          => $goodsInfo['common_name'],
            'otherName'           => $goodsInfo['other_name'],
            'bigImage'            => $goodsInfo['big_image'] ? explode(',', $goodsInfo['big_image']) : [],
            'goodsTag'            => $goodsTag,
            'goodsTagColor'       => $goodsTagColor,
            'clinicalStage'       => $goodsInfo['is_market'] == '1' ? $goodsInfo['clinical_stage'] : '',
            'drugProperties'      => $goodsInfo['drug_properties'],
            'drugPropertiesColor' => $goodsInfo['drug_properties'] == '原研药' ? '#0FC8AC' : '#459BF0',
            'companyId'           => $goodsInfo['company_id'],
            'companyName'         => $companyName,
            'marketTag'           => $goodsInfo['is_market'] == '1' && $goodsInfo['market_place'] && in_array($goodsInfo['market_place'], $marketPlaceList) ? $goodsInfo['market_place'] : '',
            'medicalTag'          => $goodsInfo['medical_type'] > 0 ? '医保' : ''
        ];

        //说明书目录
        $directory = [];

        //主要成份
        if ($goodsInfo['composition']) {
            $directory[] = [
                'keyword' => 'composition',
                'name'    => '主要成份',
                'content' => $goodsInfo['composition']
            ];
        }

        //性状
        if ($goodsInfo['character']) {
            $directory[] = [
                'keyword' => 'character',
                'name'    => '性状',
                'content' => $goodsInfo['character']
            ];
        }

        //规格
        if ($goodsInfo['specs']) {
            $directory[] = [
                'keyword' => 'specs',
                'name'    => '规格',
                'content' => $goodsInfo['specs']
            ];
        }

        //适应症
        if ($goodsInfo['indication']) {
            $directory[] = [
                'keyword' => 'indication',
                'name'    => '适应症',
                'content' => $goodsInfo['indication']
            ];
        }

        //用法用量
        if ($goodsInfo['usage_dosage']) {
            $directory[] = [
                'keyword' => 'usageDosage',
                'name'    => '用法用量',
                'content' => $goodsInfo['usage_dosage']
            ];
        }

        //不良反应
        if ($goodsInfo['reaction']) {
            $directory[] = [
                'keyword' => 'reaction',
                'name'    => '不良反应',
                'content' => $goodsInfo['reaction']
            ];
        }

        //禁忌
        if ($goodsInfo['taboo']) {
            $directory[] = [
                'keyword' => 'taboo',
                'name'    => '禁忌',
                'content' => $goodsInfo['taboo']
            ];
        }

        //注意事项
        if ($goodsInfo['attention']) {
            $directory[] = [
                'keyword' => 'attention',
                'name'    => '注意事项',
                'content' => $goodsInfo['attention']
            ];
        }

        //孕妇及哺乳期妇女用药
        if ($goodsInfo['woman_dosage']) {
            $directory[] = [
                'keyword' => 'womanDosage',
                'name'    => '孕妇及哺乳期妇女用药',
                'content' => $goodsInfo['woman_dosage']
            ];
        }

        //儿童用药
        if ($goodsInfo['children_dosage']) {
            $directory[] = [
                'keyword' => 'childrenDosage',
                'name'    => '儿童用药',
                'content' => $goodsInfo['children_dosage']
            ];
        }

        //老年患者用药
        if ($goodsInfo['elderly_dosage']) {
            $directory[] = [
                'keyword' => 'elderlyDosage',
                'name'    => '老年患者用药',
                'content' => $goodsInfo['elderly_dosage']
            ];
        }

        //药物相互作用
        if ($goodsInfo['interactions']) {
            $directory[] = [
                'keyword' => 'interactions',
                'name'    => '药物相互作用',
                'content' => $goodsInfo['interactions']
            ];
        }

        //药理毒理
        if ($goodsInfo['toxicology']) {
            $directory[] = [
                'keyword' => 'toxicology',
                'name'    => '药理毒理',
                'content' => $goodsInfo['toxicology']
            ];
        }

        //药代动力学
        if ($goodsInfo['pharmacokinetics']) {
            $directory[] = [
                'keyword' => 'pharmacokinetics',
                'name'    => '药代动力学',
                'content' => $goodsInfo['pharmacokinetics']
            ];
        }

        //药物过量
        if ($goodsInfo['drug_overdose']) {
            $directory[] = [
                'keyword' => 'drugOverdose',
                'name'    => '药物过量',
                'content' => $goodsInfo['drug_overdose']
            ];
        }

        //临床试验
        if ($goodsInfo['clinical_trial']) {
            $directory[] = [
                'keyword' => 'clinicalTrial',
                'name'    => '临床试验',
                'content' => $goodsInfo['clinical_trial']
            ];
        }

        //贮藏
        if ($goodsInfo['storage']) {
            $directory[] = [
                'keyword' => 'storage',
                'name'    => '贮藏',
                'content' => $goodsInfo['storage']
            ];
        }

        //包装单位
        if ($goodsInfo['unit']) {
            $directory[] = [
                'keyword' => 'unit',
                'name'    => '包装单位',
                'content' => $goodsInfo['unit']
            ];
        }

        //有效期
        if ($goodsInfo['period']) {
            $directory[] = [
                'keyword' => 'period',
                'name'    => '有效期',
                'content' => $goodsInfo['period']
            ];
        }

        //批准文号
        if ($goodsInfo['number']) {
            $directory[] = [
                'keyword' => 'number',
                'name'    => '批准文号',
                'content' => $goodsInfo['number']
            ];
        }

        //进口药品注册证号
        if ($goodsInfo['import_number']) {
            $directory[] = [
                'keyword' => 'importNumber',
                'name'    => '进口药品注册证号',
                'content' => $goodsInfo['import_number']
            ];
        }

        //药品上市许可持有人
        if ($goodsInfo['license_holder']) {
            $directory[] = [
                'keyword' => 'licenseHolder',
                'name'    => '药品上市许可持有人',
                'content' => $goodsInfo['license_holder']
            ];
        }

        //药品上市许可持有人地址
        if ($goodsInfo['license_address']) {
            $directory[] = [
                'keyword' => 'licenseAddress',
                'name'    => '药品上市许可持有人地址',
                'content' => $goodsInfo['license_address']
            ];
        }

        //进口分装企业
        if ($goodsInfo['import_company']) {
            $directory[] = [
                'keyword' => 'importCompany',
                'name'    => '进口分装企业',
                'content' => $goodsInfo['import_company']
            ];
        }

        return ['goodsInfo' => $info, 'directory' => $directory];
    }

    /**
     * 保存药品纠错类目
     * @param int $uid 用户id
     * @param int $goodsId 药品id
     * @param string $keywords 类目
     * @return bool
     * @throws ExitException
     */
    public static function saveGoodsErrorRecovery($uid, $goodsId, $keywords)
    {
        //获取药品信息
        $goodsInfo = Goods::findGoodsDetail($goodsId);

        if (!$goodsInfo) Helper::responseError(1035);

        $data = new GoodsErrorDirectory();
        $data->uid = $uid;
        $data->goods_id = $goodsId;
        $data->keywords = $keywords;
        $data->created = time();

        return $data->save();
    }

    /**
     * 获取热门药厂列表
     * @return array
     */
    public static function getHotCompanyList()
    {
        //获取国外仿制药热门厂家列表
        $hotCompany = Company::findAllHotCompany(1);
        $hotCompanyList = self::operateCompanyData($hotCompany);

        //获取其他热门药厂列表
        $otherCompany = Company::findAllHotCompany(2);
        $otherCompanyList = self::operateCompanyData($otherCompany);

        return ['hotCompanyList' => $hotCompanyList, 'otherCompanyList' => $otherCompanyList];
    }

    /**
     * 处理药厂数据
     * @param array $company 药厂列表
     * @return array
     */
    public static function operateCompanyData($company)
    {
        $companyList = [];

        if ($company) {
            foreach ($company as $key => $value) {
                $companyList[] = [
                    'companyId'    => $value['id'],
                    'companyName'  => $value['company_name'],
                    'companyImage' => $value['company_image']
                ];
            }
        }

        return $companyList;
    }

    /**
     * 获取全部分类列表
     */
    public static function getClassList()
    {
        //先获取全部一级分类
        $firstClass = GoodsClass::findAllClass();

        $classList = [];

        //加载全部
        $classList[] = [
            'classId'   => '0',
            'className' => '全部',
            'children'  => []
        ];

        if ($firstClass) {
            foreach ($firstClass as $key => $value) {
                $classList[] = [
                    'classId'   => $value['classId'],
                    'className' => $value['className'],
                    'children'  => GoodsClass::findAllClass($value['classId'])
                ];
            }
        }

        return $classList;
    }

    /**
     * 获取分类药品列表
     * @param int $classId 分类id
     * @param int $page 页数
     * @return array
     */
    public static function getClassGoodsList($classId, $page)
    {
        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        $marketPlaceList = Tool::getMarketPlace();

        //搜索条件
        $condition = 'goods.enable = 0 and goods.is_delete = 0 and company.enable = 0 and company.is_delete = 0';
        $params = [];

        if ($classId) {
            $condition .= ' and goods.class_id = :classId';
            $params = [':classId' => $classId];
        }

        //获取药品列表
        $query = new Query();
        $list = $query->select(['goods.id as goodsId',
            'concat(goods.goods_name, " ", goods.en_name) as goodsName',
            'goods.goods_image as goodsImage',
            'goods.is_market as isMarket',
            'goods.market_place as marketPlace',
            'goods.clinical_stage as clinicalStage',
            'goods.medical_type as medicalType',
            'goods.drug_properties as drugProperties',
            'if(goods.drug_properties = "原研药", "#0FC8AC", "#459BF0") as drugPropertiesColor',
            'goods.risk',
            'company.id as companyId',
            'company.company_name as companyName',
            'goods.search_num as searchNum'])
            ->from('ky_goods as goods')
            ->innerJoin('ky_company as company', 'company.id = goods.company_id')
            ->where($condition)
            ->addParams($params)
            ->orderBy([new Expression('goods.drug_properties != "原研药",goods.goods_image = "",goods.risk asc,goods.sort desc,goods.id desc')])
            ->offset($offset)
            ->limit($pageSize)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['marketTag'] = $value['isMarket'] == '1' && $value['marketPlace'] && in_array($value['marketPlace'], $marketPlaceList) ? $value['marketPlace'] : '';
                $value['clinicalStage'] = $value['isMarket'] == '1' ? $value['clinicalStage'] : '';
                $value['medicalTag'] = $value['medicalType'] > 0 ? '医保' : '';
                unset($value['isMarket']);
                unset($value['marketPlace']);
                unset($value['medicalType']);
            }
        }

        return $list;
    }

    /**
     * 获取比价结果
     * @param int $uid 用户id
     * @param int $goodsId 药品id
     * @param string $leftGoodsName 左边药品名称
     * @param int $leftCompanyId 左边药厂id
     * @param string $leftSpecs 左边规格名称
     * @param string $rightGoodsName 右边药品名称
     * @param int $rightCompanyId 右边药厂id
     * @param string $rightSpecs 右边规格名称
     * @return array
     * @throws ExitException
     */
    public static function getComparePriceInfo($uid, $goodsId, $leftGoodsName, $leftCompanyId, $leftSpecs, $rightGoodsName, $rightCompanyId, $rightSpecs)
    {
        //获取左边药厂信息
        $leftCompanyInfo = Company::findCompanyDetail($leftCompanyId);

        if (!$leftCompanyInfo) Helper::responseError(1013);

        //获取左边药品信息
        if ($goodsId) {
            $leftInfo = Goods::findGoodsDetail($goodsId);
        } else {
            $leftGoodsNameArr = explode(' ', $leftGoodsName);
            $leftGoodsName = !empty($leftGoodsNameArr) ? $leftGoodsNameArr[0] : '';
            $leftInfo = Goods::findGoodsInfoBySpecs($leftGoodsName, $leftCompanyId, $leftSpecs);
        }

        if (!$leftInfo) Helper::responseError(1035);

        //获取右边药厂信息
        $rightCompanyInfo = Company::findCompanyDetail($rightCompanyId);

        if (!$rightCompanyInfo) Helper::responseError(1013);

        $rightGoodsNameArr = explode(' ', $rightGoodsName);
        $rightGoodsName = !empty($rightGoodsNameArr) ? $rightGoodsNameArr[0] : '';

        //获取右边药品信息
        $rightInfo = Goods::findGoodsInfoBySpecs($rightGoodsName, $rightCompanyId, $rightSpecs);

        if (!$rightInfo) Helper::responseError(1035);

        $time = time();

        //保存比价记录
        $compare = new ComparePrice();
        $compare->uid = $uid;
        $compare->left_goods_name = $leftGoodsName;
        $compare->left_company_id = $leftCompanyId;
        $compare->left_specs = $leftSpecs;
        $compare->left_goods_id = $leftInfo['id'];
        $compare->right_goods_name = $rightGoodsName;
        $compare->right_company_id = $rightCompanyId;
        $compare->right_specs = $rightSpecs;
        $compare->right_goods_id = $rightInfo['id'];
        $compare->created = $time;
        $compare->save();

        $relateId = $compare->attributes['id'];

        //保存查询记录
        $log = new QueryLog();
        $log->uid = $uid;
        $log->goods_name = $leftInfo['goods_name'] . ' ' . $leftInfo['en_name'];
        $log->company_name = $leftCompanyInfo['company_name'];
        $log->type = 6;
        $log->relate_id = $relateId;
        $log->created = $time;
        $log->save();

        //获取比价文案
        $compareTextInfo = PluginService::getContent('comparePrice');

        $marketPlaceList = Tool::getMarketPlace();

        //左边所在地区文案
        $leftMarketPlace = $leftInfo['drug_properties'] == '原研药' && $leftInfo['is_market'] == '1' ? str_replace(['无', '上市'], '', $leftInfo['market_place']) : str_replace(['原研药', '仿制药'], '', $leftInfo['drug_properties']);
        $leftMarketPlace = $leftMarketPlace == '国产' ? '中国' : $leftMarketPlace;

        //右边所在地区文案
        $rightMarketPlace = $rightInfo['drug_properties'] == '原研药' && $rightInfo['is_market'] == '1' ? str_replace(['无', '上市'], '', $rightInfo['market_place']) : str_replace(['原研药', '仿制药'], '', $rightInfo['drug_properties']);
        $rightMarketPlace = $rightMarketPlace == '国产' ? '中国' : $rightMarketPlace;

        return [
            'leftGoodsInfo' => [
                'goodsId'             => $leftInfo['id'],
                'goodsName'           => $leftInfo['goods_name'] . ' ' . $leftInfo['en_name'],
                'goodsImage'          => $leftInfo['goods_image'],
                'clinicalStage'       => $leftInfo['is_market'] == '1' ? $leftInfo['clinical_stage'] : '',
                'drugProperties'      => $leftInfo['drug_properties'],
                'drugPropertiesColor' => $leftInfo['drug_properties'] == '原研药' ? '#0FC8AC' : '#459BF0',
                'risk'                => $leftInfo['risk'],
                'companyId'           => $leftCompanyInfo['id'],
                'companyName'         => $leftCompanyInfo['company_name'],
                'marketTag'           => $leftInfo['is_market'] == '1' && $leftInfo['market_place'] && in_array($leftInfo['market_place'], $marketPlaceList) ? $leftInfo['market_place'] : '',
                'medicalTag'          => $leftInfo['medical_type'] > 0 ? '医保' : '',
                'moneyText'           => $leftInfo['money_type'] == 1 ? '$' : '¥',
                'minPrice'            => $leftInfo['min_price'],
                'maxPrice'            => $leftInfo['max_price'],
                'marketPlace'         => $leftMarketPlace
            ],
            'rightGoodsInfo' => [
                'goodsId'             => $rightInfo['id'],
                'goodsName'           => $rightInfo['goods_name'] . ' ' . $rightInfo['en_name'],
                'goodsImage'          => $rightInfo['goods_image'],
                'clinicalStage'       => $rightInfo['is_market'] == '1' ? $rightInfo['clinical_stage'] : '',
                'drugProperties'      => $rightInfo['drug_properties'],
                'drugPropertiesColor' => $rightInfo['drug_properties'] == '原研药' ? '#0FC8AC' : '#459BF0',
                'risk'                => $rightInfo['risk'],
                'companyId'           => $rightCompanyInfo['id'],
                'companyName'         => $rightCompanyInfo['company_name'],
                'marketTag'           => $rightInfo['is_market'] == '1' && $rightInfo['market_place'] && in_array($rightInfo['market_place'], $marketPlaceList) ? $rightInfo['market_place'] : '',
                'medicalTag'          => $rightInfo['medical_type'] > 0 ? '医保' : '',
                'moneyText'           => $rightInfo['money_type'] == 1 ? '$' : '¥',
                'minPrice'            => $rightInfo['min_price'],
                'maxPrice'            => $rightInfo['max_price'],
                'marketPlace'         => $rightMarketPlace
            ],
            'compareText' => $compareTextInfo['content']
        ];
    }
}
