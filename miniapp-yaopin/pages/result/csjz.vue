<!--  -->
<template>
	<cxItem title="慈善救助" :content="content" />
		
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
        this.content = { goodsId: query.goodsId, serverId: 5 }
        console.log(this.content)
    },
	onShow(){
		// #ifdef H5
		document.title = '慈善救助'
		//#endif
	},
    methods: {
        getContent() {

        },
    }
}
</script>

<style lang="scss" scoped>
</style>
