<template>
	<navpage
	    dataRole="none"
	    :height="config.barHeight()"
	    title="我的收藏"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="config.image('back.png')"
	    @naviBarLeftItemClick="naviBarLeftItemClick">
	    <div v-if="favortesData.favortes.length == 0" style="flex: 1; align-items: center; justify-content: center;">
	    		<text style="color: #999999;">暂无收藏</text>
	    </div>
	    <list v-if="favortesData.favortes.length > 0">
	    		<cell v-for="item in favortesData.favortes" @click="click" :item="item">
				<div class="item">
					<image resize="cover" :src='item.img' style="width: 250px;height: 150px; background-color: #e3e3e3;"></image>
					<div style="flex: 1;margin-left: 20px;justify-content: space-between;">
						<text style="color: #333333;">{{item.title}}</text>
						<text class="item-author">{{item.author}}</text>
					</div>
				</div>
			</cell>
	    </list>
	 </navpage>
</template>

<script>
	const navigator = weex.requireModule('navigator')
	const storage = weex.requireModule('storage')
	import config from './config'
	import favorite from './services/jandan-favorite'
	import jandan from './services/jandan'
	module.exports = {
		data(){
			return {
				config:config,
				favortesData:{favortes:[1,1,1,1,1,1,1,1,1]},
			}
		},
		created(){
			favorite.getFavortesData().then((favortesData) => {
				this.favortesData = favortesData;
			})
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		methods:{
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			click(e){
				const item = e.target.attr.item
				if(item) {
					item.isRead = true
					jandan.makeRead(item.title)
					jandan.toDetail(item)
				}
			}
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