<template>
	<div class="container">
		<list>
			<refresh class="refresh" @refresh="onrefresh" :display="showRefresh">
		      	<text class="indicator">{{refreshTips}}</text>
		    </refresh>
			<cell>
				<div style="align-items: center;justify-content: center; padding: 20px; background-color: #FFFFFF; margin-top: 44px;" @click="more">
					<text>更多有趣文章</text>
				</div>
			</cell>
			<cell v-for="item in datalist" @click="click" :item="item">
				<div class="item">
					<div style="flex-direction: row;">
						<image resize="cover" :src='item.src' style="width: 250px;height: 150px; background-color: #e3e3e3;"></image>
						<div style="flex: 1;margin-left: 20px;">
							<text class="font-small" v-bind:style="{'color' : item.isRead ? '#333333':'#dd3333'}">{{item.title}}</text>
							<text class="item-author">{{item.author}}</text>
							<text class="item-summary">{{item.summary}}</text>
						</div>
					</div>
					<div style="margin-top: 20px; height: 80px; border-top-width: 1;border-top-style: dashed; border-top-color: #e3e3e3; align-items: center; justify-content: center;  flex-direction: row; justify-content: flex-end;">
						<image class="agree" :src="config.image('agree-normal.png')"></image>
						<image class="agree" :src="config.image('agree-highlight.png')"></image>
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
<style>
	.agree{width: 50px; height: 50px;}
	.container{background-color: #f3f3f3;}
	.item{background-color: #ffffff;margin-top: 40px; padding: 20px; padding-bottom: 0px;}
	.item-author{color: #999999; font-size: 24;}
	.item-summary{color: #333333; font-size: 26;}
	.refresh{width: 750px; padding-top: 40px; padding-top: 80px; align-items: center;justify-content: center;}
</style>
<script>
	const browser = weex.requireModule('browser')
	const navigator = weex.requireModule('navigator')
	
	import config from './config'
	import jandan from './services/jandan'
	module.exports = {
		data(){
			return {
				config:config,
				datalist:[1,1,1,1,1,1,1],
				showRefresh:'hide'
			}
		},
		computed:{
			refreshTips(){
				return this.showRefresh == 'hide' ? '下拉获取最新数据' : '加载中...'
			}
		},
		created(){
			this.onrefresh()
		},
		methods:{
			onrefresh(){
				this.showRefresh = 'show'
				jandan.articleIndex().then(datalist=>{
					this.datalist = datalist
					this.showRefresh = 'hide'
				})
			},
			click(e){
				const item = e.target.attr.item
				if(item) {
					jandan.makeRead(item.title)
					item.isRead = true
					browser.browserWeb(item.href,true)
				}
			},
			more(){
				navigator.push({url:config.js('more.js')},()=>{})
			}
		}
	}
</script>