<template>
  <div class="app-container">
    <!-- 条件筛选 -->
    <el-form ref="form" :inline="true" :model="form" size="small">
      <el-form-item label="菜单分类" prop="menuName">
        <el-input v-model="form.menuName" placeholder="请输入菜单分类" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="权限名称" prop="name">
        <el-input v-model="form.name" placeholder="请输入权限名称" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item label="路由" prop="route">
        <el-input v-model="form.route" placeholder="请输入路由" @keyup.enter.native="handleSearch" />
      </el-form-item>
      <el-form-item>
        <el-button @click="resetForm('form')">{{ $t('table.reset') }}</el-button>
        <el-button type="primary" icon="el-icon-search" @click="handleSearch">{{ $t('table.search') }}</el-button>
        <el-button type="primary" icon="el-icon-plus" @click="handleAdd('1')">{{ $t('table.add') }}</el-button>
      </el-form-item>
    </el-form>

    <div style="margin-bottom: 20px;">注意: <i style="color:#42b983" class="el-icon-menu" />表示是菜单 </div>

    <el-table
      ref="multipleTable"
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      default-expand-all
      row-key="perId"
      :tree-props="{children: 'children'}"
      style="width: 100%"
    >
      <el-table-column align="center" label="权限名称">
        <template slot-scope="scope">
          <span>{{ scope.row.name }} <i v-if=" scope.row.isMenu === '1'" style="color:#42b983" class="el-icon-menu" /></span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="菜单分类">
        <template slot-scope="scope">
          <span>{{ scope.row.menuName }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="路由">
        <template slot-scope="scope">
          <span>{{ scope.row.route }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="是否是菜单">
        <template slot-scope="scope">
          <span>{{ scope.row.isMenu === '1' ? '是': '否' }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="icon">
        <template slot-scope="scope">
          <span>{{ scope.row.icon }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="排序">
        <template slot-scope="scope">
          <span>{{ scope.row.sort }}</span>
        </template>
      </el-table-column>

      <el-table-column align="center" label="创建时间">
        <template slot-scope="scope">
          <span>{{ scope.row.created }}</span>
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
          <el-form-item style="display:none" label="Id" prop="perId">
            <el-input v-model="filter.perId" />
          </el-form-item>
          <el-form-item label="菜单分类" prop="menuId">
            <el-select v-model="filter.menuId" :clearable="true" filterable placeholder="请选分类">
              <el-option v-for="item in menuList " :key="item.menuId" :label="item.menuName" :value="item.menuId" />
            </el-select>
          </el-form-item>
          <el-form-item label="权限名称" prop="name">
            <el-input v-model.trim="filter.name" />
          </el-form-item>
          <el-form-item label="路由" prop="route">
            <el-input v-model.trim="filter.route" />
          </el-form-item>
          <el-form-item label="图标" prop="icon">
            <el-row>
              <el-col :span="12">
                <el-input v-model.trim="filter.icon" />
              </el-col>
              <el-col :span="10" :offset="1">
                <el-tooltip class="item" effect="dark" content="从弹窗中点击复制然后粘贴" placement="right">
                  <el-button type="primary" icon="el-icon-setting" @click="handleIcon">设置</el-button>
                </el-tooltip>
              </el-col>
            </el-row>
          </el-form-item>
          <el-form-item label="是否是菜单" prop="isMenu">
            <el-switch v-model="filter.isMenu" />
          </el-form-item>
          <el-form-item label="排序" prop="sort">
            <el-input v-model.trim="filter.sort" />
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

    <el-dialog title="Icon设置" :visible.sync="iconDialogVisible">
      <my-icons />
      <div slot="footer" class="dialog-footer text-center">
        <el-button @click="iconDialogVisible = false">
          {{ $t('table.cancel') }}
        </el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { fetchList, deal, menuList } from '@/api/permission'
import Pagination from '@/components/Pagination'
import MyIcons from '@/components/Icons'
import { mapGetters } from 'vuex'

export default {
  components: { Pagination, MyIcons },
  data() {
    return {
      isAdd: true,
      form: {
        menuName: '',
        name: '',
        route: ''
      },
      filter: {
        perId: '',
        menuId: '',
        name: '',
        route: '',
        icon: '',
        isMenu: false,
        sort: ''
      },
      filterRules: {
        name: [{ required: true, message: '请输入权限名称', trigger: 'blur' }],
        route: [{ required: true, message: '请输入路由', trigger: 'blur' }]
      },
      menuList: [],
      list: [],
      total: 0,
      dialogVisible: false,
      iconDialogVisible: false,
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
    },
    ...mapGetters([
      'roles'
    ])
  },
  created() {
    this.getMenuList()
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
          this.filter.perId = row.perId
          this.filter.menuId = row.menuId === '0' ? '' : row.menuId
          this.filter.name = row.name
          this.filter.route = row.route
          this.filter.icon = row.icon
          this.filter.sort = row.sort
          this.filter.isMenu = row.isMenu === '1'
        }
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        this.filter.isMenu = this.filter.isMenu === true ? '1' : '0'
        const type = this.isAdd === true ? '1' : '2'
        deal({ type, ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.$store.dispatch('permission/generateRoutes', this.roles)
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
      fetchList(this.listQuery).then(response => {
        if (response.data.permissionList) {
          this.list = response.data.permissionList
          this.total = parseInt(response.data.total)
        }
        this.listLoading = false
      })
    },
    // icon弹窗
    handleIcon() {
      this.iconDialogVisible = true
    },
    // 获取菜单列表
    getMenuList() {
      menuList().then((response) => {
        this.menuList = response.data.menuList
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
