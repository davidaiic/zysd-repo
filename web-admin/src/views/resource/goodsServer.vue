<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="服务名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入服务名称" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="状态" prop="enable">
        <el-select v-model="form.enable" placeholder="全部">
          <el-option v-for="item in typeList" :key="item.key" :label="item.val" :value="item.key" />
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

      <el-table-column property="name" align="center" label="服务名称" />

      <el-table-column align="center" label="图标" width="160">
        <template slot-scope="scope">
          <span><el-image :src="scope.row.icon" style="width: 80px; height: 80px" /></span>
        </template>
      </el-table-column>

      <el-table-column property="desc" align="center" label="描述" />

      <el-table-column property="linkUrl" align="center" label="跳转链接" />

      <el-table-column property="sort" align="center" label="排序" />

      <el-table-column align="center" label="状态">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.enable" active-value="0" inactive-value="1" @change="handleChange(scope.row.id,scope.row.enable)" /></span>
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
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="100px">
          <el-form-item style="display:none" label="id" prop="id">
            <el-input v-model="filter.id" />
          </el-form-item>
          <el-form-item label="服务名称" prop="name">
            <el-input v-model.trim="filter.name" />
          </el-form-item>
          <el-form-item label="图标" prop="icon">
            <el-upload
              class="goods-server-uploader"
              :action="uploadUrl"
              :data="{ type: 'icon' }"
              :show-file-list="false"
              :on-success="handleSuccess"
              :on-error="handleError"
            >
              <img v-if="filter.icon" :src="filter.icon" class="goods-server">
              <i v-else class="el-icon-plus goods-server-uploader-icon" />
            </el-upload>
            <div class="red">图片尺寸：90 * 90</div>
          </el-form-item>
          <el-form-item label="描述" prop="desc">
            <el-input v-model="filter.desc" />
          </el-form-item>
          <el-form-item label="跳转链接" prop="linkUrl">
            <el-input v-model="filter.linkUrl" />
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input v-model.trim="filter.sort" />
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
import { enableType } from '@/utils/sys'
import { goodsServer, dealGoodsServer } from '@/api/resource'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  data() {
    return {
      typeList: enableType(),
      isAdd: true,
      uploadUrl: '',
      form: {
        name: '',
        enable: ''
      },
      filter: {
        id: '',
        name: '',
        icon: '',
        desc: '',
        linkUrl: '',
        sort: '',
        enable: '0'
      },
      filterRules: {
        name: [{ required: true, message: '请输入服务名称', trigger: 'blur' }],
        icon: [{ required: true, message: '请上传图标', trigger: 'blur' }],
        desc: [{ required: true, message: '请输入描述', trigger: 'blur' }],
        linkUrl: [{ required: true, message: '请输入跳转链接', trigger: 'blur' }]
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
        } else {
          this.isAdd = false
          this.filter.id = row.id
          this.filter.name = row.name
          this.filter.icon = row.icon
          this.filter.desc = row.desc
          this.filter.linkUrl = row.linkUrl
          this.filter.sort = row.sort
          this.filter.enable = row.enable
        }
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const operateType = this.isAdd === true ? '1' : '2'
        dealGoodsServer({ operateType, ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
      })
    },
    // 改变状态
    handleChange(id, val) {
      const enable = val
      dealGoodsServer({ id, enable, operateType: '3' }).then(response => {
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
      goodsServer(this.listQuery).then(response => {
        this.list = response.data.list
        this.total = parseInt(response.data.total)
        this.listLoading = false
      })
    },
    handleSuccess(response) {
      if (response.code === 200) {
        this.filter.icon = response.data.url
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
  .goods-server-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .goods-server-uploader .el-upload:hover {
    border-color: #409EFF;
  }

  .goods-server-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 90px;
    height: 90px;
    line-height: 90px;
    text-align: center;
  }

  .goods-server {
    width: 90px;
    height: 90px;
    display: block;
  }

  .red {
    color: #ff0000;
  }
</style>
