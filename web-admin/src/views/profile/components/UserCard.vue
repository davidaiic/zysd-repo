<template>
  <el-card style="margin-bottom:20px;">
    <div slot="header" class="clearfix">
      <span>{{ $t('page.profile') }}</span>
    </div>

    <div class="user-profile">
      <div class="box-center">
        <pan-thumb :image="user.avatar ? user.avatar : 'https://wpimg.wallstcn.com/f778738c-e4f8-4870-b634-56703b4acafe.gif'" :height="'100px'" :width="'100px'" :hoverable="false">
          <div>您好</div>
          {{ user.username }}
        </pan-thumb>
      </div>
      <div class="box-center">
        <div class="user-name text-center">姓名：{{ user.username }}</div>
        <div class="user-name text-center" style="margin: 20px 0 10px;">角色：{{ user.roleName }}</div>
        <div class="user-role text-center text-muted">
          <i class="el-icon-user" /> <span>{{ user.role | uppercaseFirst }}</span>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <i class="el-icon-mobile-phone" /> <span>{{ user.mobile }}</span>
        </div>
        <div class="user-role text-center" style="margin-top: 5px;" @click="handleAdd"><span><el-link>修改密码</el-link></span></div>
      </div>
    </div>

    <el-dialog :title="title" :visible.sync="dialogVisible">
      <div>
        <el-form ref="filter" :rules="filterRules" :model="filter" label-width="100px">
          <el-form-item label="新密码" prop="password">
            <el-input v-model.trim="filter.password" type="password" />
          </el-form-item>
          <el-form-item label="确认新密码" prop="confirmPassword">
            <el-input v-model.trim="filter.confirmPassword" type="password" />
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
  </el-card>
</template>

<script>
import PanThumb from '@/components/PanThumb'
import { changePassword } from '@/api/user'

export default {
  components: { PanThumb },
  props: {
    user: {
      type: Object,
      default: () => {
        return {
          username: '',
          mobile: '',
          avatar: '',
          roles: '',
          roleNames: ''
        }
      }
    }
  },
  data() {
    return {
      filter: {
        password: '',
        confirmPassword: ''
      },
      filterRules: {
        password: [{ required: true, message: '请输入新密码', trigger: 'blur' }],
        confirmPassword: [{ required: true, message: '请输入确认新密码', trigger: 'blur' }]
      },
      dialogVisible: false
    }
  },
  computed: {
    title() {
      return '修改密码'
    }
  },
  methods: {
    handleAdd() {
      this.dialogVisible = true

      this.$nextTick(() => {
        this.resetForm('filter')
      })
    },
    // 提交
    handleCommit() {
      this.$refs.filter.validate((valid) => {
        if (!valid) return false
        changePassword({ ...this.filter }).then(response => {
          this.$message.success(this.$t('msg.success'))
        })
        this.dialogVisible = false
      })
    },
    // 重置
    resetForm(form) {
      this.$refs[form].resetFields()
    }
  }
}
</script>

<style lang="scss" scoped>
  $label-with:120px;
  .app-container{
    & >>> .el-dialog >>> .el-form-item__label{
      width:  $label-with
    }
  }

 .box-center {
   margin: 0 auto;
   display: table;
 }

 .text-muted {
   color: #777;
 }

 .user-profile {
   .user-name {
     font-weight: bold;
   }

   .box-center {
     padding-top: 10px;
   }

   .user-role {
     padding-top: 10px;
     font-weight: 400;
     font-size: 14px;
   }

   .box-social {
     padding-top: 30px;

     .el-table {
       border-top: 1px solid #dfe6ec;
     }
   }

   .user-follow {
     padding-top: 20px;
   }
 }
</style>
