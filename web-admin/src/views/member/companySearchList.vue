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
      <el-form-item label="药厂" prop="companyName">
        <el-select v-model="form.companyName" filterable remote reserve-keyword clearable placeholder="请输入关键词搜索药厂" :remote-method="getAllCompany" :loading="companyLoading">
          <el-option v-for="item in companyList" :key="item.companyId" :label="item.companyName" :value="item.companyName" />
        </el-select>
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
      <el-table-column property="searchId" align="center" label="id" width="80" />

      <el-table-column property="username" align="center" label="用户名" />

      <el-table-column property="mobile" align="center" label="手机号" />

      <el-table-column property="companyName" align="center" label="药厂名称" />

      <el-table-column property="code" align="center" label="防伪码" />

      <el-table-column property="content" align="center" label="查询内容" />

      <el-table-column align="center" label="查询结果">
        <template slot-scope="scope">
          <span>{{ scope.row.result | getQueryResultType }}</span>
        </template>
      </el-table-column>

      <el-table-column property="created" align="center" label="查询时间" />
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />
  </div>
</template>

<script>
import { queryResultType, getVal } from '@/utils/sys'
import { companySearchList } from '@/api/member'
import { allCompany } from '@/api/resource'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  filters: {
    getQueryResultType(index) {
      return getVal(index, queryResultType())
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
      companyList: [],
      form: {
        username: '',
        mobile: '',
        companyName: '',
        beginDate: '',
        endDate: ''
      },
      list: [],
      total: 0,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      },
      companyLoading: false
    }
  },
  created() {
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
      companySearchList(this.listQuery).then(response => {
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
