<template>
	<div style="align-items: center; justify-content: center;" @viewappear="viewappear">
		<text>Loadding...</text>
	</div>
</template>

<script>
	import config from './config'
	import jandan from './services/jandan'
	let navigator = weex.requireModule('navigator')
	let app = weex.requireModule('app')
	var firstVisit = true;
	export default {
		created(){
			app.getRecentNotification((res)=>{
				if(res && res.extraMap) {
					let href = res.extraMap.href;
					let title = res.extraMap.title;
					let target = res.extraMap.target;
					if(target == 'articleDetail') {
						setTimeout(()=>{
							jandan.toDetail({href:href})
						},1000)
					}
				} else {
					navigator.pop({},()=>{})
				}
			})
		},
		methods:{
			viewappear(){
				if(!firstVisit) {
					navigator.pop({},()=>{})
				}
				setTimeout(()=>{
					firstVisit = false;
				},500)
			}
		}
	}
</script>

<style>
</style>