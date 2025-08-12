<template>
  <div class="app-container">
    <el-button type="primary" icon="el-icon-plus" @click="handleAdd('1')">{{ $t('table.add') }}</el-button>

    <el-table
      v-loading="listLoading"
      :data="list"
      row-key="id"
      fit
      highlight-current-row
      :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
      style="width: 100%;margin-top: 20px;"
    >
      <el-table-column property="className" label="分类名称" />

      <el-table-column property="sort" align="center" label="排序" />

      <el-table-column align="center" label="状态">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.enable" active-value="0" inactive-value="1" @change="handleChange(scope.row.id,scope.row.enable)" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="操作">
        <template slot-scope="scope">
          <el-button plain round size="mini" @click="handleAdd('2',scope.row)">{{ $t('table.edit') }}</el-button>
          <el-button type="danger" plain round size="mini" @click="handleDel(scope.row.id)">{{ $t('table.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog :title="title" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="120px">
          <el-form-item style="display:none" label="id" prop="id">
            <el-input v-model="filter.id" />
          </el-form-item>
          <el-form-item label="选择分类" prop="pidList">
            <el-cascader
              v-if="isShow"
              ref="classClose"
              v-model="filter.pidList"
              :options="classList"
              :props="{ checkStrictly: true }"
              clearable
              style="width: 100%"
              @change="handleChangeClass"
            />
          </el-form-item>
          <el-form-item label="分类名称" prop="className">
            <el-input v-model="filter.className" />
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input v-model="filter.sort" />
          </el-form-item>
          <el-form-item label="状态" prop="enable">
            <el-switch v-model="filter.enable" active-value="0" inactive-value="1" />
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
import { classList, dealClass } from '@/api/resource'

export default {
  data() {
    return {
      isAdd: true,
      filter: {
        id: '',
        pidList: [],
        className: '',
        sort: '',
        enable: '0'
      },
      filterRules: {
        className: [{ required: true, message: '请输入分类名称', trigger: 'blur' }]
      },
      list: [],
      dialogVisible: false,
      listLoading: true,
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
    this.getList()
  },
  methods: {
    handleAdd(type, row) {
      this.dialogVisible = true
      this.isShow = false

      this.$nextTick(() => {
        if (type === '1') {
          this.isAdd = true
          this.resetForm('filter')
        } else {
          this.isAdd = false
          this.filter.id = row.id
          this.filter.pidList = row.pidList
          this.filter.className = row.className
          this.filter.sort = row.sort
          this.filter.enable = row.enable
        }
        this.getClassList()
        this.isShow = true
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const operateType = this.isAdd === true ? '1' : '2'
        dealClass({ operateType, ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
      })
    },
    // 删除
    handleDel(id) {
      this.$confirm(this.$t('table.confirmDelete'), this.$t('table.tip'), {
        confirmButtonText: this.$t('table.confirm'),
        cancelButtonText: this.$t('table.cancel'),
        type: 'warning'
      }).then(() => {
        dealClass({ id, operateType: '3' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    // 改变状态
    handleChange(id, val) {
      const enable = val
      dealClass({ id, enable, operateType: '4' }).then(response => {
        this.$message.success(this.$t('msg.success'))
        this.getList()
      })
    },
    // 重置
    resetForm(form) {
      this.filter.pidList = []
      this.$refs[form].resetFields()
    },
    // 搜索
    getList() {
      this.listLoading = true
      classList({}).then(response => {
        this.list = response.data.list
        this.listLoading = false
      })
    },
    // 分类列表
    getClassList() {
      classList({ type: 1, currentId: this.filter.id }).then(response => {
        this.classList = response.data.list
      })
    },
    // 切换分类
    handleChangeClass() {
      this.$refs.classClose._self.dropDownVisible = false
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
