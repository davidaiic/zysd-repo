<template>
	<web-view :src="webUrl"></web-view>
</template>

<script>
	export default {
		data() {
			return {
				webUrl: ''
			}
		},
		onLoad(item) {
			this.webUrl = decodeURIComponent(item.webUrl)
		},
		methods: {
			
		}
	}
</script>

<style>

</style>
