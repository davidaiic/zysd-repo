<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="系统类型" prop="platform">
        <el-select v-model="form.platform" placeholder="全部">
          <el-option v-for="item in platformTypeList" :key="item.key" :label="item.val" :value="item.key" />
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

      <el-table-column align="center" label="系统类型">
        <template slot-scope="scope">
          <span>{{ scope.row.platform | platformFilter }}</span>
        </template>
      </el-table-column>

      <el-table-column property="version_number" align="center" label="版本号" />

      <el-table-column property="content" align="center" label="更新说明" />

      <el-table-column align="center" label="更新类型">
        <template slot-scope="scope">
          <span>{{ scope.row.is_must | updateFilter }}</span>
        </template>
      </el-table-column>

      <el-table-column property="download_url" align="center" label="APP下载地址" />

      <el-table-column property="created" align="center" label="发布时间" />

      <el-table-column align="center" label="状态">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.status" active-value="1" inactive-value="2" @change="handleChange(scope.row.id,scope.row.status)" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="操作">
        <template slot-scope="scope">
          <el-button plain round size="mini" @click="handleAdd('2',scope.row)">{{ $t('table.edit') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="120px">
          <el-form-item style="display:none" label="id" prop="id">
            <el-input v-model="filter.id" />
          </el-form-item>
          <el-form-item label="系统类型" prop="platform">
            <el-select v-model="filter.platform" style="width: 100%">
              <el-option v-for="item in platformTypeList" :key="item.key" :label="item.val" :value="item.key" />
            </el-select>
          </el-form-item>
          <el-form-item label="版本号" prop="version_number">
            <el-input v-model.trim="filter.version_number" />
          </el-form-item>
          <el-form-item label="APP下载地址" prop="download_url">
            <el-input v-model.trim="filter.download_url" />
          </el-form-item>
          <el-form-item label="更新类型" prop="is_must">
            <el-select v-model="filter.is_must" style="width: 100%">
              <el-option v-for="item in updateTypeList" :key="item.key" :label="item.val" :value="item.key" />
            </el-select>
          </el-form-item>
          <el-form-item label="更新说明" prop="content">
            <el-input v-model="filter.content" type="textarea" :rows="6" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-switch v-model="filter.status" active-value="1" inactive-value="2" />
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
import { platformType, updateType, getVal } from '@/utils/sys'
import { appVersion, dealAppVersion } from '@/api/system'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  filters: {
    platformFilter(platform) {
      return getVal(platform, platformType())
    },
    updateFilter(must) {
      return getVal(must, updateType())
    }
  },
  data() {
    return {
      isAdd: true,
      platformTypeList: platformType(),
      updateTypeList: updateType(),
      form: {
        platform: ''
      },
      filter: {
        id: '',
        platform: '1',
        version_number: '',
        version_code: '',
        download_url: '',
        is_must: '2',
        content: '',
        status: '1'
      },
      filterRules: {
        platform: [{ required: true, message: '请选择系统类型', trigger: 'blur' }],
        version_number: [{ required: true, message: '请输入版本号', trigger: 'blur' }],
        download_url: [{ required: true, message: '请输入APP下载地址', trigger: 'blur' }],
        is_must: [{ required: true, message: '请选择更新类型', trigger: 'blur' }],
        content: [{ required: true, message: '请输入更新说明', trigger: 'blur' }]
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
          this.filter.platform = row.platform
          this.filter.version_number = row.version_number
          this.filter.version_code = row.version_code
          this.filter.download_url = row.download_url
          this.filter.is_must = row.is_must
          this.filter.content = row.content
          this.filter.status = row.status
        }
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const type = this.isAdd === true ? '1' : '2'
        dealAppVersion({ type, ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
      })
    },
    // 改变状态
    handleChange(id, val) {
      const status = val
      dealAppVersion({ id, status, type: '3' }).then(response => {
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
      appVersion(this.listQuery).then(response => {
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
