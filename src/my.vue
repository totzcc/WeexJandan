<template>
	<list @viewappear="viewappear">
		<cell style="height: 40px;"></cell>
		<cell>
			<div style="align-items: center; justify-content: center; margin: 50px;">
				<image style="width: 200px; height: 200px; border-radius: 100px;" :src="config.image('icon.png')"></image>
				<text style="margin-top: 20px; color: #999999; font-size: 28;">v1.0.2</text>
				<div v-if="userInfoStatus == 1" style="margin-top: 10px; justify-content: center; align-items: center;" @click="setUserInfo">
					<text class="right-title">{{userInfo.author}}</text>
					<text class="right-title">{{userInfo.email}}</text>
				</div>
				<div style="margin-top: 20px;" v-if="userInfoStatus == 2" @click="setUserInfo">
					<text class="left-title">点击设置昵称</text>
				</div>
			</div>
		</cell>
		<cell v-for="(v,i) in cells">
			<div class="item" @click="click" :index="i">
				<div style="flex-direction: row; justify-content: space-between; align-items: center;">
					<text>{{v}}</text>
					<image :src="right" class="right"></image>
				</div>
			</div>
		</cell>
	</list>
</template>
<style>
	.item{height: 100px; padding: 40px; border-width: 1px; border-color: #f3f3f3; justify-content: center;}
	.right{width: 30px; height: 30px;}
	.left-title{font-size: 30px; color: #666666;}
	.right-title{font-size: 30px; color: #999999;}
</style>
<script>
	const browser = weex.requireModule('browser')
	const navigator = weex.requireModule('navigator')
	const modal = weex.requireModule('modal')
	import config from './config'
	import jandanComments from './services/jandan-comments'
	module.exports = {
		data(){
			return {
				cells:['我的收藏','反馈Bug & 和我联系','关于此 App'],
				config:config,
				userInfo:null,
				userInfoStatus:0,
				right:config.image('right.png')
			}
		},
		created(){
			this.viewappear()
		},
		methods:{
			click(e){
				switch(e.target.attr.index) {
					case 0:
						navigator.push({url:config.js('favorite.js')},()=>{})
					break;
					case 1:
						browser.browserWeb('http://m.weibo.cn/status/4105460950805404')
					break;
					case 2:
						modal.toast({message:'此 App 仅供学习交流，如有问题请联系我。',duration:1})
					break;
				}
			},
			setUserInfo(e){
				navigator.push({url:config.js('my-info.js')},()=>{})
			},
			viewappear(e){
				jandanComments.getUserInfo().then((userInfo)=>{
					this.userInfo = userInfo
					if(this.userInfo.author == "") {
						this.userInfoStatus = 2;
					} else {
						this.userInfoStatus = 1
					}
					console.log(this.userInfo)
				})
			}
		}
	}
</script>
