<template>
  <el-dialog
    title="登录日志"
    :visible.sync="dialogVisible"
    :close-on-click-modal="false"
    :close-on-press-escape="false"
    width="60%"
    @close="closeDialogVisible"
  >
    <div class="app-container">
      <el-button type="primary" icon="el-icon-document" @click="exportData">{{ $t('table.exportExcel') }}</el-button>

      <el-table
        ref="multipleTable"
        :data="list"
        border
        fit
        highlight-current-row
        style="width: 100%; margin-top: 20px"
      >
        <el-table-column property="id" align="center" label="id" width="80" />

        <el-table-column property="ip" align="center" label="ip" />

        <el-table-column property="port" align="center" label="端口号" />

        <el-table-column property="city" align="center" label="城市" />

        <el-table-column property="created" align="center" label="登录时间" />
      </el-table>

      <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />
    </div>
  </el-dialog>
</template>

<script>
import { loginList } from '@/api/member'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  props: {
    isShow: {
      type: Boolean
    },
    userId: {
      type: String,
      default: '0'
    }
  },
  data() {
    return {
      downloadLoading: true,
      filename: '用户登录日志',
      excelList: [],
      list: [],
      total: 0,
      dialogVisible: false,
      listQuery: {
        page: 1,
        limit: 10
      }
    }
  },
  created() {
    this.dialogVisible = this.isShow
    this.getList()
  },
  methods: {
    // 搜索
    getList() {
      this.listQuery = Object.assign(this.listQuery, { uid: this.userId })
      loginList(this.listQuery).then(response => {
        this.list = response.data.list
        this.excelList = response.data.excelList
        this.total = parseInt(response.data.total)
      })
    },
    // 关闭
    closeDialogVisible() {
      this.$emit('closeShowDialog')
    },
    // 导出excel
    exportData() {
      this.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader = ['id', 'ip', '端口号', '城市', '登录时间']
        const filterVal = ['id', 'ip', 'port', 'city', 'created']
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
