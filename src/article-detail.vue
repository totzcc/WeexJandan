<template>
	<scroller class="container">
        <rich-text :html="html" style="flex: 1;"></rich-text>
		<div @click="naviBarLeftItemClick" style="position: fixed; left: 25; top: 65;">
			<div style="width: 80px; height: 80px;border-radius: 80px;background-color: #000000; opacity: 0.1;"></div>
			<image :src="config.image('back.png')" style=" position: absolute; width: 50px;height: 50px; left: 15px; top: 15px;"></image>
		</div>
		<div @click="seeComments" style="position: fixed; right: 40; top: 65;">
			<div style="width: 80px; height: 80px;border-radius: 80px;background-color: #000000; opacity: 0.1;"></div>
			<image :src="config.image('comment.png')" style=" position: absolute; width: 50px;height: 50px; left: 15px; top: 15px;"></image>
			<text style="position: absolute; right: 0; top: 0; font-size: 24px; color: #666666;">{{detail.comments}}</text>
		</div>
		<div @click="like" style="position: fixed; left: 25; bottom: 65;">
			<div style="width: 80px; height: 80px;border-radius: 80px;background-color: #000000; opacity: 0.1;"></div>
			<image :src="likePng" style=" position: absolute; width: 50px;height: 50px; left: 15px; top: 15px;"></image>
		</div>
		<!--<div @click="like" style="position: fixed; left: 330; bottom: 65;">
			<div style="width: 80px; height: 80px;border-radius: 80px;background-color: #000000; opacity: 0.1;"></div>
			<image :src="subscribe" style=" position: absolute; width: 50px;height: 50px; left: 15px; top: 15px;"></image>
		</div>-->
		<div @click="more" style="position: fixed; right: 40; bottom: 65;">
			<div style="width: 80px; height: 80px;border-radius: 80px;background-color: #000000; opacity: 0.1;"></div>
			<image :src="config.image('share.png')" style=" position: absolute; width: 50px;height: 50px; left: 15px; top: 15px;"></image>
		</div>
	</scroller>
</template>
<style>
    .container {
        padding:20px;
    }
</style>
<script>
	const navigator = weex.requireModule('navigator')
	const storage = weex.requireModule('storage')
	const modal = weex.requireModule('modal')
	const share = weex.requireModule('share')
	const html = weex.requireModule('html')
	import config from './config'
    import jandan from './services/jandan'
    import stream from './services/jandan-stream'
	import comments from './services/jandan-comments'
	import favorite from './services/jandan-favorite'
	module.exports = {
		data(){
			return {
				config:config,
				src:"http://localhost:9090/",
				likePng:config.image('like-gray.png'),
				subscribe:config.image('subscribe-highlight.png'),
				detail:{
					href:'',
					title:'',
					isLike:false,
					comments:''
				},
                html:""
			}
		},
		components: {
			navpage: require('./include/navpage.vue'),
            richText: require('./components/rich-text.vue')
		},
		created(){
			storage.getItem('article-detail',(ret)=>{
				let detail = JSON.parse(ret.data)
				detail.isLike = favorite.isLike(detail.href)
				comments.getCommentCount(detail.href).then(count=>{
					detail.comments = count || 0
					this.detail = detail
                    this.like()
				})
                 stream.fetch({
                     method: 'GET',
                     url: detail.href,
                     cache:true,
                     type: 'text'
                 }, (ret) => {
                     html.cssEx(ret.data,'.entry',['.shang','script','.jandan-zan'], find => {
                         this.html = find[0]
                     })
                 })
			})
		},
		methods:{
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			seeComments(e){
                jandan.toCommentsDetail(this.detail)
			},
			more(e){
				share.share(this.detail.href,this.detail.title)
			},
			like(e){
				if(e) {
					this.detail.isLike = favorite.toggleLike(this.detail.href, this.detail.title, this.detail.img)
				}
				if(this.detail.isLike === true) {
					this.likePng = config.image('like.png')
				} else {
					this.likePng = config.image('like-gray.png')
				}
			},
		}
	}
</script>