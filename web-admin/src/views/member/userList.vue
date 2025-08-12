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
      <el-form-item label="注册时间" prop="beginDate">
        <el-date-picker v-model="form.beginDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" placeholder="开始时间" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item prop="endDate">
        <el-date-picker v-model="form.endDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" placeholder="结束时间" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item>
        <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
        <el-button type="primary" icon="el-icon-document" @click="exportData">{{ $t('table.exportExcel') }}</el-button>
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
      <el-table-column property="uid" align="center" label="id" width="80" />

      <el-table-column property="username" align="center" label="用户名" />

      <el-table-column property="mobile" align="center" label="手机号" />

      <el-table-column property="openid" align="center" label="小程序openid" />

      <el-table-column align="center" label="头像" width="150">
        <template slot-scope="scope">
          <span><el-avatar :size="80" :src="scope.row.avatar" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="微信号">
        <template slot-scope="scope">
          <div>微信号：{{ scope.row.wx }}</div>
          <div>
            <span>是否已添加：{{ scope.row.addWx | getStatusText }}</span>
            <i class="el-icon-edit remark-edit" @click="addWxClick(scope.row.uid,scope.row.addWx)" />
          </div>
        </template>
      </el-table-column>

      <el-table-column property="qrcode" align="center" label="二维码" />

      <el-table-column align="center" label="邀请人信息">
        <template slot-scope="scope">
          <div>{{ scope.row.inviteId }}</div>
          <div>{{ scope.row.inviteUsername }}</div>
          <div>{{ scope.row.inviteMobile }}</div>
        </template>
      </el-table-column>

      <el-table-column align="center" label="客户端信息">
        <template slot-scope="scope">
          <div v-if="scope.row.os">系统类型：{{ scope.row.os }}</div>
          <div v-if="scope.row.version">版本号：{{ scope.row.version }}</div>
          <div v-if="scope.row.phoneModel">手机型号：{{ scope.row.phoneModel }}</div>
        </template>
      </el-table-column>

      <el-table-column property="created" align="center" label="注册时间" />

      <el-table-column align="center" label="登录信息">
        <template slot-scope="scope">
          <el-button plain round size="mini" @click="viewLogin(scope.row.uid)">{{ $t('table.view') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

    <el-dialog title="微信标记" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :model="filter" label-width="100px">
          <el-form-item style="display:none" label="id" prop="uid">
            <el-input v-model="filter.uid" />
          </el-form-item>
          <el-form-item label="是否已添加" prop="addWx">
            <el-radio-group v-model="filter.addWx">
              <el-radio label="0">否</el-radio>
              <el-radio label="1">是</el-radio>
            </el-radio-group>
          </el-form-item>
        </el-form>

        <div slot="footer" class="dialog-footer text-center">
          <el-button @click="dialogVisible = false">
            {{ $t('table.cancel') }}
          </el-button>
          <el-button type="primary" @click="addWxCommit">
            {{ $t('table.confirm') }}
          </el-button>
        </div>
      </div>
    </el-dialog>

    <LoginList v-if="isShow" :is-show="isShow" :user-id="userId" @closeShowDialog="closeShowDialog" />
  </div>
</template>

<script>
import { status, getVal } from '@/utils/sys'
import { userList, dealUser } from '@/api/member'
import Pagination from '@/components/Pagination'
import LoginList from './components/LoginList'

export default {
  components: { Pagination, LoginList },
  filters: {
    getStatusText(index) {
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
        beginDate: '',
        endDate: ''
      },
      filter: {
        uid: '',
        addWx: '0'
      },
      downloadLoading: true,
      filename: '用户管理',
      excelList: [],
      list: [],
      total: 0,
      dialogVisible: false,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      },
      userId: '',
      isShow: false
    }
  },
  created() {
    this.getList()
  },
  methods: {
    // 是否添加微信标记
    addWxClick(uid, addWx) {
      this.dialogVisible = true

      this.$nextTick(() => {
        this.filter.uid = uid
        this.filter.addWx = addWx
      })
    },
    // 提交
    addWxCommit() {
      dealUser({ ...this.filter, type: 1 }).then(response => {
        this.$message.success(this.$t('msg.success'))
        this.getList()
      })
      this.dialogVisible = false
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
      userList(this.listQuery).then(response => {
        this.list = response.data.list
        this.excelList = response.data.excelList
        this.total = parseInt(response.data.total)
        this.listLoading = false
      })
    },
    // 查看
    viewLogin(uid) {
      this.userId = uid
      this.isShow = true
    },
    // 关闭回复
    closeShowDialog() {
      this.isShow = false
    },
    // 导出excel
    exportData() {
      this.downloadLoading = true
      import('@/vendor/Export2Excel').then(excel => {
        const tHeader = ['id', '用户名', '手机号', '小程序openid', '微信号', '二维码', '邀请人id', '邀请人用户名', '邀请人手机号', '注册时间']
        const filterVal = ['uid', 'username', 'mobile', 'openid', 'wx', 'qrcode', 'inviteId', 'inviteUsername', 'inviteMobile', 'created']
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

  .remark-edit {
    color: #1890ff;
    margin-left: 10px;
    cursor: pointer;
  }
</style>
