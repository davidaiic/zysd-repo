<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入名称" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="类型" prop="type">
        <el-select v-model="form.type" placeholder="全部">
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
      <el-table-column property="bannerId" align="center" label="id" width="80" />

      <el-table-column property="name" align="center" label="名称" />

      <el-table-column property="notes" align="center" label="描述" />

      <el-table-column align="center" label="图片" width="240">
        <template slot-scope="scope">
          <span><img :src="scope.row.imageUrl" width="207" height="84"></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="类型">
        <template slot-scope="scope">
          <span>{{ scope.row.type | getBannerType }}</span>
        </template>
      </el-table-column>

      <el-table-column property="linkUrl" align="center" label="跳转链接" />

      <el-table-column property="sort" align="center" label="排序" />

      <el-table-column property="text1" align="center" label="文案一" />

      <el-table-column property="text2" align="center" label="文案二" />

      <el-table-column align="center" label="状态">
        <template slot-scope="scope">
          <span>{{ scope.row.enable | getEnableType }}</span>
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
          <el-form-item style="display:none" label="id" prop="bannerId">
            <el-input v-model="filter.bannerId" />
          </el-form-item>
          <el-form-item label="名称" prop="name">
            <el-input v-model.trim="filter.name" />
          </el-form-item>
          <el-form-item label="描述" prop="notes">
            <el-input v-model.trim="filter.notes" />
          </el-form-item>
          <el-form-item label="图片" prop="imageUrl">
            <el-upload
              class="banner-uploader"
              :action="uploadUrl"
              :data="{ type: 'banner' }"
              :show-file-list="false"
              :on-success="handleSuccess"
              :on-error="handleError"
            >
              <img v-if="filter.imageUrl" :src="filter.imageUrl" class="banner">
              <i v-else class="el-icon-plus banner-uploader-icon" />
            </el-upload>
            <div class="red">图片尺寸：345 * 140</div>
          </el-form-item>
          <el-form-item label="类型" prop="type">
            <el-select v-model="filter.type" style="width: 100%">
              <el-option v-for="item in typeList" :key="item.key" :label="item.val" :value="item.key" />
            </el-select>
          </el-form-item>
          <el-form-item v-if="filter.type === '1'" label="跳转链接" prop="linkUrl">
            <el-input v-model.trim="filter.linkUrl" />
          </el-form-item>
          <el-form-item v-if="filter.type === '1'" label="跳转规则说明">
            <div class="red">药品详情：https://shiyao.yaojk.com.cn/shiyao/goods?id=XXX，XXX是药品管理中的id</div>
            <div class="red">资讯详情：https://shiyao.yaojk.com.cn/shiyao/articleInfo?id=XXX，XXX是资讯列表中的id</div>
            <div class="red">webView： https://mp.weixin.qq.com/s/ZGJd9sWHY5kEK2wmNIRRdg?title=XXX，XXX是页面标题</div>
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input v-model.trim="filter.sort" />
          </el-form-item>
          <el-form-item label="文案一" prop="text1">
            <el-input v-model.trim="filter.text1" />
          </el-form-item>
          <el-form-item label="文案二" prop="text2">
            <el-input v-model.trim="filter.text2" />
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
import { bannerType, enableType, getVal } from '@/utils/sys'
import { banner, dealBanner } from '@/api/system'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  filters: {
    getBannerType(index) {
      return getVal(index, bannerType())
    },
    getEnableType(index) {
      return getVal(index, enableType())
    }
  },
  data() {
    return {
      typeList: bannerType(),
      isAdd: true,
      uploadUrl: '',
      form: {
        name: '',
        type: ''
      },
      filter: {
        bannerId: '',
        name: '',
        notes: '',
        imageUrl: '',
        type: '0',
        linkUrl: '',
        sort: '',
        text1: '',
        text2: '',
        enable: '0'
      },
      filterRules: {
        name: [{ required: true, message: '请输入名称', trigger: 'blur' }],
        imageUrl: [{ required: true, message: '请上传图片', trigger: 'blur' }],
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
          this.filter.bannerId = row.bannerId
          this.filter.name = row.name
          this.filter.notes = row.notes
          this.filter.imageUrl = row.imageUrl
          this.filter.type = row.type
          this.filter.linkUrl = row.linkUrl
          this.filter.sort = row.sort
          this.filter.text1 = row.text1
          this.filter.text2 = row.text2
          this.filter.enable = row.enable
        }
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const operateType = this.isAdd === true ? '1' : '2'
        dealBanner({ operateType, ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
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
      banner(this.listQuery).then(response => {
        this.list = response.data.list
        this.total = parseInt(response.data.total)
        this.listLoading = false
      })
    },
    handleSuccess(response) {
      if (response.code === 200) {
        this.filter.imageUrl = response.data.url
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
  .banner-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .banner-uploader .el-upload:hover {
    border-color: #409EFF;
  }

  .banner-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 207px;
    height: 84px;
    line-height: 84px;
    text-align: center;
  }

  .banner {
    width: 207px;
    height: 84px;
    display: block;
  }

  .red {
    color: #ff0000;
  }
</style>
