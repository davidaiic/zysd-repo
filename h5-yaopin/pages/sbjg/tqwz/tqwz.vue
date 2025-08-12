<!-- 提取文字 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="提取文字" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
        </view>
        <view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
            <view>提示：滑动选择搜索词</view>
            <view class="word-content" :style="{ maxHeight: scrollViewheight - 150 + 'px' }">
                <view class="word-item" :class="{ 'item-select': item.select }" v-for="(item, i) in keywords" :id="'k' + i"
                    :key="item.name" @click="selectItem(item)">
                    {{ item.name }}
                </view>
            </view>
        </view>
        <view class="bottomBtn">
            <view class="bt-content" @click="all">
                <u-image :src="$utils.getImgUrl('all_icon.png')" width="40rpx" height="40rpx" class="bt-img" />
                <text>全选</text>
            </view>
            <view class="bt-content" @click="copy">
                <u-image :src="$utils.getImgUrl('copy_sle_icon.png')" width="40rpx" height="40rpx" class="bt-img" />
                <text>复制</text>
            </view>
            <view class="bt-content" @click="search">
                <u-image :src="$utils.getImgUrl('search_sle_icon.png')" width="40rpx" height="40rpx" class="bt-img" />
                <text>搜索</text>
            </view>

        </view>
    </view>
</template>

<script>
export default {
    data() {
        return {
            keywords: [],
            startX: 0,
            startY: 0,
        }
    },
    conputed: {
        isAll() {
            return this.keywords.some(_ => !_.select)
        }
    },
    onLoad(option) {
        const words = decodeURIComponent(option.keywords) === 'undefined' ? [] : JSON.parse(decodeURIComponent(option.keywords))
        this.getHeight()
        console.log(words, 'lll')
        this.setKeyWords(words)
    },
    methods: {
        setKeyWords(words) {
            let list = []
            words.map(_ => {
                const wd = _.name.split('')
                list = [...list, ...wd]
            })
            const temp = Array.from(new Set(list))
            console.log(words, list)
            this.keywords = temp.map(_ => { return { name: _, select: false } })
        },
        selectItem(item) {
            this.$set(item, 'select', !item.select)
        },
        all() {
            const noall = this.keywords.some(_ => !_.select)
            if (noall) {
                this.keywords.map(_ => _.select = true)
            } else {
                this.keywords.map(_ => _.select = false)
            }
        },
        copy() {
            const word = this.keywords.filter(_ => _.select).map(_ => _.name).join('')
            if (!word) {
                uni, showToast({
                    title: '请先选择搜索词',
                    icon: 'none'
                })
                return
            }
            uni.setClipboardData({
                data: word,
                success() {
                    uni.showToast({
                        icon: 'none',
                        title: '复制成功'
                    })
                },
                fail() {
                    uni.showToast({
                        icon: 'none',
                        title: '复制失败'
                    })
                }
            })
        },
        search() {
            const word = this.keywords.filter(_ => _.select).map(_ => _.name).join('')
            if (!word) {
                uni, showToast({
                    title: '请先选择搜索词',
                    icon: 'none'
                })
                return
            }
            uni.navigateTo({
                url: `/pages/zzcx/ypcx?keyword=` + word
            })
        },
        touchstart(e) {
            console.log('touchstart', e)
            this.startX = parseInt(e.changedTouches[0].pageX)
            this.startY = parseInt(e.changedTouches[0].pageY)

        },
        touchend(e) {
            const y = parseInt(e.changedTouches[0].pageY)
            const x = parseInt(e.changedTouches[0].pageX)
            const yNum = parseInt((y - this.startY) / 40) || 1
            const xNum = parseInt((x - this.startX) / 40) || 1
            const n = parseInt((xNum * yNum))
            console.log(yNum, 'yNum')
            console.log(xNum, 'xNum')
            console.log(x, 'x')
            console.log(y, 'y')
            console.log(this.startY, 'this.startY')
            console.log(this.startY, 'this.startY')
            console.log(n, 'n')
            for (let i = 0; i < this.keywords.length; i++) {
                if (n > i) {
                    this.$set(this.keywords[i], 'select', true)
                }
            }

            console.log(e, 'end')

        }
    },

}
</script>

<style lang="scss" scoped>
.content {
    padding: 40rpx 30rpx 30rpx;

    .word-content {
        display: flex;
        flex-direction: row;
        align-items: flex-start;
        flex-wrap: wrap;
        margin-top: 30rpx;
        overflow: auto;
        gap: 15rpx;

        .word-item {
            width: 72rpx;
            height: 72rpx;
            background-color: #F2F3F5;
            border-radius: 4rpx;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
        }

        .item-select {
            background-color: #0FC8AC;
            color: #FFFFFF;
        }
    }
}

.bottomBtn {
    position: fixed;
    z-index: 2;
    width: calc(100% - 56rpx);
    left: 28rpx;
    bottom: 80rpx;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: space-around;

    .bt-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 40rpx;
        font-size: 28rpx;
        color: #0FC8AC;

    }
}
</style>
