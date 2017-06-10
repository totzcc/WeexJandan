<template>
	<navpage
	    dataRole="none"
	    :height="config.barHeight()"
	    :title="category"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="backImg"
	    @naviBarLeftItemClick="naviBarLeftItemClick">
		<div class="container">
			<list>
				<refresh class="refresh" @refresh="onrefresh" :display="showRefresh">
			      	<text class="indicator">{{refreshTips}}</text>
			    </refresh>
				<cell v-for="item in datalist" @click="click" :item="item">
					<div class="item">
						<image resize="cover" :src='item.img' style="width: 250px;height: 150px; background-color: #e3e3e3;"></image>
						<div style="flex: 1;margin-left: 20px;justify-content: space-between;">
							<text class="font-small" v-bind:style="{'color' : item.isRead ? '#333333':'#dd3333'}">{{item.title}}</text>
							<text class="item-author">{{item.author}}</text>
						</div>
					</div>
				</cell>
				<cell style="height: 40px;"></cell>
				<loading class="loading" @loading="onloading" :display="showLoading">
					<text class="indicator">{{loadingTips}}</text>
			    </loading>
			</list>
		</div>
	</navpage>
</template>

<script>
	const browser = weex.requireModule('browser')
	const navigator = weex.requireModule('navigator')
	const storage = weex.requireModule('storage')
	import config from './config'
	import jandan from './services/jandan'
	module.exports = {
		data(){
			return {
				config:config,
				category:'走近科学',
				page:1,
				backImg:config.image('back.png'),
				datalist:[1,1,1,1,1,1,1],
				showLoading:'hide',
				showRefresh:'hide',
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
		components: {
			navpage: require('./include/navpage.vue')
		},
		created(){
			this.category = decodeURI(config.params('category'))
			this.onrefresh()
		},
		methods:{
			onrefresh(){
				this.page = 1
				this.showRefresh = 'show'
				jandan.category(this.category, this.page).then(datalist=>{
					this.datalist = datalist
					this.showRefresh = 'hide'
				})
			},
			onloading(){
				this.page += 1
				this.showLoading = 'show'
				jandan.category(this.category, this.page).then(datalist=>{
					this.showLoading = 'hide'
					setTimeout(()=>{
						this.datalist = this.datalist.concat(datalist);
					},100)
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
			more(){
				navigator.push({url:config.js('more.js')},()=>{})
			},
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
		}
	}
</script>

<style>
	.container{background-color: #f3f3f3; flex: 1;}
	.item{background-color: #ffffff;margin-top: 40px; padding: 20px;flex-direction: row;}
	.item-author{color: #999999; font-size: 24;}
	.item-summary{color: #333333; font-size: 26;}
	.loading{width: 750px; padding-top: 40px; padding-bottom: 40px; align-items: center;justify-content: center;}
	.refresh{width: 750px; padding-top: 40px; padding-top: 40px; align-items: center;justify-content: center;}
</style>