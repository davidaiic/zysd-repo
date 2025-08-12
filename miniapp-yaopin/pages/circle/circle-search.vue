<template>
	<view>
		<view class="contents">
			<u-navbar v-if="!isH5" class="searchBars" :fixed="false" leftIcon=""  @leftClick="leftClick">
			    <view class="u-nav-slot" slot="left">识药查真伪</view>
			</u-navbar>
		</view>
		<CircleList :navSelect="nav_select" :scrollViewheightProp="scrollViewheight" :readonly="false" :filterInfo="filter_info" :defaultWord="keyword" />
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
        return {
            keyword: '',
			nav_select:1,
			filter_info:{
				labelId:'',
				sortId:''
			}
			
        }
    },
    onLoad(option) {
		this.filter_info = this.$store.state.concatCircle.filter_info
		
		// console.log(this.circleTab)
		this.nav_select = this.circleTab
        this.keyword = option.keyword || ''
    },
    methods: {
		
    },
	
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
