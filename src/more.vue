<template>
	<navpage
	    dataRole="none"
	    :height="config.barHeight()"
	    title="精彩文章"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="backImg"
	    rightItemTitle="分类"
	    @naviBarLeftItemClick="naviBarLeftItemClick"
	    @naviBarRightItemClick="naviBarRightItemClick">
		<div class="container">
			<waterfall column-count="2" style="width: 750px;">
				<refresh class="refresh" @refresh="onrefresh" :display="showRefresh">
			      	<text class="indicator">{{refreshTips}}</text>
			    </refresh>
				<cell v-for="item in datalist" @click="click" :item="item">
					<div class="item">
						<image class="item-image" resize="cover" :src="item.img"></image>
						<div class="item-text">
							<text style="flex: 1; font-size: 28;" v-bind:style="{'color' : item.isRead ? '#333333':'#dd3333'}">{{item.title}}</text>
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
	const storage = weex.requireModule('storage')
	import jandan from './services/jandan'
	import config from './config'
	module.exports = {
		data(){
			return {
				config:config,
				showLoading:'hide',
				showRefresh:'hide',
				page:2,
				backImg:config.image('back.png'),
				datalist:[1,1,1,1,1,1,1,1,1,1,1,1]
			}
		},
		computed:{
			loadingTips(){
				if(!this.datalist || this.datalist.length == 0){
					return '加载中...'
				}
				return this.showLoading == 'hide' ? '上拉加载更多' : '加载中...'
			},
			refreshTips(){
				return this.showRefresh == 'hide' ? '下拉获取最新数据' : '加载中...'
			}
		},
		created(){
			this.onrefresh()
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		methods:{
			onrefresh(){
				this.showRefresh = 'show'
				this.page = 2
				jandan.article(this.page).then((datalist) => {
					this.showRefresh = 'hide'
					this.datalist = datalist
				})
			},
			onloading(){
		        this.showLoading = 'show'
		        this.page += 1
		        jandan.article(this.page).then((datalist) => {
		        		this.showLoading = 'hide'
			        	 this.datalist = this.datalist.concat(datalist)
				})
			},
			click(e){
				const item = e.target.attr.item
				if(item) {
					item.isRead = true
					jandan.makeRead(item.title)
					jandan.toDetail(item)
				}
			},
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			naviBarRightItemClick(e){
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
	.refresh{width: 750px; padding-top: 40px; padding-top: 40px; align-items: center;justify-content: center;}
</style>