<template>
	<list>
		<cell style="height: 40px;"></cell>
		<cell>
			<div style="align-items: center; justify-content: center; margin: 50px;">
				<image style="width: 200px; height: 200px; border-radius: 100px;" :src="config.image('icon.png')"></image>
				<text style="margin-top: 20px; color: #999999; font-size: 28;">v1.0.1</text>
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
</style>
<script>
	const browser = weex.requireModule('browser')
	const navigator = weex.requireModule('navigator')
	import config from './config'
	module.exports = {
		data(){
			return {
				cells:['我的收藏','反馈Bug & 和我联系'],
				config:config,
				right:config.image('right.png')
			}
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
				}
			}
		}
	}
</script>
