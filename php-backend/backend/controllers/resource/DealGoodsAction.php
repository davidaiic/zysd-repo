<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 药品操作
 */
class DealGoodsAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $goodsName = Helper::getParam('goodsName');
        $enName = Helper::getParam('enName');
        $commonName = Helper::getParam('commonName');
        $otherName = Helper::getParam('otherName');
        $goodsImage = Helper::getParam('goodsImage');
        $bigImage = Helper::getParam('bigImage');
        $classList = Helper::getParam('classList');
        $companyId = Helper::getParam('companyId');
        $moneyType = (int)Helper::getParam('moneyType');
        $minPrice = Helper::getParam('minPrice');
        $maxPrice = Helper::getParam('maxPrice');
        $minCostPrice = Helper::getParam('minCostPrice');
        $maxCostPrice = Helper::getParam('maxCostPrice');
        $specs = Helper::getParam('specs');
        $fullName = Helper::getParam('fullName');
        $goodsType = (int)Helper::getParam('goodsType');
        $number = Helper::getParam('number');
        $period = Helper::getParam('period');
        $goodsCode = Helper::getParam('goodsCode');
        $ndc = Helper::getParam('ndc');
        $ability = Helper::getParam('ability');
        $usageDosage = Helper::getParam('usageDosage');
        $indication = Helper::getParam('indication');
        $reaction = Helper::getParam('reaction');
        $taboo = Helper::getParam('taboo');
        $attention = Helper::getParam('attention');
        $unit = Helper::getParam('unit');
        $composition = Helper::getParam('composition');
        $character = Helper::getParam('character');
        $storage = Helper::getParam('storage');
        $standard = Helper::getParam('standard');
        $eligibility = Helper::getParam('eligibility');
        $womanDosage = Helper::getParam('womanDosage');
        $childrenDosage = Helper::getParam('childrenDosage');
        $elderlyDosage = Helper::getParam('elderlyDosage');
        $registerInfo = Helper::getParam('registerInfo');
        $dataSources = Helper::getParam('dataSources');
        $queryTime = Helper::getParam('queryTime');
        $interactions = Helper::getParam('interactions');
        $pharmacokinetics = Helper::getParam('pharmacokinetics');
        $toxicology = Helper::getParam('toxicology');
        $clinicalTrial = Helper::getParam('clinicalTrial');
        $drugOverdose = Helper::getParam('drugOverdose');
        $importNumber = Helper::getParam('importNumber');
        $licenseHolder = Helper::getParam('licenseHolder');
        $licenseAddress = Helper::getParam('licenseAddress');
        $importCompany = Helper::getParam('importCompany');
        $medicalType = (int)Helper::getParam('medicalType');
        $submitScope = (int)Helper::getParam('submitScope');
        $geneScope = Helper::getParam('geneScope');
        $medicalDate = Helper::getParam('medicalDate');
        $geneTarget = Helper::getParam('geneTarget');
        $sendExamine = Helper::getParam('sendExamine');
        $charitableDonation = Helper::getParam('charitableDonation');
        $clinicalRecruitment = Helper::getParam('clinicalRecruitment');
        $geneCheck = Helper::getParam('geneCheck');
        $isMarket = Helper::getParam('isMarket');
        $marketPlace = Helper::getParam('marketPlace');
        $clinicalStage = Helper::getParam('clinicalStage');
        $marketDate = Helper::getParam('marketDate');
        $drugProperties = Helper::getParam('drugProperties');
        $risk = (int)Helper::getParam('risk');
        $sort = (int)Helper::getParam('sort');
        $enable = (int)Helper::getParam('enable');
        $isHot = (int)Helper::getParam('isHot');
        $priceTrend = Helper::getParam('priceTrend');
        $operateType = (int)Helper::getParam('operateType');
        $goodsId = (int)Helper::getParam('goodsId');

        $minPrice = $minPrice ? $minPrice : '0.00';
        $maxPrice = $maxPrice ? $maxPrice : '0.00';
        $minCostPrice = $minCostPrice ? $minCostPrice : '0.00';
        $maxCostPrice = $maxCostPrice ? $maxCostPrice : '0.00';

        if (($operateType != 1 && !$goodsId) || ($operateType != 3 && $operateType != 4 && $operateType != 5 && $operateType != 6 && (!$goodsName || empty($bigImage) || !$companyId || !$specs))) {
            Helper::response(201);
        }

        $result = ResourceService::dealWithGoods(
            $goodsName,
            $enName,
            $commonName,
            $otherName,
            $goodsImage,
            $bigImage,
            $classList,
            $companyId,
            $moneyType,
            $minPrice,
            $maxPrice,
            $minCostPrice,
            $maxCostPrice,
            $specs,
            $fullName,
            $goodsType,
            $number,
            $period,
            $goodsCode,
            $ndc,
            $ability,
            $usageDosage,
            $indication,
            $reaction,
            $taboo,
            $attention,
            $unit,
            $composition,
            $character,
            $storage,
            $standard,
            $eligibility,
            $womanDosage,
            $childrenDosage,
            $elderlyDosage,
            $registerInfo,
            $dataSources,
            $queryTime,
            $interactions,
            $pharmacokinetics,
            $toxicology,
            $clinicalTrial,
            $drugOverdose,
            $importNumber,
            $licenseHolder,
            $licenseAddress,
            $importCompany,
            $medicalType,
            $submitScope,
            $geneScope,
            $medicalDate,
            $geneTarget,
            $sendExamine,
            $charitableDonation,
            $clinicalRecruitment,
            $geneCheck,
            $isMarket,
            $marketPlace,
            $clinicalStage,
            $marketDate,
            $drugProperties,
            $risk,
            $sort,
            $enable,
            $isHot,
            $priceTrend,
            $operateType,
            $goodsId
        );

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
