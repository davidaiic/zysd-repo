<template>
  <el-dialog
    title="回复列表"
    :visible.sync="replyDialogVisible"
    :close-on-click-modal="false"
    :close-on-press-escape="false"
    width="60%"
    @close="closeDialogVisible"
  >
    <div class="app-container">
      <!-- 条件筛选 -->
      <el-form ref="form" :inline="true" :model="form" size="small">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" @keyup.enter.native="handleSearch" />
        </el-form-item>
        <el-form-item label="手机号" prop="mobile">
          <el-input v-model="form.mobile" placeholder="请输入手机号" @keyup.enter.native="handleSearch" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="全部">
            <el-option v-for="item in typeList" :key="item.key" :label="item.val" :value="item.key" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
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
        <el-table-column property="commentId" align="center" label="id" width="80" />

        <el-table-column property="username" align="center" label="用户名" />

        <el-table-column property="mobile" align="center" label="手机号" />

        <el-table-column align="center" label="内容">
          <template slot-scope="scope">
            <div class="text-left">
              <div v-if="scope.row.sensitiveList.length > 0" class="risk-tip">提示：有风险</div>
              <div v-html="textHighlight(scope.row.content, scope.row.sensitiveStr)" />
            </div>
          </template>
        </el-table-column>

        <el-table-column align="center" label="图片" width="140">
          <template slot-scope="scope">
            <el-image
              v-if="scope.row.pictures"
              style="width: 100px; height: 100px"
              :src="scope.row.pictures"
              :preview-src-list="scope.row.picturesList"
            />
          </template>
        </el-table-column>

        <el-table-column property="likeNum" align="center" label="点赞数" />

        <el-table-column align="center" label="状态">
          <template slot-scope="scope">
            <span>{{ scope.row.status | getStatusType }}</span>
          </template>
        </el-table-column>

        <el-table-column property="created" align="center" label="回复时间" />

        <el-table-column align="center" label="操作" width="160">
          <template slot-scope="scope">
            <el-button v-if="scope.row.status === '0'" plain round size="mini" @click="auditClick(scope.row.commentId)">{{ $t('table.examine') }}</el-button>
            <el-button type="danger" plain round size="mini" @click="handleDel(scope.row.commentId)">{{ $t('table.delete') }}</el-button>
          </template>
        </el-table-column>
      </el-table>

      <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

      <el-dialog :title="$t('table.examine')" :visible.sync="dialogVisible" :append-to-body="true">
        <div>
          <el-form ref="filter" :model="filter" label-width="100px">
            <el-form-item style="display:none" label="id" prop="commentId">
              <el-input v-model="filter.commentId" />
            </el-form-item>
            <el-form-item label="状态" prop="status">
              <el-radio-group v-model="filter.status">
                <el-radio label="1">通过</el-radio>
                <el-radio label="2">拒绝</el-radio>
              </el-radio-group>
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
  </el-dialog>
</template>

<script>
import { statusType, getVal } from '@/utils/sys'
import { replyList, dealComment } from '@/api/member'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  filters: {
    getStatusType(index) {
      return getVal(index, statusType())
    }
  },
  props: {
    isShow: {
      type: Boolean
    },
    commentId: {
      type: String,
      default: '0'
    }
  },
  data() {
    return {
      typeList: statusType(),
      form: {
        username: '',
        mobile: '',
        status: ''
      },
      filter: {
        commentId: '',
        status: '1'
      },
      list: [],
      total: 0,
      dialogVisible: false,
      replyDialogVisible: false,
      listLoading: false,
      listQuery: {
        page: 1,
        limit: 10
      }
    }
  },
  created() {
    this.replyDialogVisible = this.isShow
    this.getList()
  },
  methods: {
    auditClick(commentId) {
      this.dialogVisible = true

      this.$nextTick(() => {
        this.filter.commentId = commentId
        this.filter.status = '1'
      })
    },
    // 提交
    handleCommit() {
      this.handleChange(this.filter.commentId, this.filter.status, 1)
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
      this.listQuery = Object.assign(this.listQuery, this.form, { commentId: this.commentId })
      replyList(this.listQuery).then(response => {
        this.list = response.data.list
        this.total = parseInt(response.data.total)
      })
    },
    // 改变状态
    handleChange(commentId, value, type) {
      dealComment({ commentId, value, type }).then(response => {
        this.$message.success(this.$t('msg.success'))
        this.getList()
      })
    },
    // 删除
    handleDel(commentId) {
      this.$confirm(this.$t('table.confirmDelete'), this.$t('table.tip'), {
        confirmButtonText: this.$t('table.confirm'),
        cancelButtonText: this.$t('table.cancel'),
        type: 'warning'
      }).then(() => {
        dealComment({ commentId, value: 1, type: 4 }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      }).catch(() => {
      })
    },
    // 关闭
    closeDialogVisible() {
      this.$emit('closeShowDialog')
    },
    // 文字高亮
    textHighlight(text, words) {
      if (text && words) {
        const reg = new RegExp(words, 'gi')
        return text.replace(reg, (a) => {
          return `<span style="color: #ffffff; font-weight: bold; background-color: #ff0000; padding: 4px;">${a}</span>`
        })
      } else {
        return text
      }
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

  .text-left {
    text-align: left;
  }

  .risk-tip {
    color: #ff0000;
    font-weight: bold;
  }
</style>
