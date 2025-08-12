<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <div>
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
        <el-form-item label="是否热门" prop="isHot">
          <el-select v-model="form.isHot" placeholder="全部">
            <el-option v-for="item in statusList" :key="item.key" :label="item.val" :value="item.key" />
          </el-select>
        </el-form-item>
      </div>
      <div>
        <el-form-item label="评论时间" prop="beginDate">
          <el-date-picker v-model="form.beginDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" placeholder="开始时间" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
        </el-form-item>
        <el-form-item prop="endDate">
          <el-date-picker v-model="form.endDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" placeholder="结束时间" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
        </el-form-item>
        <el-form-item>
          <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
          <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
        </el-form-item>
      </div>
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

      <el-table-column property="username" align="center" label="用户名" width="180" />

      <el-table-column property="mobile" align="center" label="手机号" width="180" />

      <el-table-column align="center" label="内容" width="260">
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

      <el-table-column property="likeNum" align="center" label="点赞数" width="120" />

      <el-table-column property="commentNum" align="center" label="评论数" width="120" />

      <el-table-column align="center" label="状态" width="140">
        <template slot-scope="scope">
          <span>{{ scope.row.status | getStatusType }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="是否热门" width="140">
        <template slot-scope="scope">
          <span><el-switch v-model="scope.row.isHot" active-value="1" inactive-value="0" @change="handleChange(scope.row.commentId,scope.row.isHot,2)" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="置顶" width="140">
        <template slot-scope="scope">
          <div>
            <span v-if="scope.row.sort > 0">置顶位置：{{ scope.row.sort }}</span>
            <i class="el-icon-edit sort-edit" @click="topClick(scope.row.commentId,scope.row.sort)" />
          </div>
        </template>
      </el-table-column>

      <el-table-column property="created" align="center" label="评论时间" width="180" />

      <el-table-column fixed="right" align="center" label="操作" width="260">
        <template slot-scope="scope">
          <el-button v-if="scope.row.status === '0'" plain round size="mini" @click="auditClick(scope.row.commentId)">{{ $t('table.examine') }}</el-button>
          <el-button plain round size="mini" @click="viewReply(scope.row.commentId)">{{ $t('table.viewReply') }}</el-button>
          <el-button type="danger" plain round size="mini" @click="handleDel(scope.row.commentId)">{{ $t('table.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

    <el-dialog :title="$t('table.examine')" :visible.sync="dialogVisible">
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

    <el-dialog title="置顶" :visible.sync="topDialogVisible">
      <div>
        <el-form ref="filterTop" :rules="filterTopRules" :model="filterTop" label-width="100px">
          <el-form-item style="display:none" label="id" prop="commentId">
            <el-input v-model="filterTop.commentId" />
          </el-form-item>
          <el-form-item label="置顶位置" prop="sort">
            <el-input v-model.trim="filterTop.sort" />
            <div class="red">取消置顶位置请填写0</div>
          </el-form-item>
        </el-form>

        <div slot="footer" class="dialog-footer text-center">
          <el-button @click="topDialogVisible = false">
            {{ $t('table.cancel') }}
          </el-button>
          <el-button type="primary" @click="handleSortCommit">
            {{ $t('table.confirm') }}
          </el-button>
        </div>
      </div>
    </el-dialog>

    <ReplyList v-if="isShow" :is-show="isShow" :comment-id="commentId" @closeShowDialog="closeShowDialog" />
  </div>
</template>

<script>
import { statusType, status, getVal } from '@/utils/sys'
import { commentList, dealComment } from '@/api/member'
import Pagination from '@/components/Pagination'
import ReplyList from './components/ReplyList'

export default {
  components: { Pagination, ReplyList },
  filters: {
    getStatusType(index) {
      return getVal(index, statusType())
    }
  },
  data() {
    return {
      pickerOptions: {
        disabledDate(time) {
          return time.getTime() > Date.now()
        },
        shortcuts: [{
          text: '今天',
          onClick(picker) {
            picker.$emit('pick', new Date())
          }
        }, {
          text: '昨天',
          onClick(picker) {
            const date = new Date()
            date.setTime(date.getTime() - 3600 * 1000 * 24)
            picker.$emit('pick', date)
          }
        }, {
          text: '一周前',
          onClick(picker) {
            const date = new Date()
            date.setTime(date.getTime() - 3600 * 1000 * 24 * 7)
            picker.$emit('pick', date)
          }
        }]
      },
      typeList: statusType(),
      statusList: status(),
      form: {
        username: '',
        mobile: '',
        status: '',
        isHot: '',
        beginDate: '',
        endDate: ''
      },
      filter: {
        commentId: '',
        status: '1'
      },
      filterTop: {
        commentId: '',
        sort: ''
      },
      filterTopRules: {
        sort: [{ required: true, message: '请填写置顶位置', trigger: 'blur' }]
      },
      list: [],
      total: 0,
      dialogVisible: false,
      topDialogVisible: false,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      },
      commentId: '',
      isShow: false
    }
  },
  created() {
    this.getList()
  },
  methods: {
    // 置顶
    topClick(commentId, sort) {
      this.topDialogVisible = true

      this.$nextTick(() => {
        this.filterTop.commentId = commentId
        this.filterTop.sort = sort > 0 ? sort : ''
      })
    },
    // 提交
    handleSortCommit() {
      this.$refs.filterTop.validate((valid) => {
        if (!valid) return false
        this.handleChange(this.filterTop.commentId, this.filterTop.sort, 3)
        this.topDialogVisible = false
      })
    },
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
      this.listLoading = true
      this.listQuery = Object.assign(this.listQuery, this.form)
      commentList(this.listQuery).then(response => {
        this.list = response.data.list
        this.total = parseInt(response.data.total)
        this.listLoading = false
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
    // 查看回复
    viewReply(commentId) {
      this.commentId = commentId
      this.isShow = true
    },
    // 关闭回复
    closeShowDialog() {
      this.isShow = false
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

  .sort-edit {
    color: #1890ff;
    margin-left: 10px;
    cursor: pointer;
  }

  .red {
    color: #ff0000;
  }

  .text-left {
    text-align: left;
  }

  .risk-tip {
    color: #ff0000;
    font-weight: bold;
  }
</style>
