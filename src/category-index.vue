<template>
	<navpage
	    dataRole="none"
	    height="128"
	    title="分类"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="backImg"
	    @naviBarLeftItemClick="naviBarLeftItemClick">
		<div class="container" >
			<waterfall column-count="2">
				<header>
					<div class="header">
						<text>科学</text>
					</div>
				</header>
				<cell class="item" v-for="item in science" @click="click" :item="item">
					<image class="item-image" :src="item.img"></image>
					<text class="item-text">{{item.title}}</text>
				</cell>
				<header>
					<div class="header">
						<text>技术</text>
					</div>
				</header>
				<cell class="item" v-for="item in technology" @click="click" :item="item">
					<image class="item-image" :src="item.img"></image>
					<text class="item-text">{{item.title}}</text>
				</cell>
				<header>
					<div class="header">
						<text>NSFW</text>
					</div>
				</header>
				<cell class="item" v-for="item in nsfw" @click="click" :item="item">
					<image class="item-image" :src="item.img"></image>
					<text class="item-text">{{item.title}}</text>
				</cell>
			</waterfall>
		</div>
	</navpage>
</template>

<script>
	const navigator = weex.requireModule('navigator')
	import config from './config'
	module.exports = {
		data(){
			return {
				backImg:config.image('back-2.png'),
				science:[
					{title:'走近科学',img:'http://tankr.net/s/custom/GMUP.jpg'},
					{title:'无厘头研究',img:'http://tankr.net/s/custom/Q6U0.jpg'},
					{title:'天文',img:'http://tankr.net/s/custom/SMSO.jpg'},
					{title:'NASA',img:'http://tankr.net/s/custom/F1NY.jpg'},
					{title:'高科技',img:'http://tankr.net/s/custom/K5KG.jpg'},
					{title:'环保',img:'http://tankr.net/s/custom/R1QY.jpg'}
					
				],
				technology:[
					{title:'TECH',img:'http://tankr.net/s/custom/YLIY.jpg'},
					{title:'人工智能',img:'http://tankr.net/s/custom/8TH6.jpg'},
					{title:'无人机',img:'http://tankr.net/s/custom/E1CU.jpg'},
					{title:'3D打印',img:'http://tankr.net/s/custom/C3HK.jpg'},
					{title:'数码产品',img:'http://tankr.net/s/custom/0DRF.jpg'},
					{title:'虚拟现实',img:'http://tankr.net/s/custom/ZIOM.jpg'},
				],
				nsfw:[
					{title:'SEX',img:'http://tankr.net/s/custom/6Y7A.jpg'},
					{title:'WTF',img:'http://tankr.net/s/custom/2XLD.jpg'},
					{title:'LGBT',img:'http://tankr.net/s/custom/RZTM.jpg'},
					{title:'重口味',img:'http://tankr.net/s/custom/COVO.jpg'},
					{title:'没品笑话集',img:'http://tankr.net/s/custom/GMC2.jpg'}
				]
			}
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		methods:{
			click(e){
				const item = e.target.attr.item
				const url = config.js('category-list.js') + "?category=" + encodeURI(item.title)
				navigator.push({url:url},()=>{})
			},
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
		}
	}
</script>

<style>
	.container{background-color: #f3f3f3; flex:1;}
	.header{height: 100px; width: 750px; justify-content: center; align-items: center;}
	.item{background-color: #FFFFFF;}
	.item-image{background-color: #e3e3e3;flex: 1; height:200px}
	.item-text{padding: 10px; color: #333333;}
	.loading{width: 750px; padding-top: 40px; padding-bottom: 40px; align-items: center;justify-content: center;}
</style>