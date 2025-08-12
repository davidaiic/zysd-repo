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
            content: {}
        }
    },
    onLoad(query) {
        this.getHeight()
        this.content = { goodsId: query.goodsId, serverId: query.serverId }


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
