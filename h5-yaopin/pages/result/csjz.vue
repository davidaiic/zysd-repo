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
        this.getHeight()
        this.content = { goodsId: query.goodsId, serverId: query.serverId }
        console.log(this.content)
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
