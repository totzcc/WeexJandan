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
			<cell v-for="(item,index) in datalist">
				<div class="item">
					<div style="flex-direction: row;" @click="goDetail" :item="item">
						<image resize="cover" :src='item.img' style="width: 250px;height: 150px; background-color: #e3e3e3;"></image>
						<div style="flex: 1;margin-left: 20px;">
							<text class="font-small" :style="{'color' : item.isRead ? '#333333':'#dd3333'}">{{item.title}}</text>
							<text class="item-author">{{item.author}}</text>
							<text class="item-summary">{{item.summary}}</text>
						</div>
					</div>
					<div class="opeart-bar" @click="goComments" :item="item">
						<div></div>
						<div style="flex-direction: row; align-items: center;">
							<text style="color: #999999; font-size: 24; margin-right: 5px;"> {{item.commentTime || 'x mins ago'}} </text>
							<image class="comment" :src="config.image('comment.png')"></image>
							<text style="color: #999999; font-size: 24; margin-left: 5px;"> {{item.comments || 0}}</text>
						</div>
					</div>
				</div>
			</cell>
			<cell>
				<div style="align-items: center;justify-content: center; padding: 20px; background-color: #FFFFFF; margin-top: 44px; margin-bottom: 44px;" @click="more">
					<text>更多有趣文章</text>
				</div>
			</cell>
		</list>
	</div>
</template>
<style>
	.comment{width: 40px; height: 40px;}
	.container{background-color: #f3f3f3;}
	.item{background-color: #ffffff;margin-top: 40px; padding: 20px; padding-bottom: 0px;}
	.item-author{color: #999999; font-size: 24;}
	.item-summary{color: #333333; font-size: 26;}
	.opeart-bar{margin-top: 20px; height: 80px; border-top-width: 1;border-top-style: dashed; border-top-color: #e3e3e3; align-items: center; justify-content: center;  flex-direction: row; justify-content: space-between;}
	.refresh{width: 750px; padding-top: 40px; padding-top: 80px; align-items: center;justify-content: center;}
</style>
<script>
	const browser = weex.requireModule('browser')
	const navigator = weex.requireModule('navigator')
	const storage = weex.requireModule('storage')
	const modal = weex.requireModule('modal')
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
			storage.getItem('agreeRegister', (res)=>{
				if(res.result != 'success') {
					modal.alert({
						message:'用户协议更新',
						okTitle:'立即查看'
					}, ()=>{
						navigator.push({url:config.js('components/user-agreement.js')},()=>{})
					})
				}
			})
		},
		methods:{
			onrefresh(){
				this.showRefresh = 'show'
				jandan.articleIndex().then(datalist=>{
					this.datalist = datalist
					this.showRefresh = 'hide'
				})
			},
            goDetail(e){
                const item = e.target.attr.item
                if(item) {
                    jandan.makeRead(item.title)
                    item.isRead = true
                    jandan.toDetail(item)
                }
            },
            goComments(e){
                const item = e.target.attr.item
                if(item) {
                    jandan.makeRead(item.title)
                    item.isRead = true
                    jandan.toCommentsDetail(item)
                }
            },
			more(){
//				navigator.push({url:config.js('middle.js')},()=>{})
				navigator.push({url:config.js('category-index.js')},()=>{})
			}
		}
	}
</script>