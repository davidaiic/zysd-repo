<template>
  <div class="app-container">
    <el-table
      ref="multipleTable"
      v-loading="listLoading"
      :data="list"
      border
      fit
      highlight-current-row
      style="width: 100%"
    >
      <el-table-column property="name" align="center" label="名称" />

      <el-table-column property="keyword" align="center" label="关键字" />

      <el-table-column align="center" label="内容">
        <template slot-scope="scope">
          <span v-if="scope.row.keyword === 'kefu_avatar'" class="image-left">
            <el-upload
              class="avatar-uploader"
              :action="uploadUrl"
              :data="{ type: 'avatar' }"
              :show-file-list="false"
              :on-success="handleSuccess"
              :on-error="handleError"
            >
              <img :src="scope.row.value" class="avatar" alt="">
            </el-upload>
          </span>
          <span v-else-if="scope.row.keyword === 'kefu_qrcode'" class="image-left">
            <el-upload
              class="avatar-uploader"
              :action="uploadUrl"
              :data="{ type: 'qrcode' }"
              :show-file-list="false"
              :on-success="handleQrCodeSuccess"
              :on-error="handleError"
            >
              <img :src="scope.row.value" class="avatar" alt="">
            </el-upload>
          </span>
          <span v-if="scope.row.keyword === 'contact_avatar'" class="image-left">
            <el-upload
              class="avatar-uploader"
              :action="uploadUrl"
              :data="{ type: 'avatar' }"
              :show-file-list="false"
              :on-success="handleContactAvatarSuccess"
              :on-error="handleError"
            >
              <img :src="scope.row.value" class="avatar" alt="">
            </el-upload>
          </span>
          <span v-else-if="scope.row.keyword === 'contact_qrcode'" class="image-left">
            <el-upload
              class="avatar-uploader"
              :action="uploadUrl"
              :data="{ type: 'qrcode' }"
              :show-file-list="false"
              :on-success="handleContactQrCodeSuccess"
              :on-error="handleError"
            >
              <img :src="scope.row.value" class="avatar" alt="">
            </el-upload>
          </span>
          <span v-else-if="scope.row.keyword === 'contact_mobile_icon'" class="image-left">
            <el-upload
              class="avatar-uploader"
              :action="uploadUrl"
              :data="{ type: 'icon' }"
              :show-file-list="false"
              :on-success="handleContactMobileIconSuccess"
              :on-error="handleError"
            >
              <img :src="scope.row.value" class="avatar" alt="">
            </el-upload>
          </span>
          <span v-else-if="scope.row.keyword === 'download_qrcode'" class="image-left">
            <el-upload
              class="avatar-uploader"
              :action="uploadUrl"
              :data="{ type: 'qrcode' }"
              :show-file-list="false"
              :on-success="handleDownloadQrcodeSuccess"
              :on-error="handleError"
            >
              <img :src="scope.row.value" class="avatar" alt="">
            </el-upload>
          </span>
          <div v-else-if="scope.row.keyword === 'solution_text'">
            <Tinymce ref="editor" v-model="scope.row.value" :height="200" />
            <div class="button-left">
              <el-button type="primary" @click="handleData(scope.row.keyword,scope.row.value)">{{ $t('table.save') }}</el-button>
            </div>
          </div>
          <span v-else-if="scope.row.keyword === 'search_tip'">
            <el-input v-model="scope.row.value" type="textarea" @change="handleData(scope.row.keyword,scope.row.value)" />
          </span>
          <span v-else>
            <el-input v-model="scope.row.value" @change="handleData(scope.row.keyword,scope.row.value)" />
          </span>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
import { commonSetting, dealCommonSetting } from '@/api/system'
import Tinymce from '@/components/Tinymce'

export default {
  components: { Tinymce },
  data() {
    return {
      list: [],
      listLoading: true,
      uploadUrl: ''
    }
  },
  created() {
    this.uploadUrl = process.env.VUE_APP_UPLOAD_URL
    this.getList()
  },
  methods: {
    // 搜索
    getList() {
      this.listLoading = true
      commonSetting().then(response => {
        this.list = response.data.list
        this.listLoading = false
      })
    },
    // 改变内容
    handleData(keyword, value) {
      dealCommonSetting({ keyword, value }).then(response => {
        this.$message.success(this.$t('msg.success'))
        this.getList()
      })
    },
    handleSuccess(response) {
      if (response.code === 200) {
        dealCommonSetting({ keyword: 'kefu_avatar', value: response.data.url }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      } else {
        this.$message.error(response.msg)
      }
    },
    handleQrCodeSuccess(response) {
      if (response.code === 200) {
        dealCommonSetting({ keyword: 'kefu_qrcode', value: response.data.url }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      } else {
        this.$message.error(response.msg)
      }
    },
    handleContactAvatarSuccess(response) {
      if (response.code === 200) {
        dealCommonSetting({ keyword: 'contact_avatar', value: response.data.url }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      } else {
        this.$message.error(response.msg)
      }
    },
    handleContactQrCodeSuccess(response) {
      if (response.code === 200) {
        dealCommonSetting({ keyword: 'contact_qrcode', value: response.data.url }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      } else {
        this.$message.error(response.msg)
      }
    },
    handleContactMobileIconSuccess(response) {
      if (response.code === 200) {
        dealCommonSetting({ keyword: 'contact_mobile_icon', value: response.data.url }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
      } else {
        this.$message.error(response.msg)
      }
    },
    handleDownloadQrcodeSuccess(response) {
      if (response.code === 200) {
        dealCommonSetting({ keyword: 'download_qrcode', value: response.data.url }).then(response => {
          this.$message.success(this.$t('msg.success'))
          this.getList()
        })
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

  .image-left {
    text-align: left;
  }

  .button-left {
    text-align: left;
    margin: 20px 0;
  }
</style>

<style>
  .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }

  .avatar-uploader .el-upload:hover {
    border-color: #409EFF;
  }

  .avatar {
    width: 150px;
    height: 150px;
    display: block;
    border-radius: 6px;
  }
</style>
