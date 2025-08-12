<template>
<view class="main-box">
	<view class="item" v-for="(item,index) in lists" :key="index">
		{{item.name}}
	</view>
</view>
</template>

<script>
export default {
    data() {
        return {
			and_lists:[
				{
					name:'设置中心：隐私政策',
					path:'/pages/mine/yszy'
				},
				{
					name:'第三方信息共享',
					path:'/pages/mine/threeInfo'
				},
				{
					name:'个人信息收集',
					path:'/pages/mine/yhxy'
				}
			]
        };
    },
    onLoad(option) {
		
    },
	onShow() {
		// #ifdef H5
		document.title = 'app专有界面'
		//#endif
	},
    mounted() {
    },
    methods: {
        tqwz() {
            uni.navigateTo({
                url: `/pages/sbjg/tqwz/tqwz?keywords=${encodeURIComponent(JSON.stringify(this.keywords))}`
            })
        },
    },
};
</script>

<style>
</style>