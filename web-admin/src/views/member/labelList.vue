<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="标签名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入标签名称" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="是否热门" prop="isHot">
        <el-select v-model="form.isHot" placeholder="全部">
          <el-option v-for="item in statusList" :key="item.key" :label="item.val" :value="item.key" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd('1')">{{ $t('table.add') }}</el-button>
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
      <el-table-column property="id" align="center" label="id" width="80" />

      <el-table-column property="name" align="center" label="标签名称" />

      <el-table-column property="sort" align="center" label="排序" />

      <el-table-column align="center" label="是否热门">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.isHot" active-value="1" inactive-value="0" @change="handleChange(scope.row.id,scope.row.isHot)" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="操作">
        <template slot-scope="scope">
          <el-button plain round size="mini" @click="handleAdd('2',scope.row)">{{ $t('table.edit') }}</el-button>
          <el-button type="danger" plain round size="mini" @click="handleDel(scope.row.id)">{{ $t('table.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="100px">
          <el-form-item style="display:none" label="id" prop="id">
            <el-input v-model="filter.id" />
          </el-form-item>
          <el-form-item label="标签名称" prop="name">
            <el-input v-model.trim="filter.name" />
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input v-model.trim="filter.sort" />
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
  </div>
</template>

<script>
import { status } from '@/utils/sys'
import { labelList, dealLabel } from '@/api/member'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  data() {
    return {
      statusList: status(),
      isAdd: true,
      form: {
        name: '',
        isHot: ''
      },
      filter: {
        id: '',
        name: '',
        sort: '',
        isHot: '0'
      },
      filterRules: {
        name: [{ required: true, message: '请输入标签名称', trigger: 'blur' }]
      },
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
          this.filter.id = row.id
          this.filter.name = row.name
          this.filter.sort = row.sort
          this.filter.isHot = row.isHot
        }
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const operateType = this.isAdd === true ? '1' : '2'
        dealLabel({ operateType, ...this.filter }).then(response => {
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
        dealLabel({ id, operateType: '3' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    // 改变状态
    handleChange(id, isHot) {
      dealLabel({ id, isHot, operateType: '4' }).then(response => {
        this.$message.success(this.$t('msg.success'))
        this.getList()
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
      labelList(this.listQuery).then(response => {
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
