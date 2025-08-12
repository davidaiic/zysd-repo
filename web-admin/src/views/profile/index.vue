<template>
  <div class="app-container">
    <div v-if="user">
      <el-row :gutter="20">
        <el-col :span="12" :xs="24">
          <user-card :user="user" />
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import UserCard from './components/UserCard'

export default {
  name: 'Profile',
  components: { UserCard },
  data() {
    return {
      user: {}
    }
  },
  computed: {
    ...mapGetters([
      'username',
      'avatar',
      'roles',
      'mobile',
      'roleNames'
    ])
  },
  created() {
    this.getUser()
  },
  methods: {
    getUser() {
      this.user = {
        username: this.username,
        role: this.roles.join(' | '),
        roleName: this.roleNames.join(' | '),
        mobile: this.mobile,
        avatar: this.avatar
      }
    }
  }
}
</script>
