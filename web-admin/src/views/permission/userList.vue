<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="用户信息" prop="username">
        <el-input v-model="form.username" placeholder="请输入用户名/手机号" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="角色名称" prop="roleId">
        <el-select v-model="form.roleId" placeholder="请选择角色">
          <el-option v-for="item in roleList" :key="item.roleId" :label="item.roleName" :value="item.roleId" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd('1')">{{ $t('table.add') }}</el-button>
      </el-form-item>
    </el-form>

    <div style="margin-bottom:20px; color: #ff0000; font-weight: bold;">默认密码：12345a</div>

    <el-table
      ref="multipleTable"
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      style="width: 100%"
    >
      <el-table-column align="center" label="id">
        <template slot-scope="scope">
          <span>{{ scope.row.uid }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="用户名">
        <template slot-scope="scope">
          <span>{{ scope.row.username }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="手机号码">
        <template slot-scope="scope">
          <span>{{ scope.row.mobile }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="角色名称">
        <template slot-scope="scope">
          <span>{{ scope.row.roleName }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="操作">
        <template slot-scope="scope">
          <el-button plain round size="mini" @click="handleAdd('2',scope.row)">{{ $t('table.edit') }}</el-button>
          <el-button type="danger" plain round size="mini" @click="handleDel(scope.row.uid)">{{ $t('table.delete') }}</el-button>
          <el-button plain round size="mini" @click="resetPassword(scope.row.uid)">{{ $t('table.resetPassword') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="80px">
          <el-form-item style="display:none" label="Id" prop="uid">
            <el-input v-model="filter.uid" />
          </el-form-item>
          <el-form-item label="手机账号" prop="mobile">
            <el-input v-model.trim="filter.mobile" />
          </el-form-item>
          <el-form-item label="姓名" prop="username">
            <el-input v-model.trim="filter.username" />
          </el-form-item>
          <el-form-item label="角色" prop="roleId">
            <el-select v-model="filter.roleId" placeholder="请选择角色">
              <el-option v-for="item in roleList" :key="item.roleId" :label="item.roleName" :value="item.roleId" />
            </el-select>
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
  </div>
</template>

<script>
import { fetchUserList, fetchRoleAllList, dealUser } from '@/api/permission'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  data() {
    return {
      isAdd: true,
      roleList: [],
      form: {
        username: '',
        roleId: ''
      },
      filter: {
        mobile: '',
        username: '',
        roleId: ''
      },
      filterRules: {
        mobile: [{ required: true, message: '请输入手机账号', trigger: 'blur' }],
        username: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
        roleId: [{ required: true, message: '请选择角色名称', trigger: 'blur' }]
      },
      options: [],
      optionsLoading: false,
      mutlUidList: [], // 全选的uid
      uidList: [], // 单个的uid
      list: [],
      total: 0,
      dialogVisible: false,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      }
    }
  },
  computed: {
    title() {
      return this.isAdd === true ? this.$t('table.add') : this.$t('table.edit')
    }
  },
  created() {
    this.getList()
    this.getRoleList()
  },
  methods: {
    handleAdd(type, row) {
      this.dialogVisible = true

      this.$nextTick(() => {
        if (type === '1') {
          this.isAdd = true
          this.resetForm('filter')
        } else {
          this.isAdd = false
          this.filter.uid = row.uid
          this.filter.mobile = row.mobile
          this.filter.username = row.username
          this.filter.roleId = parseInt(row.roleId)
        }
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const type = this.isAdd === true ? '1' : '2'
        dealUser({ type, ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
      })
    },
    // 删除
    handleDel(uid) {
      this.$confirm(this.$t('table.confirmDelete'), this.$t('table.tip'), {
        confirmButtonText: this.$t('table.confirm'),
        cancelButtonText: this.$t('table.cancel'),
        type: 'warning'
      }).then(() => {
        dealUser({ uid, type: '3' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    // 重置密码
    resetPassword(uid) {
      this.$confirm(this.$t('table.makeResetPassword'), this.$t('table.tip'), {
        confirmButtonText: this.$t('table.confirm'),
        cancelButtonText: this.$t('table.cancel'),
        type: 'warning'
      }).then(() => {
        dealUser({ uid, type: '4' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    // 全选
    handleSelectionChange(val) {
      this.mutlUidList = []
      val.forEach(item => {
        this.mutlUidList.push(item.uid)
      })
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
      fetchUserList(this.listQuery).then(response => {
        this.list = response.data.userList
        this.total = parseInt(response.data.total)
        this.listLoading = false
      })
    },
    getRoleList() {
      fetchRoleAllList().then(response => {
        this.roleList = response.data.roleList
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
