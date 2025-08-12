<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <div>
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" @keyup.enter.native="handleSearch" />
        </el-form-item>
        <el-form-item label="手机号" prop="mobile">
          <el-input v-model="form.mobile" placeholder="请输入手机号" @keyup.enter.native="handleSearch" />
        </el-form-item>
        <el-form-item label="药品名称" prop="goodsName">
          <el-input v-model="form.goodsName" placeholder="请输入药品名称" @keyup.enter.native="handleSearch" />
        </el-form-item>
        <el-form-item label="查询结果" prop="searchResult">
          <el-select v-model="form.searchResult" placeholder="全部">
            <el-option v-for="item in priceTypeList" :key="item.key" :label="item.val" :value="item.key" />
          </el-select>
        </el-form-item>
      </div>
      <div>
        <el-form-item label="查询时间" prop="beginDate">
          <el-date-picker v-model="form.beginDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
        </el-form-item>
        <el-form-item prop="endDate">
          <el-date-picker v-model="form.endDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
        </el-form-item>
        <el-form-item>
          <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
          <el-button type="primary" icon="el-icon-document" @click="exportData">{{ $t('table.exportExcel') }}</el-button>
        </el-form-item>
      </div>
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
      <el-table-column property="searchId" align="center" label="id" width="80" />

      <el-table-column property="username" align="center" label="用户名" />

      <el-table-column property="mobile" align="center" label="手机号" />

      <el-table-column property="goodsName" align="center" label="药品名称" />

      <el-table-column property="price" align="center" label="药品价格" />

      <el-table-column property="companyName" align="center" label="药厂名称" />

      <el-table-column property="channelName" align="center" label="渠道名称" />

      <el-table-column property="goodsId" align="center" label="查询到的药品id" />

      <el-table-column property="searchGoodsName" align="center" label="查询到的药品名称" />

      <el-table-column property="searchResult" align="center" label="查询结果" />

      <el-table-column property="created" align="center" label="查询时间" />
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />
  </div>
</template>

<script>
import { priceType } from '@/utils/sys'
import { priceSearchList } from '@/api/member'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  data() {
    return {
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > Date.now()
        },
        shortcuts: [{
          text: '今天',
          onClick(picker) {
            picker.$emit('pick', new Date())
          }
        }, {
          text: '昨天',
          onClick(picker) {
            const date = new Date()
            date.setTime(date.getTime() - 3600 * 1000 * 24)
            picker.$emit('pick', date)
          }
        }, {
          text: '一周前',
          onClick(picker) {
            const date = new Date()
            date.setTime(date.getTime() - 3600 * 1000 * 24 * 7)
            picker.$emit('pick', date)
          }
        }]
      },
      priceTypeList: priceType(),
      form: {
        username: '',
        mobile: '',
        goodsName: '',
        searchResult: '',
        beginDate: '',
        endDate: ''
      },
      downloadLoading: true,
      filename: '价格查询',
      excelList: [],
      list: [],
      total: 0,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
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
      priceSearchList(this.listQuery).then(response => {
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
        const tHeader = ['id', '用户名', '手机号', '药品名称', '药品价格', '药厂名称', '渠道名称', '查询到的药品id', '查询到的药品名称', '查询结果', '查询时间']
        const filterVal = ['searchId', 'username', 'mobile', 'goodsName', 'price', 'companyName', 'channelName', 'goodsId', 'searchGoodsName', 'searchResult', 'created']
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
        return v[j]
      }))
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
</style>
