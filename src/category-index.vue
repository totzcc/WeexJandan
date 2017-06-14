<template>
	<navpage
	    dataRole="none"
	    :height="config.barHeight()"
	    title="分类"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="backImg"
	    :rightItemTitle="rightItemTitle"
	    @naviBarLeftItemClick="naviBarLeftItemClick"
	    @naviBarRightItemClick="naviBarRightItemClick">
		<scroller class="container">
			<div v-if="subscribes.categorys.length > 0">
				<div class="header">
					<text>{{subscribes.title}}</text>
				</div>
				<div class="container-item">
					<div v-for="category in subscribes.categorys" :category="category" @click="remove">
						<div class="item">
							<text>{{category}}</text>
						</div>
						<image v-if="isSubscribeing" style="position: absolute; left: 0; top: 0; width: 40; height: 40;" :src="config.image('delete.png')"/>
					</div>
				</div>
			</div>
			<div v-for="item in datalist" v-if="!item.hideCategory">
				<div class="header">
					<text>{{item.title}}</text>
				</div>
				<div class="container-item">
					<div v-for="category in item.categorys" v-if="!category.isSubscribe" :category="category" :item="item" @click="click">
						<div class="item">
							<text>{{category.title}}</text>
						</div>
						<image v-if="isSubscribeing" style="position: absolute; left: 0; top: 0; width: 40; height: 40;" :src="config.image('add.png')"/>
					</div>
				</div>
			</div>
		</scroller>
	</navpage>
</template>
<style>
	.container{background-color: #f3f3f3; flex:1;}
	.header{height: 100px; width: 750px; justify-content: center; align-items: center;}
	.container-item{flex-direction: row;flex-wrap: wrap;}
	.item{background-color: #FFFFFF; justify-content: center; align-items: center; margin: 10px; width: 229px; height: 88px;}
	.item-image{background-color: #e3e3e3;flex: 1; height:200px}
	.item-text{padding: 10px; color: #333333;}
	.loading{width: 750px; padding-top: 40px; padding-bottom: 40px; align-items: center;justify-content: center;}
</style>
<script>
	let navigator = weex.requireModule('navigator')
	import config from './config'
	import jandanService from './services/jandan'
	import subscribeService from './services/jandan-subscribe'
	module.exports = {
		data(){
			return {
				config:config,
				backImg:config.image('back.png'),
				isSubscribeing:false,
				datalist:[
					{
						title:'',
						categorys:[{title:''},{title:''},{title:''},{title:''},{title:''},{title:''}]
					},
					{
						title:'',
						categorys:[{title:''},{title:''},{title:''},{title:''},{title:''},{title:''}]
					},
					{
						title:'',
						categorys:[{title:''},{title:''},{title:''},{title:''},{title:''},{title:''}]
					},
					{
						title:'',
						categorys:[{title:''},{title:''},{title:''},{title:''},{title:''},{title:''}]
					},
					{
						title:'',
						categorys:[{title:''},{title:''},{title:''},{title:''},{title:''},{title:''}]
					},
				],
				subscribes:{
					title:'我的订阅',
					categorys:[]
				}
			}
		},
		computed:{
			rightItemTitle(){
				if(this.isSubscribeing) {
					return '完成'
				}
				return this.subscribes.categorys.length == 0 ? '订阅通知' : '管理订阅'
			}
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		created(){
			subscribeService.getSubscribe().then( data=>{
				this.subscribes.categorys = data
				jandanService.categoryIndex().then((datalist)=>{
					this.datalist = datalist
					this.refreshCategoryState()
				})
			})
//			jandanService.categoryIndex().then((datalist)=>{
//				this.datalist = datalist
//				subscribeService.getSubscribe().then( data=>{
//					this.subscribes.categorys = data
//					this.refreshCategoryState()
//				})
//			})
		},
		methods:{
			click(e){
				let category = e.target.attr.category
				let item = e.target.attr.item
				if(!category.title){
					return
				}
				if(this.isSubscribeing) {
					category.isSubscribe = true
					if (this.subscribes.categorys.indexOf(category.title) == -1) {
						this.subscribes.categorys.push(category.title)
					}
				} else {
					let url = config.js('category-list.js') + "?category=" + encodeURI(category.title)
					navigator.push({url:url},()=>{})
				}
			},
			remove(e){
				if(this.isSubscribeing) {
					let category = e.target.attr.category
					let index = this.subscribes.categorys.indexOf(category)
					this.subscribes.categorys.splice(index, 1)
					this.setCategoryState(category,false)
				} else {
					let category = e.target.attr.category
					let url = config.js('category-list.js') + "?category=" + encodeURI(category)
					navigator.push({url:url},()=>{})
				}
			},
			refreshCategoryState(){
				this.subscribes.categorys.forEach((category) => {
					this.setCategoryState(category)
				})
			},
			setCategoryState(category,isSubscribe) {
				if(isSubscribe == undefined) {
					isSubscribe = true
				}
				for(var i = 0; i < this.datalist.length; i ++) {
					let categorys = this.datalist[i].categorys;
					for(var j = 0; j < categorys.length; j ++) {
						if(category == categorys[j].title) {
							categorys[j].isSubscribe = isSubscribe
							return
						}
					}
				}
			},
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			naviBarRightItemClick(e){
				if(this.isSubscribeing) {
					subscribeService.setSubscribe(this.subscribes.categorys)
				}
				this.isSubscribeing = !this.isSubscribeing;
			}
		}
	}
</script>