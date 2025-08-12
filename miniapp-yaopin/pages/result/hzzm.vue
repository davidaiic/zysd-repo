<!--  -->
<template>
	<cxItem title="患者招募" :content="content" />
</template>

<script>
import cxItem from './cx-item.vue'
export default {
    components: {
        cxItem
    },
    data() {
        return {
            content: {},
			info: '',
        }
    },
    onLoad(query) {
        this.content = { goodsId: query.goodsId, serverId: 4}
    },
	onShow(){
		// #ifdef H5
		document.title = '患者招募'
		//#endif
	},
    methods: {
        getContent() {
			let params = {
			    ...this.content
			}
            goodsSubjectReq(params).then(res => {
                this.info = res.data.content
            })
        },
    }
}
</script>

<style lang="scss" scoped>
.content {
    padding: 40rpx 30rpx 30rpx;

}

.info {
    padding: 30rpx;

    img {
        width: auto;
        height: auto;
        max-width: 100%;
        max-height: 100%;
        margin: 0 auto;
    }
}
</style>
