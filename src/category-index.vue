<template>
	<navpage
	    dataRole="none"
	    height="128"
	    title="分类"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="backImg"
	    @naviBarLeftItemClick="naviBarLeftItemClick">
		<scroller class="container">
			<div v-for="item in datalist">
				<div class="header">
					<text>{{item.title}}</text>
				</div>
				<div class="container-item" >
					<div class="item" v-for="category in item.categorys" :category="category" @click="click">
						<text>{{category}}</text>
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
	.item{background-color: #ffffff; justify-content: center; align-items: center; margin: 10px; width: 229px; height: 88px;}
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
				backImg:config.image('back.png'),
				datalist:[
					{
						title:'',
						categorys:['','','','','','']
					},
					{
						title:'',
						categorys:['','','','','','']
					},
					{
						title:'',
						categorys:['','','','','','']
					},
					{
						title:'',
						categorys:['','','','','','']
					},
					{
						title:'',
						categorys:['','','','','','']
					},
				]
			}
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		created(){
			jandan.categoryIndex().then((datalist)=>{
				this.datalist = datalist
			})
			config.event('category-index','分类首页')
		},
		methods:{
			click(e){
				const category = e.target.attr.category
				const url = config.js('category-list.js') + "?category=" + encodeURI(category)
				navigator.push({url:url},()=>{})
			},
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
		}
	}
</script>