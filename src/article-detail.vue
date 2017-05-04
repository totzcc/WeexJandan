<template>
	<div class="container">
		<web style="flex: 1;" :src="src"></web>
		<div @click="naviBarLeftItemClick" style="position: fixed; left: 25; top: 65;">
			<div style="width: 80px;height: 80px; border-radius: 80px; position: absolute; left: 0; top: 0;  background-color: #000000; opacity: 0.1;"></div>
			<image :src="config.image('back.png')" style=" width: 50px;height: 50px; margin-left: 15px; margin-top: 15px;"></image>
		</div>
		<div @click="seeComments" style="position: fixed; right: 25; top: 65;">
			<div style="width: 80px;height: 80px; border-radius: 80px; position: absolute; left: 0; top: 0;  background-color: #000000; opacity: 0.1;"></div>
			<image :src="config.image('comment.png')" style=" width: 50px;height: 50px; margin-left: 15px; margin-top: 15px;"></image>
			<text style="position: absolute; right: -20; top: 0; font-size: 24px; color: #666666;">{{detail.comments || 0}}</text>
		</div>
	</div>
</template>
<style>
</style>
<script>
	const navigator = weex.requireModule('navigator')
	const storage = weex.requireModule('storage')
	const modal = weex.requireModule('modal')
	import config from './config'
	module.exports = {
		data(){
			return {
				config:config,
				src:"",
				detail:{
					url:''
				}
			}
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		created(){
			storage.getItem('comment-detail',(ret)=>{
				this.detail = JSON.parse(ret.data)
				this.src = "http://localhost:9090/?url=" + this.detail.href
				console.log(JSON.stringify(this.detail))
			})
		},
		methods:{
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			seeComments(e){
				navigator.push({url:config.js('comments.js')},()=>{})
			},
		}
	}
</script>