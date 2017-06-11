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
					<div v-for="category in subscribes.categorys">
						<div class="item" :category="category" @click="remove" style="background-color: #FFFFFF;">
							<text>{{category}}</text>
						</div>
						<image v-if="isSubscribeing" style="position: absolute; left: 0; top: 0; width: 40; height: 40;" :src="config.image('delete.png')"/>
					</div>
				</div>
			</div>
			<div v-for="item in datalist">
				<div class="header">
					<text>{{item.title}}</text>
				</div>
				<div class="container-item">
					<div v-for="category in item.categorys">
						<div class="item" :category="category" @click="click" :style="{backgroundColor: category.isSubscribe && isSubscribeing ? '#e3e3e3' : '#ffffff'}">
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
	.item{justify-content: center; align-items: center; margin: 10px; width: 229px; height: 88px;}
	.item-image{background-color: #e3e3e3;flex: 1; height:200px}
	.item-text{padding: 10px; color: #333333;}
	.loading{width: 750px; padding-top: 40px; padding-bottom: 40px; align-items: center;justify-content: center;}
</style>
<script>
	const navigator = weex.requireModule('navigator')
	import config from './config'
	import jandan from './services/jandan'
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
				return this.isSubscribeing ? '完成' : '订阅通知'
			}
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		created(){
			jandan.categoryIndex().then((datalist)=>{
				this.datalist = datalist
				this.refreshCategoryState()
			})
		},
		methods:{
			click(e){
				const category = e.target.attr.category
				if(this.isSubscribeing) {
					category.isSubscribe = true
					if (this.subscribes.categorys.indexOf(category.title) == -1) {
						this.subscribes.categorys.push(category.title)
					}
				} else {
					const url = config.js('category-list.js') + "?category=" + encodeURI(category.title)
					navigator.push({url:url},()=>{})
				}
			},
			remove(e){
				const category = e.target.attr.category
				let index = this.subscribes.categorys.indexOf(category)
				this.subscribes.categorys.splice(index, 1)
				this.resetCategoryState(category,false)
			},
			refreshCategoryState(){
				this.subscribes.categorys.forEach((category) => {
					this.resetCategoryState(category)
				})
			},
			resetCategoryState(category,isSubscribe) {
				if(isSubscribe == undefined) {
					isSubscribe = true
				}
				for(var i = 0; i < this.datalist.length; i ++) {
					let categorys = this.datalist[i].categorys;
					for(var j = 0; j < categorys.length; j ++) {
						console.log(categorys[j].title)
						if(category == categorys[j].title) {
							categorys[j].isSubscribe = isSubscribe
							console.log('categorys[j].isSubscribe=' + categorys[j].isSubscribe)
							return
						}
					}
				}
			},
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			naviBarRightItemClick(e){
				this.isSubscribeing = !this.isSubscribeing;
			}
		}
	}
</script>