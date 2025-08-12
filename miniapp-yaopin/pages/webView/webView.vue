<template>
	<web-view :src="webUrl"></web-view>
</template>

<script>
	let timer = ''
	export default {
		data() {
			return {
				webUrl: ''
			}
		},
		onLoad(options) {
			// console.log()
			if(options.title){
				this.setTitle(options.title)
			}
			this.webUrl = decodeURIComponent(options.webUrl)
			
		},
		onHide(){
			clearTimeout(timer)
		},
		methods: {
			setTitle(name){
				console.log(name)
				uni.setNavigationBarTitle({
					title:name
				})
				//以下代码可以解决以上问题，不依赖jq
				//放入回调函数中请自行取掉setTimeout
				// setTimeout(function(){ //利用iframe的onload事件刷新页面 
				// 	document.title = 'name'; 
				// 	var iframe = document.createElement('iframe'); 
				// 	iframe.style.visibility = 'hidden'; 
				// 	iframe.style.width = '1px'; 
				// 	iframe.style.height = '1px'; 
				// 	iframe.onload = function () { 
				// 		setTimeout(function () { 
				// 			document.body.removeChild(iframe); 
				// 		}, 0); 
				// 	}; 
				// 	document.body.appendChild(iframe); 
				// },0); 
			}
		}
	}
</script>

<style>

</style>
