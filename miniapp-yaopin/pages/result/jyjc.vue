<!--  -->
<template>
    <cxItem title="基因检测" :content="content" />
</template>

<script>
import cxItem from './cx-item.vue'
export default {
    components: {
        cxItem
    },
    data() {
        return {
            content: {}
        }
    },
    onLoad(query) {
        this.content = { goodsId: query.goodsId, serverId: query.serverId }
    },
	onShow(){
		// #ifdef H5
		document.title = '基因检测'
		//#endif
	},
    methods: {
        getContent() {

        },
    }
}
</script>

<style lang="scss" scoped>
.content {
    padding: 40rpx 30rpx 30rpx;

}
</style>
