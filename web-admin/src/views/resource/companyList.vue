<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="药厂名称" prop="companyName">
        <el-input v-model="form.companyName" placeholder="请输入药厂名称" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="状态" prop="enable">
        <el-select v-model="form.enable" placeholder="全部">
          <el-option v-for="item in typeList" :key="item.key" :label="item.val" :value="item.key" />
        </el-select>
      </el-form-item>
      <el-form-item label="热门类型" prop="hotType">
        <el-select v-model="form.hotType" placeholder="全部">
          <el-option v-for="item in hotTypeList" :key="item.key" :label="item.val" :value="item.key" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
        <el-button type="primary" icon="el-icon-document" @click="exportData">{{ $t('table.exportExcel') }}</el-button>
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
      <el-table-column property="companyId" align="center" label="id" width="80" />

      <el-table-column property="companyName" align="center" label="药厂名称" />

      <el-table-column align="center" label="药厂图片" width="200">
        <template slot-scope="scope">
          <span><img :src="scope.row.companyImage" width="160" height="120"></span>
        </template>
      </el-table-column>

      <el-table-column property="requestUrl" align="center" label="药厂查询url" />

      <el-table-column property="requestMethod" align="center" label="请求方式" />

      <el-table-column property="element" align="center" label="标识元素" />

      <el-table-column property="resultField" align="center" label="结果字段标识" />

      <el-table-column property="sort" align="center" label="排序" />

      <el-table-column align="center" label="热门类型">
        <template slot-scope="scope">
          <span>{{ scope.row.hotType | hotFilter }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="状态">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.enable" active-value="0" inactive-value="1" @change="handleChange(scope.row.companyId,scope.row.enable)" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="操作">
        <template slot-scope="scope">
          <el-button plain round size="mini" @click="handleAdd('2',scope.row)">{{ $t('table.edit') }}</el-button>
          <el-button type="danger" plain round size="mini" @click="handleDel(scope.row.companyId)">{{ $t('table.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="160px">
          <el-form-item style="display:none" label="id" prop="companyId">
            <el-input v-model="filter.companyId" />
          </el-form-item>
          <el-form-item label="药厂名称" prop="companyName">
            <el-input v-model="filter.companyName" />
          </el-form-item>
          <el-form-item label="英文药厂名称" prop="enName">
            <el-input v-model="filter.enName" />
          </el-form-item>
          <el-form-item label="药厂图片" prop="companyImage">
            <el-upload
              class="company-uploader"
              :action="uploadUrl"
              :data="{ type: 'company' }"
              :show-file-list="false"
              :on-success="handleSuccess"
              :on-error="handleError"
            >
              <img v-if="filter.companyImage" :src="filter.companyImage" class="company">
              <i v-else class="el-icon-plus company-uploader-icon" />
            </el-upload>
            <div class="red">图片尺寸：4:3</div>
          </el-form-item>
          <el-form-item label="防伪码查询方法" prop="codeQuery">
            <Tinymce ref="editor" v-model="filter.codeQuery" :height="300" />
          </el-form-item>
          <el-form-item label="药厂查询url" prop="requestUrl">
            <el-input v-model.trim="filter.requestUrl" type="textarea" :rows="6" />
            <div class="red">注意：code数值用XXXXXX标识</div>
          </el-form-item>
          <el-form-item label="请求方式" prop="requestMethod">
            <el-input v-model="filter.requestMethod" />
          </el-form-item>
          <el-form-item label="标识元素" prop="element">
            <el-input v-model.trim="filter.element" type="textarea" :rows="6" />
            <div class="red">注意：这是识别获取数据的关键元素</div>
          </el-form-item>
          <el-form-item label="结果字段标识" prop="resultField">
            <el-input v-model.trim="filter.resultField" type="textarea" :rows="6" />
            <div class="red">注意：这是数据筛选有用信息的标识</div>
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input v-model.trim="filter.sort" />
          </el-form-item>
          <el-form-item label="热门类型" prop="hotType">
            <el-radio-group v-model="filter.hotType">
              <el-radio v-for="item in hotTypeList" :key="item.key" :label="item.key">{{ item.val }}</el-radio>
            </el-radio-group>
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
import { enableType, hotType, getVal } from '@/utils/sys'
import { companyList, dealCompany } from '@/api/resource'
import Pagination from '@/components/Pagination'
import Tinymce from '@/components/Tinymce'

export default {
  components: { Pagination, Tinymce },
  filters: {
    hotFilter(hot) {
      return getVal(hot, hotType())
    }
  },
  data() {
    return {
      typeList: enableType(),
      hotTypeList: hotType(),
      isAdd: true,
      uploadUrl: '',
      form: {
        companyName: '',
        enable: '',
        hotType: ''
      },
      filter: {
        companyId: '',
        companyName: '',
        enName: '',
        companyImage: '',
        codeQuery: '',
        requestUrl: '',
        requestMethod: '',
        element: '',
        resultField: '',
        sort: '',
        hotType: '0',
        enable: '0'
      },
      filterRules: {
        companyName: [{ required: true, message: '请输入药厂名称', trigger: 'blur' }],
        enName: [{ required: true, message: '请输入英文药厂名称', trigger: 'blur' }],
        companyImage: [{ required: true, message: '请上传图片', trigger: 'blur' }]
      },
      downloadLoading: true,
      filename: '药厂管理',
      excelList: [],
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
    this.uploadUrl = process.env.VUE_APP_UPLOAD_URL
    this.getList()
  },
  methods: {
    handleAdd(type, row) {
      this.dialogVisible = true

      this.$nextTick(() => {
        if (type === '1') {
          this.isAdd = true
          this.resetForm('filter')
          this.$refs.editor.setContent('')
        } else {
          this.isAdd = false
          this.filter.companyId = row.companyId
          this.filter.companyName = row.companyName
          this.filter.enName = row.enName
          this.filter.companyImage = row.companyImage
          this.filter.codeQuery = row.codeQuery
          this.filter.requestUrl = row.requestUrl
          this.filter.requestMethod = row.requestMethod
          this.filter.element = row.element
          this.filter.resultField = row.resultField
          this.filter.sort = row.sort
          this.filter.enable = row.enable
          this.filter.hotType = row.hotType
          this.$refs.editor.setContent(this.filter.codeQuery)
        }
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const operateType = this.isAdd === true ? '1' : '2'
        dealCompany({ operateType, ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
      })
    },
    // 删除
    handleDel(companyId) {
      this.$confirm(this.$t('table.confirmDelete'), this.$t('table.tip'), {
        confirmButtonText: this.$t('table.confirm'),
        cancelButtonText: this.$t('table.cancel'),
        type: 'warning'
      }).then(() => {
        dealCompany({ companyId, operateType: '3' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    // 改变状态
    handleChange(companyId, val) {
      const enable = val
      dealCompany({ companyId, enable, operateType: '4' }).then(response => {
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
      companyList(this.listQuery).then(response => {
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
        const tHeader = ['id', '药厂名称', '药厂查询url', '标识元素', '状态']
        const filterVal = ['companyId', 'companyName', 'requestUrl', 'element', 'enable']
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
        if (j === 'enable') {
          return getVal(v[j], enableType())
        } else {
          return v[j]
        }
      }))
    },
    handleSuccess(response) {
      if (response.code === 200) {
        this.filter.companyImage = response.data.url
      } else {
        this.$message.error(response.msg)
      }
    },
    handleError() {
      this.$message.error(this.$t('page.netWorkError'))
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

<style>
  .company-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .company-uploader .el-upload:hover {
    border-color: #409EFF;
  }

  .company-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 160px;
    height: 120px;
    line-height: 120px;
    text-align: center;
  }

  .company {
    width: 160px;
    height: 120px;
    display: block;
  }

  .red {
    color: #ff0000;
  }
</style>
