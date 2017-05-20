<template>
	<div class="container">
		<web style="flex: 1;" :src="src"></web>
		<div @click="naviBarLeftItemClick" style="position: fixed; left: 25; top: 65;">
			<div style="width: 80px; height: 80px;border-radius: 80px;background-color: #000000; opacity: 0.1;"></div>
			<image :src="config.image('back.png')" style=" position: absolute; width: 50px;height: 50px; left: 15px; top: 15px;"></image>
		</div>
		<div @click="seeComments" style="position: fixed; right: 40; top: 65;">
			<div style="width: 80px; height: 80px;border-radius: 80px;background-color: #000000; opacity: 0.1;"></div>
			<image :src="config.image('comment.png')" style=" position: absolute; width: 50px;height: 50px; left: 15px; top: 15px;"></image>
			<text style="position: absolute; right: 0; top: 0; font-size: 24px; color: #666666;">{{detail.comments}}</text>
		</div>
		<div @click="like" style="position: fixed; left: 25; bottom: 65;">
			<div style="width: 80px; height: 80px;border-radius: 80px;background-color: #000000; opacity: 0.1;"></div>
			<image :src="likePng" style=" position: absolute; width: 50px;height: 50px; left: 15px; top: 15px;"></image>
		</div>
		
		<div @click="more" style="position: fixed; right: 40; bottom: 65;">
			<div style="width: 80px; height: 80px;border-radius: 80px;background-color: #000000; opacity: 0.1;"></div>
			<image :src="config.image('share.png')" style=" position: absolute; width: 50px;height: 50px; left: 15px; top: 15px;"></image>
		</div>
	</div>
</template>
<style>
</style>
<script>
	const navigator = weex.requireModule('navigator')
	const storage = weex.requireModule('storage')
	const modal = weex.requireModule('modal')
	const share = weex.requireModule('share')
	import config from './config'
	import favorite from './services/jandan-favorite'
	module.exports = {
		data(){
			return {
				config:config,
				src:"http://localhost:9090/",
				likePng:config.image('like-gray.png'),
				detail:{
					href:'',
					title:'',
					isLike:false
				}
			}
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		created(){
			storage.getItem('article-detail',(ret)=>{
				this.detail = JSON.parse(ret.data)
				this.src = "http://localhost:9090/?url=" + this.detail.href
				this.detail.isLike = favorite.isLike(this.detail.href)
				this.like()
			})
			config.event('article-detail', '文章详情')
		},
		methods:{
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			seeComments(e){
				navigator.push({url:config.js('comments.js')},()=>{})
			},
			more(e){
				share.share(this.detail.href,this.detail.title)
				console.log('share')
			},
			like(e){
				if(e) {
					this.detail.isLike = favorite.toggleLike(this.detail.href, this.detail.title, this.detail.img)
				}
				if(this.detail.isLike == true) {
					this.likePng = config.image('like.png')
				} else {
					this.likePng = config.image('like-gray.png')
				}
			},
		}
	}
</script>