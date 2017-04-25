<template>
	<navpage
	    dataRole="none"
	    height="128"
	    title="精彩文章"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="backImg"
	    rightItemTitle="分类"
	    @naviBarLeftItemClick="naviBarLeftItemClick"
	    @naviBarRightItemClick="naviBarRightItemClick">
		<div class="container">
			<waterfall column-count="2">
				<cell v-for="item in datalist" @click="click" :item="item">
					<div class="item">
						<image class="item-image" resize="cover" :src="item.img"></image>
						<div class="item-text">
							<text style="flex: 1; color: #333333; font-size: 28;">{{item.text}}</text>
							<text style="flex: 1; color: #999999; font-size: 24; margin-top: 5px;">{{item.category}}</text>
						</div>
					</div>
				</cell>
				<cell style="height: 80px;"></cell>
				<loading class="loading" @loading="onloading" :display="showLoading">
			      <text class="indicator">{{loadingTips}}</text>
			    </loading>
			</waterfall>
		</div>
	</navpage>
</template>

<script>
	const browser = weex.requireModule('browser')
	const navigator = weex.requireModule('navigator')
	import jandan from './services/jandan'
	import config from './config'
	module.exports = {
		data(){
			return {
				showLoading:'hide',
				page:2,
				backImg:config.image('back-2.png'),
				datalist:[1,1,1,1,1,1,1,1,1,1,1,1]
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
			jandan.article(this.page).then((datalist) => {
				this.datalist = datalist
			})
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		methods:{
			onloading(){
		        this.showLoading = 'show'
		        this.page += 1
		        jandan.article(this.page).then((datalist) => {
		        		this.showLoading = 'hide'
			        	 setTimeout(()=>{
		        			this.datalist = this.datalist.concat(datalist)
		        		},100)
				})
			},
			click(e){
				const item = e.target.attr.item
				if(item) {
					browser.browserWeb(item.href,true)
				}
			},
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			naviBarRightItemClick(e){
				console.log('naviBarRightItemClick')
				navigator.push({url:config.js('category-index.js')},()=>{})
			}
		}
	}
</script>

<style>
	.container{background-color: #f3f3f3; flex:1;}
	.item{background-color: #FFFFFF;margin-top: 40px;}
	.item-image{background-color: #e3e3e3;flex: 1; height:200px}
	.item-text{padding: 10px;}
	.loading{width: 750px; padding-top: 40px; padding-bottom: 40px; align-items: center;justify-content: center;}
</style>