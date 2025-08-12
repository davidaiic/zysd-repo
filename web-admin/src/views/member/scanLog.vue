<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="用户名" prop="username">
        <el-input v-model="form.username" placeholder="请输入用户名" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="手机号" prop="mobile">
        <el-input v-model="form.mobile" placeholder="请输入手机号" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="条形码" prop="code">
        <el-input v-model="form.code" placeholder="请输入条形码" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="药品名称" prop="goodsName">
        <el-input v-model="form.goodsName" placeholder="请输入药品名称" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="查询时间" prop="beginDate">
        <el-date-picker v-model="form.beginDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item prop="endDate">
        <el-date-picker v-model="form.endDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item>
        <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
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
      <el-table-column property="scanId" align="center" label="id" width="80" />

      <el-table-column property="username" align="center" label="用户名" />

      <el-table-column property="mobile" align="center" label="手机号" />

      <el-table-column property="code" align="center" label="条形码" />

      <el-table-column align="center" label="药品信息">
        <template slot-scope="scope">
          <div v-if="scope.row.goodsId > 0">药品id：{{ scope.row.goodsId }}</div>
          <div v-if="scope.row.goodsName">药品名称：{{ scope.row.goodsName }}</div>
        </template>
      </el-table-column>

      <el-table-column align="center" label="药厂信息">
        <template slot-scope="scope">
          <div v-if="scope.row.companyId > 0">药厂id：{{ scope.row.companyId }}</div>
          <div v-if="scope.row.companyName">药厂名称：{{ scope.row.companyName }}</div>
        </template>
      </el-table-column>

      <el-table-column align="center" label="是否风险">
        <template slot-scope="scope">
          <span>{{ scope.row.risk | statusFilter }}</span>
        </template>
      </el-table-column>

      <el-table-column property="serverName" align="center" label="跳转页面标题" />

      <el-table-column property="linkUrl" align="center" label="跳转链接" />

      <el-table-column property="created" align="center" label="查询时间" />
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />
  </div>
</template>

<script>
import { status, getVal } from '@/utils/sys'
import { scanLog } from '@/api/member'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  filters: {
    statusFilter(index) {
      return getVal(index, status())
    }
  },
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
      form: {
        username: '',
        mobile: '',
        code: '',
        goodsName: '',
        beginDate: '',
        endDate: ''
      },
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
      scanLog(this.listQuery).then(response => {
        this.list = response.data.list
        this.total = parseInt(response.data.total)
        this.listLoading = false
      })
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
