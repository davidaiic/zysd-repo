<template>
  <div class="app-container">
    <aside>
      注意: <i style="color:#42b983" class="el-icon-menu" />表示是菜单
    </aside>

    <el-table
      v-loading="listLoading"
      :data="list"
      border
      style="width: 100%"
    >
      <el-table-column prop="menuType" label="菜单分类" width="180">
        <template slot-scope="scope">
          <el-checkbox-group v-model="checkList">
            <el-checkbox :label="scope.row.perId">{{ scope.row.name }}
              <i v-if="scope.row.isMenu === 1" style="color:#42b983" class="el-icon-menu" />
            </el-checkbox>
          </el-checkbox-group>
        </template>
      </el-table-column>

      <el-table-column label="权限名称">
        <template slot-scope="scope">
          <el-checkbox-group v-model="checkList">
            <el-checkbox v-for="menu in scope.row.menuList" :key="menu.perId" :label="menu.perId">{{ menu.name }}
              <i v-if="menu.isMenu === 1" style="color:#42b983" class="el-icon-menu" />
            </el-checkbox>
          </el-checkbox-group>
        </template>
      </el-table-column>
    </el-table>

    <div style="margin-top:20px" class="text-center">
      <el-button type="primary" @click="handleCommit">{{ $t('table.confirm') }}</el-button>
    </div>
  </div>
</template>

<script>
import { fetchRoleSettingList, dealRoleSetting } from '@/api/permission'

export default {
  data() {
    return {
      checkList: ['1', '2', '3'],
      roleId: '',
      list: [],
      listLoading: true
    }
  },
  created() {
    this.roleId = this.$route.params.id
    this.getList()
  },
  methods: {
    // 提交
    handleCommit() {
      const perIdList = JSON.stringify(this.checkList)
      dealRoleSetting({ perIdList, roleId: this.roleId }).then(response => {
        this.$message.success(this.$t('msg.success'))
        this.getList()
      })
    },
    // 获取数据
    getList() {
      this.listLoading = true
      fetchRoleSettingList({ roleId: this.roleId }).then(response => {
        this.list = response.data.deployList
        this.checkList = response.data.checkList
        this.listLoading = false
      })
    }
  }
}
</script>
