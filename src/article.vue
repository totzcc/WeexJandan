<template>
	<div class="container">
		<list>
			<cell v-for="item in datalist" @click="click" :item="item">
				<div class="item">
					<image resize="cover" :src='item.src' style="width: 250px;height: 150px; background-color: #e3e3e3;"></image>
					<div style="flex: 1;margin-left: 20px;">
						<text class="item-title font-small">{{item.title}}</text>
						<text class="item-author">{{item.author}}</text>
						<text class="item-summary">{{item.summary}}</text>
					</div>
				</div>
			</cell>
			<cell>
				<div class="item" style="align-items: center;justify-content: center;" @click="more">
					<text>更多有趣文章</text>
				</div>
			</cell>
		</list>
	</div>
</template>

<script>
	const browser = weex.requireModule('browser')
	const navigator = weex.requireModule('navigator')
	
	import config from './config'
	import jandan from './services/jandan'
	module.exports = {
		data(){
			return {
				datalist:[1,1,1,1,1,1,1],
				showLoading:'hide'
			}
		},
		computed:{
			loadingTips(){
				if(!this.datalist || this.datalist.length == 0){
					return '加载中...'
				}
				return this.showLoading == 'hide' ? '上拉加载更多' : '加载中...'
			}
		},
		created(){
			jandan.articleIndex().then(datalist=>{
				this.datalist = datalist
			})
		},
		methods:{
			onloading(){
				this.showLoading = 'show'
				setTimeout(()=>{
					this.showLoading = 'hide'
				},1000)
			},
			click(e){
				const item = e.target.attr.item
				if(item) {
					browser.browserWeb(item.href,true)
				}
			},
			more(){
				navigator.push({url:config.js('more.js')},()=>{})
			}
		}
	}
</script>

<style>
	.container{background-color: #f3f3f3;}
	.item{background-color: #ffffff;margin-top: 40px; padding: 20px;flex-direction: row;}
	.item-title{color: #dd3333;}
	.item-author{color: #999999; font-size: 24;}
	.item-summary{color: #333333; font-size: 26;}
	.loading{width: 750px; padding-top: 40px; padding-bottom: 40px; align-items: center;justify-content: center;}
</style>