import request from '@/utils/request'

export function uploadImg(data) {
  return request({
    url: process.env.VUE_APP_UPLOAD_URL,
    method: 'post',
    data
  })
}
