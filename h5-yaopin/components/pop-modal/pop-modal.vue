<!-- 弹窗 -->
<template>
    <u-popup :show="show" mode="center" @close="close" round="16rpx" :customStyle="{ width: '80%' }" closeOnClickOverlay
        :safeAreaInsetBottom="false">
        <view class="title-content">
            <view class="title">{{ title }}</view>
            <u-icon name="close" color="#E0E0E0" size="20" @click="close"></u-icon>
        </view>
        <slot></slot>
        <view class="foot">
            <u-button v-if="cancleText" :customStyle="{ flex: 1 }" shape="circle" color="#E0E0E0" @click="close">{{
                cancleText
            }}</u-button>
            <u-button v-if="confirmText" :customStyle="{ flex: 1 }" shape="circle" color="#0FC8AC" @click="confirm">{{
                confirmText
            }}</u-button>
        </view>
    </u-popup>
</template>

<script>
export default {
    props: {
        title: {
            type: String,
            default: '提示'
        },
        confirmText: {
            type: String,
            default: ''
        },
        cancleText: {
            type: String,
            default: ''
        },
        show: {
            type: Boolean,
            default: false
        }

    },
    data() {
        return {}
    },
    watch: {
        show(newValue, oldValue) {
        }
    },
    methods: {
        close() {
            // this.show = false
            this.$emit('close')
        },
        confirm() {
            this.$emit('confirm')
        }
    }
}
</script>

<style lang="scss" scoped>
.title-content {
    display: flex;
    flex-direction: row;
    padding: 30rpx;
    align-items: center;
    justify-content: center;

    .title {
        flex: 1;
        text-align: center;
        font-size: 32rpx;
        line-height: 44rpx;
        margin-left: 40rpx;
    }
}

.title {
    flex: 1;
}

.foot {
    display: flex;
    flex-direction: row;
    gap: 20rpx;
    margin: 20rpx;
}
</style>
