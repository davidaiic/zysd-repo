<template>
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
      <el-form-item label="查询时间" prop="beginDate">
        <el-date-picker v-model="form.beginDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item prop="endDate">
        <el-date-picker v-model="form.endDate" format="yyyy-MM-dd" value-format="yyyy-MM-dd" align="right" type="date" :picker-options="pickerOptions" @keyup.enter.native="handleSearch" />
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
      <el-table-column property="photoId" align="center" label="id" width="80" />

      <el-table-column align="center" label="正面" width="120">
        <template slot-scope="scope">
          <span>
            <el-image
              style="width: 100px; height: 100px"
              :src="scope.row.positive"
              :preview-src-list="scope.row.positiveList"
            />
          </span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="左侧面" width="120">
        <template slot-scope="scope">
          <span>
            <el-image
              style="width: 100px; height: 100px"
              :src="scope.row.leftSide"
              :preview-src-list="scope.row.leftSideList"
            />
          </span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="右侧面" width="120">
        <template slot-scope="scope">
          <span>
            <el-image
              style="width: 100px; height: 100px"
              :src="scope.row.rightSide"
              :preview-src-list="scope.row.rightSideList"
            />
          </span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="背面" width="120">
        <template slot-scope="scope">
          <span>
            <el-image
              style="width: 100px; height: 100px"
              :src="scope.row.back"
              :preview-src-list="scope.row.backList"
            />
          </span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="其余照片" width="120">
        <template slot-scope="scope">
          <div v-for="(item, index) in scope.row.otherList" :key="index">
            <el-image
              style="width: 100px; height: 100px"
              :src="item"
              :preview-src-list="scope.row.otherList"
            />
          </div>
        </template>
      </el-table-column>

      <el-table-column property="mobile" align="center" label="手机号" />

      <el-table-column property="username" align="center" label="用户名" />

      <el-table-column property="created" align="center" label="查询时间" />

      <el-table-column align="center" label="状态">
        <template slot-scope="scope">
          <span>{{ scope.row.status | getCheckType }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="是否发送短信">
        <template slot-scope="scope">
          <span>{{ scope.row.isSms | getStatusType }}</span>
        </template>
      </el-table-column>

      <el-table-column property="goodsName" align="center" label="药品名称" />

      <el-table-column property="companyName" align="center" label="药厂名称" />

      <el-table-column align="center" label="操作">
        <template slot-scope="scope">
          <el-button v-if="scope.row.status === '0'" plain round size="mini" @click="auditClick(scope.row.photoId)">{{ $t('table.check') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination v-show="total>0" :total="total" :page.sync="listQuery.page" :limit.sync="listQuery.limit" @pagination="getList" />

    <el-dialog :title="$t('table.check')" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="100px">
          <el-form-item style="display:none" label="id" prop="photoId">
            <el-input v-model="filter.photoId" />
          </el-form-item>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="filter.status">
              <el-radio label="1">核查通过</el-radio>
              <el-radio label="2">核查失败</el-radio>
            </el-radio-group>
          </el-form-item>
          <el-form-item v-if="filter.status === '1'" label="药品名称" prop="goodsName">
            <el-input v-model="filter.goodsName" />
          </el-form-item>
          <el-form-item v-if="filter.status === '1'" label="药厂名称" prop="companyName">
            <el-input v-model="filter.companyName" />
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

    <el-dialog :title="$t('table.smsTip')" :visible.sync="smsDialogVisible">
      <div>
        <el-form ref="filterSms" :rules="filterSmsRules" :model="filterSms" label-width="100px">
          <el-form-item style="display:none" label="手机号" prop="mobile">
            <el-input v-model="filterSms.mobile" />
          </el-form-item>
          <el-form-item label="短信内容" prop="smsText">
            <el-input v-model="filterSms.smsText" type="textarea" :rows="6" />
          </el-form-item>
        </el-form>

        <div slot="footer" class="dialog-footer text-center">
          <el-button @click="smsDialogVisible = false">
            {{ $t('table.cancel') }}
          </el-button>
          <el-button type="primary" @click="handleSmsCommit">
            {{ $t('table.confirm') }}
          </el-button>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { checkType, status, getVal } from '@/utils/sys'
import { manualSearchList, checkManual, smsTip } from '@/api/member'
import Pagination from '@/components/Pagination'

export default {
  components: { Pagination },
  filters: {
    getCheckType(index) {
      return getVal(index, checkType())
    },
    getStatusType(index) {
      return getVal(index, status())
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
      typeList: checkType(),
      form: {
        username: '',
        mobile: '',
        status: '',
        beginDate: '',
        endDate: ''
      },
      filter: {
        photoId: '',
        status: '1',
        smsText: '',
        goodsName: '',
        companyName: ''
      },
      filterRules: {
        goodsName: [{ required: true, message: '请输入药品名称', trigger: 'blur' }],
        companyName: [{ required: true, message: '请输入药厂名称', trigger: 'blur' }]
      },
      filterSms: {
        mobile: '',
        smsText: ''
      },
      filterSmsRules: {
        smsText: [{ required: true, message: '请输入短信内容', trigger: 'blur' }]
      },
      list: [],
      total: 0,
      dialogVisible: false,
      smsDialogVisible: false,
      listLoading: true,
      listQuery: {
        page: 1,
        limit: 10
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
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
      manualSearchList(this.listQuery).then(response => {
        this.list = response.data.list
        this.total = parseInt(response.data.total)
        this.listLoading = false
      })
    },
    // 核查
    auditClick(photoId) {
      this.dialogVisible = true

      this.$nextTick(() => {
        this.filter.photoId = photoId
        this.filter.status = '1'
        this.filter.smsText = ''
        this.filter.goodsName = ''
        this.filter.companyName = ''
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        checkManual({ ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.dialogVisible = false
      })
    },
    // 短信提示
    smsClick(mobile) {
      this.smsDialogVisible = true

      this.$nextTick(() => {
        this.filterSms.mobile = mobile
        this.filterSms.smsText = ''
      })
    },
    // 发送短信
    handleSmsCommit() {
      this.$refs.filterSms.validate((valid) => {
        if (!valid) return false
        smsTip({ ...this.filterSms }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
        this.smsDialogVisible = false
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

  .mg-bottom10 {
    margin-bottom: 10px;
  }
</style>
