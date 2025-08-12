<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="标题" prop="title">
        <el-input v-model="form.title" placeholder="请输入标题" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="发布日期" prop="publishDate">
        <el-date-picker
          v-model="form.publishDate"
          format="yyyy-MM-dd"
          value-format="yyyy-MM-dd"
          align="right"
          type="date"
          placeholder="请选择发布日期"
          @keyup.enter.native="handleSearch"
        />
      </el-form-item>
      <el-form-item label="标签" prop="label">
        <el-select v-model="form.label" placeholder="全部">
          <el-option v-for="(item, index) in labelList" :key="index" :label="item.name" :value="item.name" />
        </el-select>
      </el-form-item>
      <el-form-item label="是否置顶" prop="isTop">
        <el-select v-model="form.isTop" placeholder="全部">
          <el-option v-for="item in statusList" :key="item.key" :label="item.val" :value="item.key" />
        </el-select>
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
      <el-table-column property="articleId" align="center" label="id" width="80" />

      <el-table-column property="title" align="center" label="标题" />

      <el-table-column align="center" label="封面" width="160">
        <template slot-scope="scope">
          <span><el-image :src="scope.row.cover" style="width: 100px; height: 100px" /></span>
        </template>
      </el-table-column>

      <el-table-column property="publishDate" align="center" label="发布日期" />

      <el-table-column align="center" label="标签">
        <template slot-scope="scope">
          <el-tag v-for="item in scope.row.label" :key="item" class="center5">
            {{ item }}
          </el-tag>
        </template>
      </el-table-column>

      <el-table-column property="likeNum" align="center" label="点赞数" />

      <el-table-column property="commentNum" align="center" label="评论数" />

      <el-table-column property="readNum" align="center" label="阅读数" />

      <el-table-column align="center" label="是否置顶">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.isTop" active-value="1" inactive-value="0" @change="handleChange(scope.row.articleId,scope.row.isTop,1)" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="状态">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.enable" active-value="0" inactive-value="1" @change="handleChange(scope.row.articleId,scope.row.enable,2)" /></span>
        </template>
      </el-table-column>

      <el-table-column property="sort" align="center" label="排序" />

      <el-table-column align="center" label="操作" width="260">
        <template slot-scope="scope">
          <el-button plain round size="mini" @click="handleAdd('2',scope.row)">{{ $t('table.edit') }}</el-button>
          <el-button plain round size="mini" @click="viewComment(scope.row.articleId)">{{ $t('table.viewComment') }}</el-button>
          <el-button type="danger" plain round size="mini" @click="handleDel(scope.row.articleId)">{{ $t('table.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

    <el-dialog :title="title" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="100px">
          <el-form-item style="display:none" label="id" prop="articleId">
            <el-input v-model="filter.articleId" />
          </el-form-item>
          <el-form-item label="标题" prop="title">
            <el-input v-model="filter.title" />
          </el-form-item>
          <el-form-item label="封面" prop="cover">
            <el-upload
              class="article-cover-uploader"
              :action="uploadUrl"
              :data="{ type: 'image' }"
              :show-file-list="false"
              :on-success="handleSuccess"
              :on-error="handleError"
            >
              <img v-if="filter.cover" :src="filter.cover" class="article-cover">
              <i v-else class="el-icon-plus article-cover-uploader-icon" />
            </el-upload>
            <div class="red">图片尺寸：100 * 100</div>
          </el-form-item>
          <el-form-item label="发布日期" prop="publishDate">
            <el-date-picker
              v-model="filter.publishDate"
              format="yyyy-MM-dd"
              value-format="yyyy-MM-dd"
              align="right"
              type="date"
              style="width: 100%"
            />
          </el-form-item>
          <el-form-item label="标签" prop="label">
            <el-checkbox-group v-model="filter.label">
              <el-checkbox v-for="(item, index) in labelList" :key="index" :label="item.name">{{ item.name }}</el-checkbox>
            </el-checkbox-group>
          </el-form-item>
          <el-form-item label="内容" prop="content">
            <Tinymce ref="editor" v-model="filter.content" :height="400" />
          </el-form-item>
          <el-form-item label="是否置顶" prop="isTop">
            <el-radio-group v-model="filter.isTop">
              <el-radio label="0">否</el-radio>
              <el-radio label="1">是</el-radio>
            </el-radio-group>
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

    <CommentList v-if="isShow" :is-show="isShow" :article-id="articleId" @closeShowDialog="closeShowDialog" />
  </div>
</template>

<script>
import { enableType, status } from '@/utils/sys'
import { articleList, dealArticle, allLabel } from '@/api/member'
import Pagination from '@/components/Pagination'
import Tinymce from '@/components/Tinymce'
import CommentList from './components/CommentList'

export default {
  components: { Pagination, Tinymce, CommentList },
  data() {
    return {
      isAdd: true,
      labelList: [],
      typeList: enableType(),
      statusList: status(),
      uploadUrl: '',
      form: {
        title: '',
        publishDate: '',
        label: '',
        isTop: '',
        enable: ''
      },
      filter: {
        articleId: '',
        title: '',
        cover: '',
        publishDate: '',
        label: [],
        content: '',
        isTop: '0',
        sort: '',
        enable: '0'
      },
      filterRules: {
        title: [{ required: true, message: '请输入标题', trigger: 'blur' }]
      },
      list: [],
      total: 0,
      dialogVisible: false,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      },
      articleId: '',
      isShow: false
    }
  },
  computed: {
    title() {
      return this.isAdd === true ? this.$t('table.add') : this.$t('table.edit')
    }
  },
  created() {
    this.uploadUrl = process.env.VUE_APP_UPLOAD_URL
    this.getLabelList()
    this.getList()
  },
  methods: {
    // 所有标签
    getLabelList() {
      allLabel({}).then(response => {
        this.labelList = response.data.list
      })
    },
    handleAdd(type, row) {
      this.dialogVisible = true

      this.$nextTick(() => {
        if (type === '1') {
          this.isAdd = true
          this.resetForm('filter')
          this.$refs.editor.setContent('')
        } else {
          this.isAdd = false
          this.filter.articleId = row.articleId
          this.filter.title = row.title
          this.filter.cover = row.cover
          this.filter.publishDate = row.publishDate
          this.filter.label = row.label
          this.filter.content = row.content
          this.filter.isTop = row.isTop
          this.filter.sort = row.sort
          this.filter.enable = row.enable
          this.$refs.editor.setContent(this.filter.content)
        }
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        const operateType = this.isAdd === true ? '1' : '2'
        dealArticle({ operateType, ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
      })
    },
    // 删除
    handleDel(articleId) {
      this.$confirm(this.$t('table.confirmDelete'), this.$t('table.tip'), {
        confirmButtonText: this.$t('table.confirm'),
        cancelButtonText: this.$t('table.cancel'),
        type: 'warning'
      }).then(() => {
        dealArticle({ articleId, operateType: '3' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    // 改变状态
    handleChange(articleId, val, type) {
      if (type === 2) {
        const enable = val
        dealArticle({ articleId, enable, operateType: '5' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      } else {
        const isTop = val
        dealArticle({ articleId, isTop, operateType: '4' }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }
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
      articleList(this.listQuery).then(response => {
        this.list = response.data.list
        this.total = parseInt(response.data.total)
        this.listLoading = false
      })
    },
    // 查看评论
    viewComment(articleId) {
      this.articleId = articleId
      this.isShow = true
    },
    // 关闭评论
    closeShowDialog() {
      this.isShow = false
    },
    handleSuccess(response) {
      if (response.code === 200) {
        this.filter.cover = response.data.url
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

  .center5 {
    margin: 5px;
  }
</style>

<style>
  .article-cover-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .article-cover-uploader .el-upload:hover {
    border-color: #409EFF;
  }

  .article-cover-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 100px;
    height: 100px;
    line-height: 100px;
    text-align: center;
  }

  .article-cover {
    width: 100px;
    height: 100px;
    display: block;
  }

  .red {
    color: #ff0000;
  }
</style>
