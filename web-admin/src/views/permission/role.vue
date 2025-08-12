<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="角色名称" prop="roleName">
        <el-input v-model="form.roleName" placeholder="请输入角色名称" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item>
        <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd('1')">{{ $t('table.add') }}</el-button>
      </el-form-item>
    </el-form>

    <el-table
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      style="width: 100%"
    >
      <el-table-column align="center" label="id" prop="roleId" />

      <el-table-column align="center" label="角色名称" prop="roleName" />

      <el-table-column align="center" label="角色别名" prop="alias" />

      <el-table-column align="center" label="备注" prop="note" />

      <el-table-column align="center" label="操作">
        <template slot-scope="scope">
          <el-button plain round size="mini" @click="handleAdd('2',scope.row)">{{ $t('table.edit') }}</el-button>

          <router-link v-if="scope.row.alias !== 'admin'" :to="'/permission/roleSetting/'+scope.row.roleId" style="margin-left: 10px;">
            <el-button type="success" plain round size="mini">配置权限</el-button>
          </router-link>

          <el-button v-if="scope.row.alias !== 'admin'" type="danger" plain round size="mini" style="margin-left: 10px;" @click="handleDel(scope.row.roleId)">{{ $t('table.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog :title="title" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="80px">
          <el-form-item style="display:none" label="Id" prop="roleId">
            <el-input v-model="filter.roleId" />
          </el-form-item>
          <el-form-item label="角色名称" prop="roleName">
            <el-input v-model.trim="filter.roleName" :disabled="filter.alias ==='admin'" />
          </el-form-item>
          <el-form-item label="角色别名" prop="alias">
            <el-input v-model.trim="filter.alias" :disabled="filter.alias ==='admin'" />
          </el-form-item>
          <el-form-item label="备注" prop="note">
            <el-input v-model.trim="filter.note" />
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
import { fetchRoleList, dealRole } from '@/api/permission'
import { roleType, getVal } from '@/utils/sys'

export default {
  filters: {
    getRoleType(index) {
      return getVal(index, roleType())
    }
  },
  data() {
    return {
      isAdd: true,
      form: {
        roleName: ''
      },
      list: [],
      total: 0,
      dialogVisible: false,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      },
      filter: {
        roleId: '',
        roleName: '',
        alias: '',
        note: ''
      },
      filterRules: {
        roleName: [
          { required: true, message: '请输入权限名称', trigger: 'blur' }
        ]
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
  },
  methods: {
    // 编辑
    handleAdd(type, row) {
      this.dialogVisible = true

      this.$nextTick(() => {
        if (type === '1') {
          this.isAdd = true
          this.resetForm('filter')
        } else {
          this.isAdd = false
          this.filter.roleId = row.roleId
          this.filter.roleName = row.roleName
          this.filter.alias = row.alias
          this.filter.note = row.note
        }
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const type = this.isAdd ? '1' : '2'
        const query = Object.assign(this.filter, { type })

        dealRole(query).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
      })
    },
    // 删除
    handleDel(roleId) {
      this.$confirm(this.$t('table.confirmDelete'), this.$t('table.tip'), {
        confirmButtonText: this.$t('table.confirm'),
        cancelButtonText: this.$t('table.cancel'),
        type: 'warning'
      }).then(() => {
        dealRole({ roleId, type: '3' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    handleSearch() {
      this.listQuery.page = 1
      this.getList()
    },
    // 获取列表
    getList() {
      this.listLoading = true
      this.listQuery = Object.assign(this.listQuery, this.form)
      fetchRoleList(this.listQuery).then(response => {
        if (response.data.roleList) {
          this.list = response.data.roleList
          this.total = parseInt(response.data.total)
        }
        this.listLoading = false
      })
    },
    // 重置
    resetForm(form) {
      this.$refs[form].resetFields()
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
