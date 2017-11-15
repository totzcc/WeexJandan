<template>
	<navpage
	    dataRole="none"
	    :height="config.barHeight()"
	    title="评论列表"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="config.image('back.png')"
	    :rightItemSrc="config.image('reply.png')"
	    @naviBarLeftItemClick="naviBarLeftItemClick"
	    @naviBarRightItemClick="naviBarRightItemClick">
	    <div class="container">
	    		<list>
	    			<refresh class="refresh" @refresh="onrefresh" :display="showRefresh" v-if="datalist">
			      	<text class="indicator">{{refreshTips}}</text>
			    </refresh>
			    <cell v-if="!datalist">
					<div v-if="!datalist" style="width: 750px; height: 100px; align-items:center;justify-content: center;">
						<text>Loading...</text>
					</div>
				</cell>
	    			<cell v-for="(item,index) in datalist">
	    				<div style="background-color: #FFFFFF; margin-top: 20px;padding: 20px; padding-bottom: 0px;">
	    					<div>
		    					<div style="flex-direction: row; padding: 20px; padding-left: 0px;">
		    						<text style="color: #999999; font-size: 24;">#{{index + 1}}</text>
		    						<text style="color: orangered; font-size: 24;margin-left: 20px;">{{item.author}}</text>
		    						<text style="color: #999999; font-size: 20; margin-left: 20px;">{{item.time}}</text>
		    					</div>
		    					<div>
		    						<text style="color: #333333; font-size: 30;">{{item.title}}</text>
		    					</div>
		    				</div>
		    				<div style="flex-direction: row; justify-content: space-between; border-top-width: 1; border-color: #e3e3e3; border-style: dashed; margin-top: 20px;">
		    					<div style="flex-direction: row; justify-content: center; align-items: center;">
		    						<text style="color: orangered;" @click="vote" type="1" :item="item">OO</text>
			    					<text style="color: #999999;" @click="vote" type="1" :item="item">[{{item.support}}]</text>
			    					<text style="color: #AAAAFF; margin-left: 30px;" @click="vote" type="0" :item="item">XX</text>
			    					<text style="color: #999999;" @click="vote" type="0" :item="item">[{{item.unsupport}}]</text>
		    					</div>
		    					<!--<div style="flex-direction: row; justify-content: center; align-items: center;" @click="reply" :item="item">
			    					<image :src="config.image('reply.png')" style="width: 50px; height: 50px;"></image>
		    					</div>-->
		    				</div>
	    				</div>
	    			</cell>
	    			<cell style="height: 20px;"></cell>
					<text class="indicator">{{loadingTips}}</text>
			    </loading>
	    		</list>
	    </div>
	</navpage>
</template>
<style>
	.container{background-color: #f3f3f3; flex: 1;}
	.loading{width: 750px; padding-top: 40px; padding-bottom: 40px; align-items: center;justify-content: center;}
	.refresh{width: 750px; padding-top: 40px; padding-top: 40px; align-items: center;justify-content: center;}
</style>
<script>
	const navigator = weex.requireModule('navigator')
	const storage = weex.requireModule('storage')
	const modal = weex.requireModule('modal')
	import config from './config'
	import jandanComments from './services/jandan-comments'
	module.exports = {
		data(){
			return{
				config:config,
				showLoading:'hide',
				showRefresh:'hide',
				datalist:null,
				detail:{
					title:'',
					href:'',
					postId:''
				},
				page:null
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
			navpage: require('./include/navpage.vue'),
		},
		created(){
			storage.getItem('article-detail',(ret)=>{
				this.detail = JSON.parse(ret.data)
				this.onrefresh()
			})
		},
		methods:{
			onrefresh(){
				this.showRefresh = 'show'
				jandanComments.comments(this.detail.href, this.page).then((result) =>{
					if(result.maxPage) {
						this.page = result.maxPage
					}
					this.datalist = result.datalist
					this.detail.postId = result.postId
					this.showRefresh = 'hide'
				})
			},
			vote(e){
				var item = e.target.attr.item
				const voteType = e.target.attr.type
				jandanComments.vote(item.id, voteType).then((res) => {
					if(res.error == 0) {
						if(voteType == 1) {
							item.support = parseInt(item.support) + 1
						} else {
							item.unsupport = parseInt(item.unsupport) + 1
						}
					} else {
						modal.toast({message:res.msg,duration:1})		
					}
				})
			},
			reply(e){
				storage.setItem('REPLY_COMMENTS',JSON.stringify({
					postId:this.detail.postId,
					type:'comment',
					placeholder:'回复主题：' + this.detail.title
				}),()=>{
					navigator.push({url:config.js('comment-submit.js')})
				})
			},
			naviBarLeftItemClick(){
				navigator.pop({},()=>{})
			},
			naviBarRightItemClick(){
				this.reply()
			}
		}
	}
</script>