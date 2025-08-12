<!-- 附件上传组件 -->
<template>
	<view>
		<u-upload multiple ref="uUpload" name="curList" :maxSize="maxSize" :maxCount="maxCount" :fileList="curList"
			:width="width" :height="height" @afterRead="afterRead" @delete="uploadRemove" @error="errorPut"
			:deletable="true">
			<!-- #ifdef H5 -->
			<view class="slot-btn" :style="{ width: width, height: height }" hover-class="slot-btn__hover"
				hover-stay-time="150" @click.stop="selectPhoto">
				<u-icon name="plus" color="#999999" size="18"></u-icon>
				<view class="slot-btn_place" v-if="placeHolder">{{ placeHolder }}</view>
			</view>
			<!-- #endif -->
			<!-- #ifndef H5 -->
			<view class="slot-btn" :style="{ width: width, height: height }" hover-class="slot-btn__hover"
				hover-stay-time="150">
				<u-icon name="plus" color="#999999" size="18"></u-icon>
				<view class="slot-btn_place" v-if="placeHolder">{{ placeHolder }}</view>
			</view>
			<!-- #endif -->
		</u-upload>
	</view>
</template>

<script>
import urlConfig from '@/utils/config.js';
import { bridgrCall } from '../../utils/bridge';
export default {
	name: 'e-upload',
	props: {
		maximum: {
			type: Number,
			default: () => 9
		},
		value: {
			type: Array,
			default: () => []
		},
		andrFile: {
			type: Boolean,
			default: () => true
		},
		maxSize: {
			type: String,
			default: () => '52428800'
		},
		maxCount: {
			type: [Number, String],
			default: () => 5
		},
		action: {
			type: String,
			default: () => `${urlConfig}/plugin/upload`
		},
		isShowInvoice: {
			type: Boolean,
			default: () => false
		},
		placeHolder: {
			type: String,
			default: () => ``
		},
		width: {
			type: String,
			default: `150rpx`
		},
		height: {
			type: String,
			default: `150rpx`
		}
	},
	computed: {
		curList: {
			get() {
				return this.value;
			},
			set(v) {
				return v;
			}
		}
	},
	data() {
		return {
			isBridge: false,
			uploadHeader: {
				Authorization: `Bearer ${uni.getStorageSync('token')}`
			}
		};
	},
	methods: {
		// 错误提示
		errorPut(err) {
			// setTimeout(() => {
			// 	if (err) {
			// 		if (err.errMsg === 'chooseImage:fail User cancelled') {
			// 			console.log('用户取消');
			// 		}
			// 		if (err.errMsg === 'chooseImage:fail No Permission') {
			// 			if (err.errCode == 11) {
			// 				uni.showToast({
			// 					title: '相机权限没有开启',
			// 					duration: 1500,
			// 					icon: 'none'
			// 				});
			// 			}
			// 			if (err.errCode == 12) {
			// 				uni.showToast({
			// 					title: '相册权限没有开启',
			// 					duration: 1500,
			// 					icon: 'none'
			// 				});
			// 			}
			// 		}
			// 	}
			// }, 500);
		},
		/*
		附件移除
		 name为通过props传递的index参数
		 */
		uploadRemove(event) {
			this[`${event.name}`].splice(event.index, 1);
			this.$emit('input', this[`${event.name}`]);
		},
		/*
		 上传成功
		 data为服务器返回的数据
		 name为通过props传递的index参数
		 */
		afterRead(event) {
			// 新增图片
			// 当设置 mutiple 为 true 时, file 为数组格式，否则为对象格式
			let lists = [].concat(event.file);
			console.log(lists[0])
			let fileListLen = this[`${event.name}`].length;
			for (let i = 0; i < lists.length; i++) {
				this.uploadFilePromise(lists[i].thumb).then(result => {
					if (result && result.data) {
						this[`${event.name}`].push({
							status: 'success',
							message: '',
							url: result.data.url
						});
						this.$emit('input', this[`${event.name}`]);
					}
				});
			}
		},
		uploadFilePromise(url) {
			let that = this;
			return new Promise((resolve, reject) => {
				uni.uploadFile({
					url: that.action, // 仅为示例，非真实的接口地址
					filePath: url,
					header: that.uploadHeader,
					name: 'file',
					success: res => {
						if (res.data) {
							resolve(JSON.parse(res.data));
						} else {
							resolve();
						}
					},
					fail: error => {
						reject();
					}
				});
			});
		},
		selectPhoto(e) {
			// #ifdef H5
			const that = this;
			bridgrCall.getPhoto({
				"max": that.maxCount ? that.maxCount.toString() : "1"
			}).then((res) => {
				const data = res.data || []
				data.filter(_ => _).map(_ => that.curList.push({
					url: _,
					message: "",
					status: "success"
				}))
				that.$emit('input', this.curList);
			})
			//#endif

		}
	}
};
</script>

<style lang="scss" scoped>
.slot-btn {
	width: 156rpx;
	height: 156rpx;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	border: 2rpx solid #eff6ff;

	.slot-btn_place {
		color: #999999;
		font-size: 24rpx;
		margin-top: 10rpx
	}
}
</style>
