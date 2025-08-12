<template>
	<view>
		<view class="contents">
			<u-navbar v-if="!isH5" class="searchBars" :fixed="false" leftIcon=""  @leftClick="leftClick">
				<view class="u-nav-slot" slot="left">识药查真伪</view>
			</u-navbar>
		</view>
		<CircleList :navSelect="nav_select"  :scrollViewheightProp="scrollViewheight" from="maintab"/>
	</view>
</template>

<script>
import CircleList from './circle-list.vue';

import {mapGetters} from "vuex";
export default {
	computed: mapGetters(['circleTab']),
    components: {
        CircleList
    },
	data() { 
		return{
			nav_select:1,//1，评论，2，资讯
		}
	},
	onShow(){
		console.log()
		this.nav_select = this.circleTab
	},
	onLoad(options){
	},
    methods: {
		changeTab(status){
			this.$store.dispatch('ChangeCircleTab',status)
			this.nav_select = status
		}
    }
};
</script>
<style lang="scss">
page {
    overflow: hidden;
}
</style>
<style lang="scss" scoped>
	.contents{
		position: relative;
		z-index: 10076;
	}
</style>
