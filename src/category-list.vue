<template>
	<navpage
	    dataRole="none"
	    height="128"
	    :title="category"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="backImg"
	    @naviBarLeftItemClick="naviBarLeftItemClick">
		<div class="container">
			<list>
				<cell v-for="item in datalist" @click="click" :item="item">
					<div class="item">
						<image resize="cover" :src='item.img' style="width: 250px;height: 150px; background-color: #e3e3e3;"></image>
						<div style="flex: 1;margin-left: 20px;justify-content: space-between;">
							<text class="item-title font-small">{{item.text}}</text>
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
	
	import config from './config'
	import jandan from './services/jandan'
	module.exports = {
		data(){
			return {
				category:'走近科学',
				page:1,
				backImg:config.image('back-2.png'),
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
		components: {
			navpage: require('./include/navpage.vue')
		},
		created(){
			this.category = decodeURI(config.params('category'))
			jandan.catetory(this.category, this.page).then(datalist=>{
				this.datalist = datalist
			})
		},
		methods:{
			onloading(){
				this.page += 1
				this.showLoading = 'show'
				jandan.catetory(this.category, this.page).then(datalist=>{
					this.showLoading = 'hide'
					setTimeout(()=>{
						this.datalist = this.datalist.concat(datalist);
					},100)
				})
			},
			click(e){
				const item = e.target.attr.item
				if(item) {
					browser.browserWeb(item.href,true)
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
	.item-title{color: #dd3333;}
	.item-author{color: #999999; font-size: 24;}
	.item-summary{color: #333333; font-size: 26;}
	.loading{width: 750px; padding-top: 40px; padding-bottom: 40px; align-items: center;justify-content: center;}
</style>