<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="药品中文名" prop="goodsName">
        <el-input v-model="form.goodsName" placeholder="请输入药品中文名" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="药品英文名" prop="enName">
        <el-input v-model="form.enName" placeholder="请输入药品英文名" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="规格" prop="specs">
        <el-input v-model="form.specs" placeholder="请输入规格" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="药厂" prop="companyName">
        <el-select v-model="form.companyName" filterable remote reserve-keyword clearable placeholder="请输入关键词搜索药厂" :remote-method="getAllCompany" :loading="companyLoading">
          <el-option v-for="item in companyList" :key="item.companyId" :label="item.companyName" :value="item.companyName" />
        </el-select>
      </el-form-item>
      <el-form-item label="分类" prop="classList">
        <el-cascader
          ref="classSelectClose"
          v-model="form.classList"
          :options="classList"
          :props="{ checkStrictly: true }"
          clearable
          filterable
          @change="handleSelectChangeClass"
        />
      </el-form-item>
      <el-form-item label="批准文号" prop="number">
        <el-input v-model="form.number" placeholder="请输入批准文号" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="状态" prop="enable">
        <el-select v-model="form.enable" placeholder="全部">
          <el-option v-for="item in typeList" :key="item.key" :label="item.val" :value="item.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="是否热门" prop="isHot">
        <el-select v-model="form.isHot" placeholder="全部">
          <el-option v-for="item in statusList" :key="item.key" :label="item.val" :value="item.key" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
        <el-button type="primary" icon="el-icon-document" @click="exportData">{{ $t('table.exportExcel') }}</el-button>
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd('1')">{{ $t('table.add') }}</el-button>
        <el-button type="danger" @click="syncRecruit">{{ $t('table.syncRecruit') }}</el-button>
      </el-form-item>
    </el-form>

    <el-table
      ref="multipleTable"
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      style="width: 100%"
    >
      <el-table-column property="goodsId" align="center" label="id" width="80" />

      <el-table-column align="center" label="药品名称">
        <template slot-scope="scope">
          <div>{{ scope.row.goodsName }}</div>
          <div>规格：{{ scope.row.specs }}</div>
          <div v-if="scope.row.number">批准文号：{{ scope.row.number }}</div>
        </template>
      </el-table-column>

      <el-table-column align="center" label="药品图片" width="200">
        <template slot-scope="scope">
          <span><img :src="scope.row.goodsImage" width="160" height="120"></span>
        </template>
      </el-table-column>

      <el-table-column property="companyName" align="center" label="药厂名称" />

      <el-table-column property="searchNum" align="center" label="查询次数" />

      <el-table-column align="center" label="药品信息" width="240">
        <template slot-scope="scope">
          <div>药品最低价格：{{ (scope.row.moneyType === '1' ? '$' : '￥') + scope.row.minPrice }}</div>
          <div>药品最高价格：{{ (scope.row.moneyType === '1' ? '$' : '￥') + scope.row.maxPrice }}</div>
          <div>药品月花费最低价格：{{ (scope.row.moneyType === '1' ? '$' : '￥') + scope.row.minCostPrice }}</div>
          <div>药品月花费最高价格：{{ (scope.row.moneyType === '1' ? '$' : '￥') + scope.row.maxCostPrice }}</div>
        </template>
      </el-table-column>

      <el-table-column align="center" label="价格趋势" width="140">
        <template slot-scope="scope">
          <el-button type="primary" plain round size="mini" @click="priceClick(scope.row)">{{ $t('table.viewPriceTrend') }}</el-button>
        </template>
      </el-table-column>

      <el-table-column property="sort" align="center" label="排序" />

      <el-table-column align="center" label="状态">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.enable" active-value="0" inactive-value="1" @change="handleChange(scope.row.goodsId,scope.row.enable,4)" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="是否热门">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.isHot" active-value="1" inactive-value="0" @change="handleChange(scope.row.goodsId,scope.row.isHot,5)" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="操作" width="160">
        <template slot-scope="scope">
          <el-button plain round size="mini" @click="handleAdd('2',scope.row)">{{ $t('table.edit') }}</el-button>
          <el-button type="danger" plain round size="mini" @click="handleDel(scope.row.goodsId)">{{ $t('table.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="180px">
          <el-form-item style="display:none" label="id" prop="goodsId">
            <el-input v-model="filter.goodsId" />
          </el-form-item>
          <el-form-item label="药品中文名" prop="goodsName">
            <el-input v-model="filter.goodsName" />
          </el-form-item>
          <el-form-item label="药品英文名" prop="enName">
            <el-input v-model="filter.enName" />
          </el-form-item>
          <el-form-item label="商品名" prop="commonName">
            <el-input v-model="filter.commonName" />
          </el-form-item>
          <el-form-item label="别名" prop="otherName">
            <el-input v-model="filter.otherName" />
          </el-form-item>
          <el-form-item label="商品大图" prop="bigImage">
            <el-upload
              class="upload-demo"
              :action="uploadUrl"
              :data="{ type: 'goods' }"
              :show-file-list="false"
              :on-success="handleSuccessPicture"
              :on-error="handleError"
            >
              <el-button size="small" type="primary">点击上传</el-button>
              <span class="image-size">图片尺寸：4:3</span>
            </el-upload>
            <ul v-if="filter.bigImage.length > 0" class="el-upload-list el-upload-list--picture-card">
              <li v-for="(item, index) in filter.bigImage" :key="index" tabindex="0" class="el-upload-list__item is-success">
                <img :src="item" alt="" class="el-upload-list__item-thumbnail">
                <label class="el-upload-list__item-status-label">
                  <i class="el-icon-upload-success el-icon-check" />
                </label>
                <span class="el-upload-list__item-actions">
                  <span class="el-upload-list__item-preview" @click="handlePreviewPicture(index)">
                    <i class="el-icon-zoom-in" />
                  </span>
                  <span class="el-upload-list__item-delete" @click="handleDownloadPicture(index)">
                    <i class="el-icon-download" />
                  </span>
                  <span class="el-upload-list__item-delete" @click="handleRemovePicture(index)">
                    <i class="el-icon-delete" />
                  </span>
                </span>
              </li>
            </ul>
            <el-dialog :visible.sync="dialogVisibleImage" :modal="false" :fullscreen="true" :append-to-body="true">
              <img width="100%" :src="dialogImageUrl" alt="">
            </el-dialog>
          </el-form-item>
          <el-form-item label="选择分类" prop="classList">
            <el-cascader
              v-if="isShow"
              ref="classClose"
              v-model="filter.classList"
              :options="classList"
              :props="{ checkStrictly: true }"
              clearable
              filterable
              style="width: 100%"
              @change="handleChangeClass"
            />
          </el-form-item>
          <el-form-item label="选择药厂" prop="companyIndex">
            <el-select
              v-model="filter.companyIndex"
              filterable
              remote
              reserve-keyword
              clearable
              placeholder="请输入关键词搜索药厂"
              :remote-method="getAllCompany"
              :loading="companyLoading"
              style="width: 100%"
              @change="setCompanyInfo"
            >
              <el-option v-for="(item, index) in companyList" :key="item.companyId" :label="item.companyName" :value="index" />
            </el-select>
          </el-form-item>
          <el-form-item label="药厂信息" prop="companyId">
            <span>{{ filter.companyName }}(ID：{{ filter.companyId }})</span>
          </el-form-item>
          <el-form-item label="规格" prop="specs">
            <el-input v-model.trim="filter.specs" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="syncInfoClick">{{ $t('table.syncInformation') }}</el-button>
          </el-form-item>
          <el-form-item label="货币类型" prop="moneyType">
            <el-radio-group v-model="filter.moneyType">
              <el-radio v-for="(item, index) in moneyTypeList" :key="index" :label="item.key">{{ item.val }}</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="药品最低价格" prop="minPrice">
            <el-input v-model.trim="filter.minPrice">
              <template slot="prepend">{{ filter.moneyType === '1' ? '$' : '￥' }}</template>
            </el-input>
          </el-form-item>
          <el-form-item label="药品最高价格" prop="maxPrice">
            <el-input v-model.trim="filter.maxPrice">
              <template slot="prepend">{{ filter.moneyType === '1' ? '$' : '￥' }}</template>
            </el-input>
          </el-form-item>
          <el-form-item label="药品月花费最低价格" prop="minCostPrice">
            <el-input v-model.trim="filter.minCostPrice">
              <template slot="prepend">{{ filter.moneyType === '1' ? '$' : '￥' }}</template>
            </el-input>
          </el-form-item>
          <el-form-item label="药品月花费最高价格" prop="maxCostPrice">
            <el-input v-model.trim="filter.maxCostPrice">
              <template slot="prepend">{{ filter.moneyType === '1' ? '$' : '￥' }}</template>
            </el-input>
          </el-form-item>
          <el-form-item label="药品类型" prop="goodsType">
            <el-radio-group v-model="filter.goodsType">
              <el-radio v-for="(item, index) in goodsTypeList" :key="index" :label="item.key">{{ item.val }}</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="主要成份" prop="composition">
            <el-input v-model="filter.composition" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="性状" prop="character">
            <el-input v-model="filter.character" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="适应症" prop="indication">
            <el-input v-model="filter.indication" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="用法用量" prop="usageDosage">
            <el-input v-model="filter.usageDosage" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="不良反应" prop="reaction">
            <el-input v-model="filter.reaction" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="禁忌" prop="taboo">
            <el-input v-model="filter.taboo" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="注意事项" prop="attention">
            <el-input v-model="filter.attention" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="儿童用药" prop="childrenDosage">
            <el-input v-model="filter.childrenDosage" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="孕妇及哺乳期妇女用药" prop="womanDosage">
            <el-input v-model="filter.womanDosage" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="老年人用药" prop="elderlyDosage">
            <el-input v-model="filter.elderlyDosage" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="包装单位" prop="unit">
            <el-input v-model="filter.unit" />
          </el-form-item>
          <el-form-item label="贮藏" prop="storage">
            <el-input v-model="filter.storage" />
          </el-form-item>
          <el-form-item label="有效期" prop="period">
            <el-input v-model.trim="filter.period" />
          </el-form-item>
          <el-form-item label="批准文号" prop="number">
            <el-input v-model.trim="filter.number" />
          </el-form-item>
          <el-form-item label="条形码" prop="goodsCode">
            <el-input v-model.trim="filter.goodsCode" />
          </el-form-item>
          <el-form-item label="NDC" prop="ndc">
            <el-input v-model="filter.ndc" />
          </el-form-item>
          <el-form-item label="药品查询注册信息" prop="registerInfo">
            <Tinymce ref="editor" v-model="filter.registerInfo" :height="300" />
          </el-form-item>
          <el-form-item label="数据来源" prop="dataSources">
            <el-input v-model="filter.dataSources" />
          </el-form-item>
          <el-form-item label="查询时间" prop="queryTime">
            <el-date-picker
              v-model="filter.queryTime"
              type="datetime"
              format="yyyy-MM-dd HH:mm"
              value-format="yyyy-MM-dd HH:mm"
              placeholder="选择查询时间"
              style="width: 100%"
            />
          </el-form-item>
          <el-form-item label="药物相互作用" prop="interactions">
            <el-input v-model="filter.interactions" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="药代动力学" prop="pharmacokinetics">
            <el-input v-model="filter.pharmacokinetics" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="药理毒理" prop="toxicology">
            <el-input v-model="filter.toxicology" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="临床试验" prop="clinicalTrial">
            <el-input v-model="filter.clinicalTrial" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="药物过量" prop="drugOverdose">
            <el-input v-model="filter.drugOverdose" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="进口药品注册证号" prop="importNumber">
            <el-input v-model="filter.importNumber" />
          </el-form-item>
          <el-form-item label="药品上市许可持有人" prop="licenseHolder">
            <el-input v-model="filter.licenseHolder" />
          </el-form-item>
          <el-form-item label="药品上市许可持有人地址" prop="licenseAddress">
            <el-input v-model="filter.licenseAddress" />
          </el-form-item>
          <el-form-item label="进口分装企业" prop="importCompany">
            <el-input v-model="filter.importCompany" />
          </el-form-item>
          <el-form-item label="医保类型" prop="medicalType">
            <el-select v-model="filter.medicalType" placeholder="请选择医保类型" style="width: 100%">
              <el-option v-for="(item, index) in medicalList" :key="index" :label="item.val" :value="item.key" />
            </el-select>
          </el-form-item>
          <el-form-item v-if="filter.medicalType === '2'" label="（乙类）目前医保报销范围" prop="submitScope">
            <el-radio-group v-model="filter.submitScope">
              <el-radio label="0">无</el-radio>
              <el-radio label="1">报销仅限基因靶点</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="filter.medicalType === '2' && filter.submitScope === '1'" label="（乙类）基因靶点" prop="geneScope">
            <el-checkbox-group v-model="filter.geneScope">
              <el-checkbox v-for="(item, index) in geneTargetList" :key="index" :label="item.val">{{ item.val }}</el-checkbox>
            </el-checkbox-group>
          </el-form-item>
          <el-form-item v-if="filter.medicalType > 0" label="医保执行时间" prop="medicalDate">
            <el-date-picker
              v-model="filter.medicalDate"
              type="month"
              format="yyyy-MM"
              value-format="yyyy-MM"
              placeholder="选择医保执行时间"
              style="width: 100%"
            />
          </el-form-item>
          <el-form-item label="基因靶点" prop="geneTarget">
            <el-checkbox-group v-model="filter.geneTarget">
              <el-checkbox v-for="(item, index) in geneTargetList" :key="index" :label="item.val">{{ item.val }}</el-checkbox>
            </el-checkbox-group>
          </el-form-item>
          <el-form-item label="我要送检" prop="sendExamine">
            <Tinymce ref="editor1" v-model="filter.sendExamine" :height="300" />
          </el-form-item>
          <el-form-item label="慈善赠药" prop="charitableDonation">
            <Tinymce ref="editor2" v-model="filter.charitableDonation" :height="300" />
          </el-form-item>
          <el-form-item label="患者临床招募（免费用药）" prop="clinicalRecruitment">
            <Tinymce ref="editor3" v-model="filter.clinicalRecruitment" :height="300" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="recruitClick">{{ $t('table.synchronous') }}</el-button>
          </el-form-item>
          <el-form-item label="基因检测" prop="geneCheck">
            <Tinymce ref="editor4" v-model="filter.geneCheck" :height="300" />
          </el-form-item>
          <el-form-item label="是否已上市" prop="isMarket">
            <el-radio-group v-model="filter.isMarket">
              <el-radio label="0">否</el-radio>
              <el-radio label="1">是</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="filter.isMarket === '1'" label="上市区域" prop="marketPlace">
            <el-radio-group v-model="filter.marketPlace">
              <el-radio v-for="(item, index) in marketPlaceList" :key="index" :label="item.val">{{ item.val }}</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="filter.isMarket === '1' && filter.marketPlace && filter.marketPlace !== '中国大陆上市'" label="国内临床阶段" prop="clinicalStage">
            <el-radio-group v-model="filter.clinicalStage">
              <el-radio v-for="(item, index) in clinicalStageList" :key="index" :label="item.val">{{ item.val }}</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="filter.isMarket === '1'" label="上市时间" prop="marketDate">
            <el-date-picker
              v-model="filter.marketDate"
              type="month"
              format="yyyy-MM"
              value-format="yyyy-MM"
              placeholder="选择上市时间"
              style="width: 100%"
            />
          </el-form-item>
          <el-form-item label="药品属性" prop="drugProperties">
            <el-radio-group v-model="filter.drugProperties">
              <el-radio v-for="(item, index) in drugPropertiesList" :key="index" :label="item.val" class="mg-top10">{{ item.val }}</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="药品风险等级" prop="risk">
            <el-radio-group v-model="filter.risk">
              <el-radio label="0">无</el-radio>
              <el-radio label="1">高风险</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input v-model.trim="filter.sort" />
          </el-form-item>
          <el-form-item label="状态" prop="enable">
            <el-switch v-model="filter.enable" active-value="0" inactive-value="1" />
          </el-form-item>
          <el-form-item label="是否热门" prop="isHot">
            <el-switch v-model="filter.isHot" active-value="1" inactive-value="0" />
          </el-form-item>
        </el-form>

        <div slot="footer" class="dialog-footer text-center">
          <el-button @click="dialogVisible = false">
            {{ $t('table.cancel') }}
          </el-button>
          <el-button type="primary" @click="handleCommit">
            {{ $t('table.confirm') }}
          </el-button>
        </div>
      </div>
    </el-dialog>

    <el-dialog title="价格趋势" :visible.sync="priceDialogVisible">
      <div>
        <div class="display-date">
          <div v-for="(item, index) in priceFilter.priceTrendList" :key="index" class="item-box">
            <div class="item-date">
              {{ item.date }}
            </div>
            <div class="item-value">
              <el-input v-model.trim="item.value" @change="showLineChart" />
            </div>
          </div>
        </div>
        <div class="mg-top20">
          <line-chart :chart-data="lineChartData" />
        </div>

        <div slot="footer" class="dialog-footer text-center">
          <el-button @click="priceDialogVisible = false">
            {{ $t('table.cancel') }}
          </el-button>
          <el-button type="primary" @click="creatChartClick">
            {{ $t('table.saveChartData') }}
          </el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { enableType, status, medicalType, geneTarget, drugProperties, marketPlace, clinicalStage, moneyType, goodsType, getVal } from '@/utils/sys'
import { goodsList, dealGoods, allCompany, instructions, recruit, syncRecruit, classList } from '@/api/resource'
import Pagination from '@/components/Pagination'
import LineChart from './components/LineChart'
import Tinymce from '@/components/Tinymce'

export default {
  components: { Pagination, LineChart, Tinymce },
  data() {
    return {
      typeList: enableType(),
      statusList: status(),
      medicalList: medicalType(),
      geneTargetList: geneTarget(),
      drugPropertiesList: drugProperties(),
      marketPlaceList: marketPlace(),
      clinicalStageList: clinicalStage(),
      moneyTypeList: moneyType(),
      goodsTypeList: goodsType(),
      companyList: [],
      isAdd: true,
      uploadUrl: '',
      form: {
        goodsName: '',
        enName: '',
        specs: '',
        companyName: '',
        classList: [],
        number: '',
        enable: '',
        isHot: ''
      },
      filter: {
        goodsId: '',
        goodsName: '',
        enName: '',
        commonName: '',
        otherName: '',
        goodsImage: '',
        bigImage: [],
        classId: '',
        classList: [],
        companyId: '',
        companyName: '',
        companyIndex: '',
        moneyType: '0',
        minPrice: '',
        maxPrice: '',
        minCostPrice: '',
        maxCostPrice: '',
        specs: '',
        fullName: '',
        goodsType: '',
        number: '',
        period: '',
        goodsCode: '',
        ndc: '',
        ability: '',
        usageDosage: '',
        indication: '',
        reaction: '',
        taboo: '',
        attention: '',
        unit: '',
        composition: '',
        character: '',
        storage: '',
        standard: '',
        eligibility: '',
        womanDosage: '',
        childrenDosage: '',
        elderlyDosage: '',
        registerInfo: '',
        dataSources: '',
        queryTime: '',
        interactions: '',
        pharmacokinetics: '',
        toxicology: '',
        clinicalTrial: '',
        drugOverdose: '',
        importNumber: '',
        licenseHolder: '',
        licenseAddress: '',
        importCompany: '',
        medicalType: '0',
        submitScope: '0',
        geneScope: [],
        medicalDate: '',
        geneTarget: [],
        sendExamine: '',
        charitableDonation: '',
        clinicalRecruitment: '',
        geneCheck: '',
        isMarket: '0',
        marketPlace: '',
        clinicalStage: '',
        marketDate: '',
        drugProperties: '',
        risk: '0',
        sort: '',
        enable: '0',
        isHot: '0'
      },
      filterRules: {
        goodsName: [{ required: true, message: '请输入药品名称', trigger: 'blur' }],
        bigImage: [{ required: true, message: '请上传图片', trigger: 'blur' }],
        companyId: [{ required: true, message: '请选择药厂', trigger: 'blur' }],
        specs: [{ required: true, message: '请输入规格', trigger: 'blur' }]
      },
      priceFilter: {
        goodsId: '',
        priceTrendList: []
      },
      downloadLoading: true,
      filename: '药品管理',
      excelList: [],
      list: [],
      total: 0,
      dialogVisible: false,
      priceDialogVisible: false,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      },
      lineChartData: {
        dateList: [],
        priceList: []
      },
      dialogVisibleImage: false,
      dialogImageUrl: '',
      companyLoading: false,
      isShow: false,
      classList: []
    }
  },
  computed: {
    title() {
      return this.isAdd === true ? this.$t('table.add') : this.$t('table.edit')
    }
  },
  created() {
    this.uploadUrl = process.env.VUE_APP_UPLOAD_URL
    this.getClassList()
    this.getList()
  },
  methods: {
    // 获取所有药厂
    getAllCompany(query) {
      if (query !== '') {
        this.companyLoading = true
        allCompany({ search: query }).then(response => {
          this.companyList = response.data.list
          this.companyLoading = false
        })
      } else {
        this.companyList = []
      }
    },
    // 设置药厂信息
    setCompanyInfo() {
      this.filter.companyId = this.companyList[this.filter.companyIndex].companyId
      this.filter.companyName = this.companyList[this.filter.companyIndex].companyName
    },
    // 同步说明书
    syncInfoClick() {
      if (!this.filter.enName) {
        this.$message.error('请先输入药品英文名')
        return false
      }
      instructions({ enName: this.filter.enName, specs: this.filter.specs }).then(response => {
        this.$message.success(this.$t('msg.success'))
        if (response.data.isExist === 1) {
          this.filter.goodsName = response.data.info.goods_name
          this.filter.otherName = response.data.info.other_name
          this.filter.goodsType = response.data.info.goods_type
          this.filter.composition = response.data.info.composition
          this.filter.indication = response.data.info.indication
          this.filter.usageDosage = response.data.info.usage_dosage
          this.filter.reaction = response.data.info.reaction
          this.filter.taboo = response.data.info.taboo
          this.filter.attention = response.data.info.attention
          this.filter.childrenDosage = response.data.info.children_dosage
          this.filter.womanDosage = response.data.info.woman_dosage
          this.filter.elderlyDosage = response.data.info.elderly_dosage
          this.filter.storage = response.data.info.storage
          this.filter.interactions = response.data.info.interactions
          this.filter.pharmacokinetics = response.data.info.pharmacokinetics
          this.filter.toxicology = response.data.info.toxicology
          this.filter.clinicalTrial = response.data.info.clinical_trial
          this.filter.drugOverdose = response.data.info.drug_overdose
          this.filter.geneTarget = response.data.info.gene_target ? response.data.info.gene_target.split(',') : []
          this.filter.isMarket = response.data.info.is_market
        }
      })
    },
    // 同步临床招募
    recruitClick() {
      if (!this.filter.classList.length) {
        this.$message.error('请先选择分类')
        return false
      }
      const classId = this.filter.classList[this.filter.classList.length - 1]
      recruit({ classId: classId }).then(response => {
        this.$message.success(this.$t('msg.success'))
        if (response.data.isExist === 1) {
          this.filter.clinicalRecruitment = response.data.clinicalRecruitment
          this.$refs.editor3.setContent(this.filter.clinicalRecruitment)
        }
      })
    },
    // 自动同步保存临床招募
    syncRecruit() {
      if (!this.form.classList.length) {
        this.$message.error('请先选择分类')
        return false
      }
      const classId = this.form.classList[this.form.classList.length - 1]
      this.$confirm(this.$t('table.confirmSyncRecruit'), this.$t('table.tip'), {
        confirmButtonText: this.$t('table.confirm'),
        cancelButtonText: this.$t('table.cancel'),
        type: 'warning'
      }).then(() => {
        syncRecruit({ classId: classId }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    handleAdd(type, row) {
      this.dialogVisible = true
      this.isShow = false

      this.$nextTick(() => {
        this.companyList = []
        if (type === '1') {
          this.isAdd = true
          this.resetForm('filter')
          this.filter.classList = []
          this.$refs.editor.setContent('')
          this.$refs.editor1.setContent('')
          this.$refs.editor2.setContent('')
          this.$refs.editor3.setContent('')
          this.$refs.editor4.setContent('')
        } else {
          this.isAdd = false
          this.filter.goodsId = row.goodsId
          this.filter.goodsName = row.goodsName
          this.filter.enName = row.enName
          this.filter.commonName = row.commonName
          this.filter.otherName = row.otherName
          this.filter.goodsImage = row.goodsImage
          this.filter.bigImage = row.bigImage !== '' ? row.bigImage.split(',') : []
          this.filter.classId = row.classId
          this.filter.classList = row.classList
          this.filter.companyId = row.companyId
          this.filter.companyName = row.companyName
          this.filter.companyIndex = ''
          this.filter.moneyType = row.moneyType
          this.filter.minPrice = row.minPrice
          this.filter.maxPrice = row.maxPrice
          this.filter.minCostPrice = row.minCostPrice
          this.filter.maxCostPrice = row.maxCostPrice
          this.filter.specs = row.specs
          this.filter.fullName = row.fullName
          this.filter.goodsType = row.goodsType
          this.filter.number = row.number
          this.filter.period = row.period
          this.filter.goodsCode = row.goodsCode
          this.filter.ndc = row.ndc
          this.filter.ability = row.ability
          this.filter.usageDosage = row.usageDosage
          this.filter.indication = row.indication
          this.filter.reaction = row.reaction
          this.filter.taboo = row.taboo
          this.filter.attention = row.attention
          this.filter.unit = row.unit
          this.filter.composition = row.composition
          this.filter.character = row.character
          this.filter.storage = row.storage
          this.filter.standard = row.standard
          this.filter.eligibility = row.eligibility
          this.filter.registerInfo = row.registerInfo
          this.filter.dataSources = row.dataSources
          this.filter.queryTime = row.queryTime
          this.filter.womanDosage = row.womanDosage
          this.filter.childrenDosage = row.childrenDosage
          this.filter.elderlyDosage = row.elderlyDosage
          this.filter.interactions = row.interactions
          this.filter.pharmacokinetics = row.pharmacokinetics
          this.filter.toxicology = row.toxicology
          this.filter.clinicalTrial = row.clinicalTrial
          this.filter.drugOverdose = row.drugOverdose
          this.filter.importNumber = row.importNumber
          this.filter.licenseHolder = row.licenseHolder
          this.filter.licenseAddress = row.licenseAddress
          this.filter.importCompany = row.importCompany
          this.filter.medicalType = row.medicalType
          this.filter.submitScope = row.submitScope
          this.filter.geneScope = row.geneScope
          this.filter.medicalDate = row.medicalDate
          this.filter.geneTarget = row.geneTarget
          this.filter.sendExamine = row.sendExamine
          this.filter.charitableDonation = row.charitableDonation
          this.filter.clinicalRecruitment = row.clinicalRecruitment
          this.filter.geneCheck = row.geneCheck
          this.filter.isMarket = row.isMarket
          this.filter.marketPlace = row.marketPlace
          this.filter.clinicalStage = row.clinicalStage
          this.filter.marketDate = row.marketDate
          this.filter.drugProperties = row.drugProperties
          this.filter.risk = row.risk
          this.filter.sort = row.sort
          this.filter.enable = row.enable
          this.filter.isHot = row.isHot
          this.$refs.editor.setContent(this.filter.registerInfo)
          this.$refs.editor1.setContent(this.filter.sendExamine)
          this.$refs.editor2.setContent(this.filter.charitableDonation)
          this.$refs.editor3.setContent(this.filter.clinicalRecruitment)
          this.$refs.editor4.setContent(this.filter.geneCheck)
        }
        this.isShow = true
      })
    },
    // 分类列表
    getClassList() {
      classList({ type: 1, currentId: 0 }).then(response => {
        this.classList = response.data.list
      })
    },
    // 切换分类
    handleChangeClass() {
      this.$refs.classClose._self.dropDownVisible = false
    },
    // 切换分类
    handleSelectChangeClass() {
      this.$refs.classSelectClose._self.dropDownVisible = false
    },
    // 提交
    handleCommit() {
      if (!this.filter.goodsName) {
        this.$message.error('请输入药品名称')
        return false
      }
      if (!this.filter.bigImage.length) {
        this.$message.error('请上传图片')
        return false
      }
      if (!this.filter.companyId) {
        this.$message.error('请选择药厂')
        return false
      }
      if (!this.filter.specs) {
        this.$message.error('请输入规格')
        return false
      }
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const operateType = this.isAdd === true ? '1' : '2'
        dealGoods({ operateType, ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
      })
    },
    // 大图上传
    handleSuccessPicture(response) {
      if (response.code === 200) {
        this.filter.bigImage.push(response.data.url)
      } else {
        this.$message.error(response.msg)
      }
    },
    // 大图删除
    handleRemovePicture(index) {
      this.filter.bigImage.splice(index, 1)
    },
    // 大图预览
    handlePreviewPicture(index) {
      this.dialogImageUrl = this.filter.bigImage[index]
      this.dialogVisibleImage = true
    },
    // 大图下载
    handleDownloadPicture(index) {
      window.open(this.filter.bigImage[index])
    },
    // 删除
    handleDel(goodsId) {
      this.$confirm(this.$t('table.confirmDelete'), this.$t('table.tip'), {
        confirmButtonText: this.$t('table.confirm'),
        cancelButtonText: this.$t('table.cancel'),
        type: 'warning'
      }).then(() => {
        dealGoods({ goodsId, operateType: '3' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    // 改变状态
    handleChange(goodsId, val, type) {
      if (type === 4) {
        const enable = val
        dealGoods({ goodsId, enable, operateType: '4' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      } else {
        const isHot = val
        dealGoods({ goodsId, isHot, operateType: '5' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }
    },
    // 价格趋势
    priceClick(row) {
      this.priceDialogVisible = true

      this.$nextTick(() => {
        this.priceFilter.goodsId = row.goodsId
        this.priceFilter.priceTrendList = row.priceTrendList
        this.lineChartData.dateList = row.priceTrend.dateList
        this.lineChartData.priceList = row.priceTrend.priceList
      })
    },
    // 图表变化
    showLineChart() {
      const arr = []
      this.priceFilter.priceTrendList.forEach(item => {
        arr.push(item.value ? item.value : 0)
      })
      this.lineChartData.priceList = arr
    },
    // 保存数据
    creatChartClick() {
      if (this.priceFilter.priceTrendList.length > 0) {
        for (let i = 0; i < this.priceFilter.priceTrendList.length; i++) {
          if (!this.priceFilter.priceTrendList[i].value) {
            this.$message.error(this.$t('msg.checkDataError'))
            return false
          }
        }
      }
      dealGoods({ goodsId: this.priceFilter.goodsId, priceTrend: JSON.stringify(this.lineChartData), operateType: '6' }).then(response => {
        this.$message.success(this.$t('msg.success'))
        this.getList()
      })
      this.priceDialogVisible = false
    },
    // 重置
    resetForm(form) {
      this.$refs[form].resetFields()
    },
    handleSearch() {
      this.listQuery.page = 1
      this.getList()
    },
    // 搜索
    getList() {
      this.listLoading = true
      this.listQuery = Object.assign(this.listQuery, this.form)
      goodsList(this.listQuery).then(response => {
        this.list = response.data.list
        this.excelList = response.data.excelList
        this.total = parseInt(response.data.total)
        this.listLoading = false
      })
    },
    // 导出excel
    exportData() {
      this.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader = ['id', '药品名称', '药厂名称', '查询次数', '药品最低价格', '药品最高价格', '药品月花费最低价格', '药品月花费最高价格', '规格', '状态', '是否热门']
        const filterVal = ['goodsId', 'goodsName', 'companyName', 'searchNum', 'minPrice', 'maxPrice', 'minCostPrice', 'maxCostPrice', 'specs', 'enable', 'isHot']
        const excelList = this.excelList
        const data = this.formatJson(filterVal, excelList)
        excel.export_json_to_excel({
          header: tHeader,
          data,
          filename: this.filename,
          autoWidth: true,
          bookType: 'xlsx'
        })
      })
      this.downloadLoading = false
    },
    formatJson(filterVal, jsonData) {
      return jsonData.map(v => filterVal.map(j => {
        if (j === 'enable') {
          return getVal(v[j], enableType())
        } else if (j === 'isHot') {
          return getVal(v[j], status())
        } else {
          return v[j]
        }
      }))
    },
    handleSuccess(response) {
      if (response.code === 200) {
        this.filter.goodsImage = response.data.url
      } else {
        this.$message.error(response.msg)
      }
    },
    handleError() {
      this.$message.error(this.$t('page.netWorkError'))
    }
  }
}
</script>

<style lang="scss" scoped>
  $label-with: 120px;
  .app-container{
    & >>> .el-dialog >>> .el-form-item__label{
      width: $label-with
    }
  }

  .display-date {
    display: flex;
    align-items: center;
    justify-content: center;

    .item-box {
      text-align: center;
      border: solid 1px #dfe6ec;
      border-right: none;

      .item-date {
        line-height: 38px;
        border-bottom: solid 1px #dfe6ec;
      }

      .item-value {
        margin: 20px;
      }
    }

    .item-box:last-child {
      border-right: solid 1px #dfe6ec;
    }
  }

  .mg-top10 {
    margin-top: 10px;
  }

  .mg-top20 {
    margin-top: 20px;
  }

  .upload-demo {
    margin-bottom: 20px;
  }

  .image-size {
    color: #ff0000;
    margin-left: 20px;
  }
</style>

<style>
  .goods-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .goods-uploader .el-upload:hover {
    border-color: #409EFF;
  }

  .goods-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 165px;
    height: 100px;
    line-height: 100px;
    text-align: center;
  }

  .goods {
    width: 165px;
    height: 100px;
    display: block;
  }

  .red {
    color: #ff0000;
  }
</style>
