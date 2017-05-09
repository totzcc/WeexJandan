<template >
	<div class="container">
		<list>
			<cell style="height: 30px;"></cell>
			<cell v-for="item in datalist" @click="clickLike" :item="item">
				<div class="item">
					<text style="color: #333333;">{{item.title}}</text>
					<div style="flex-direction: row; align-items: center; justify-content: space-between; margin-top: 5px; padding: 5px;" class="item-box">
						<div>
							<text style='color: #666666; font-size: 28;'>{{item.author}}</text>
							<text style='color: #999999; font-size: 24;'>{{item.time}}</text>
						</div>
						<image v-if="item.vote==1" class="like-item" :src="config.image('like.png')"></image>
						<image v-if="item.vote==0"class="like-item" :src="config.image('dislike.png')"></image>
					</div>
					<div style="flex-direction: row;">
						<div style="flex: 1; border-right-width: 0px; height: 55px;" class="item-box-center" @click='support' :item="item" vote-type="1">
							<text style="color:#FF4D33;">OO  </text>
							<text style="color:#FE0000;">{{item.support}}</text>
						</div>
						<div style="flex: 1;height: 55px;" class="item-box-center" @click='support' :item="item" vote-type="0">
							<text style="color: #999999;">XX  </text>
							<text style="color: #666666;">{{item.unsupport}}</text>
						</div>
					</div>
				</div>
			</cell>
			<cell style="height: 80px;"></cell>
			<loading class="loading" @loading="onloading" :display="showLoading">
		      <text class="indicator">{{loadingTips}}</text>
		    </loading>
		</list>
	</div>
</template>
<style>
	.container{padding-left: 10px;background-color: #f3f3f3;}
	.item{padding: 10px; padding-bottom: 0px; margin: 10px; background-color: #FFFFFF; border-width: 1px; border-color: #e3e3e3;}
	.item-box{border-width: 1px; border-color: #e3e3e3;border-style:dashed; border-bottom-width: 0px;}
	.item-box-center{align-items: center;justify-content: center;flex-direction: row;border-width: 1px; border-color: #e3e3e3;border-style:dashed; border-bottom-width: 0px;}
	.loading{width: 750px; padding-bottom: 40px; align-items: center;justify-content: center;}
	.like-conver {position: absolute;top: 0;right: 0;bottom: 0;left: 0;justify-content: center;align-items: center;}
	.like{width: 300px; height: 300px;opacity: 0;}
	.like-item{width: 50px; height: 50px;}
</style>
<script>
	import config from './config'
	import jandan from './services/jandan'
	import jandanComments from './services/jandan-comments'
	import animation from './animation/animation'
	const browser = weex.requireModule('browser')
	const modal = weex.requireModule('modal')
	export default {
		data: {
			config:config,
			datalist:[],
			maxPage:0,
			showLoading:'hide',
			lastClickObj:{item:null,timestamp:0},
			isSingleClick:true,
			type:'joke'
		},
		computed:{
			loadingTips(){
				if(!this.datalist || this.datalist.length == 0){
					return '加载中...'
				}
				return this.showLoading == 'hide' ? '上拉加载更多' : '加载中...'
			}
		},
		created() {
			jandan.list(this.type).then((response)=>{
				this.datalist = response.datalist
				if(response.maxPage) {
					this.maxPage = response.maxPage
				}
			})
			config.event('joke')
		},
		methods: {
			getUrlParam (key) {
				var reg = new RegExp('[?|&]' + key + '=([^&]+)')
				var match = weex.config.bundleUrl.match(reg)
				return match && match[1]
			},
			onloading(){
		        this.showLoading = 'show'
		        this.maxPage -= 1
		        jandan.list(this.type,this.maxPage).then(response =>{
		        		this.showLoading = 'hide'
		        		setTimeout(()=>{
		        			this.datalist = this.datalist.concat(response.datalist)
		        		},500)
		        		
		        })
			},
			support(e){
				const item = e.target.attr.item
				const voteType = e.target.attr.voteType
				if(item.vote) {
					return
				}
				item.vote = voteType
				jandanComments.vote(item.id, voteType).then(res=>{
					if(voteType == 1) {
						item.support += 1
					} else {
						item.unsupport += 1
					}
				})
			},
			clickLike(e){
				const item = e.target.attr.item
				if(!this.lastClickObj.item == item) {
					this.lastClickObj = {item:item,timestamp:e.timestamp}
					this.isSingleClick = true
				}
				if(e.timestamp - this.lastClickObj.timestamp <= 200) {
					if(item.vote) {
						return
					}
					if(item.vote != 1) {
						item.vote = 1
						jandanComments.vote(item.id, 1).then(res=>{
							item.support += 1
						})
						setTimeout(()=>{
							this.isSingleClick = true
						},200)
						this.isSingleClick = false
					}
				} else {
					setTimeout(()=>{
						if(this.isSingleClick && item.imgs && item.imgs.length > 0) {
							var imgs = [];
							var currentIndex = 0;
							var find = false
							this.datalist.forEach((value) => {
								if(value.imgs && value.imgs.length>0) {
									imgs = imgs.concat(value.imgs);
									if(!find && value != item) {
										currentIndex += value.imgs.length;
									} else {
										find = true
									}
								}
							})
							browser.browserImages(imgs, currentIndex)
						}
					},300)
				}
				this.lastClickObj = {item:item,timestamp:e.timestamp}
			}
		}
	}
</script>