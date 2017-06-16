<template>
	<div @viewappear="viewappear">
		<navpage
		    dataRole="none"
		    :height="config.barHeight()"
		    title="发表评论"
		    backgroundColor="#ffffff"
		    titleColor="#333333"
		    :leftItemSrc="config.image('back.png')"
		    rightItemTitle="提交"
		    @naviBarLeftItemClick="naviBarLeftItemClick"
		    @naviBarRightItemClick="naviBarRightItemClick"
		    >
		    <div style="padding: 20px;">
		    		<textarea style="flex:1; padding:10px;height: 500px; border-width: 1px;border-color: #000000;" :placeholder="reply.placeholder" :value="content" @input="input"></textarea>
		    </div>
	   </navpage>
	</div>
	
</template>
<style>
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
				content:'',
				reply:{
					postId:'',
					placeholder:'',
					type:'' // tucao \ comment
				}
			}
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		created(){
			storage.getItem('REPLY_COMMENTS',(res)=>{
				if(res.result == 'success') {
					this.reply = JSON.parse(res.data)
				}
			})
		},
		methods:{
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			naviBarRightItemClick(e){
				if(this.content.trim() == "") {
					modal.toast({message:'未填写内容',duration:1})
					return
				}
				jandanComments.submitComment(this.reply.postId, this.content, this.reply.type).then((res)=>{
					this.content = ''
					modal.toast({message:'发表成功，审核通过后会自动展示',duration:1})
					setTimeout(()=>{
						navigator.pop({},()=>{})
					},1000)
				})
			},
			input(e){
				this.content = e.value
			},
			viewappear(e){
				setTimeout(()=>{
					jandanComments.getUserInfo().then((userInfo) =>{
						if(userInfo.author == "") {
							modal.confirm({
								message:'需要设置昵称才能发表回复哦',
								okTitle:'立即设置',
								cancelTitle:'暂不'
							},(result)=>{
								if(result == '立即设置') {
									navigator.push({url:config.js('my-info.js')})
								} else {
									navigator.pop({},()=>{})
								}
							})
						}
					})
				},500)
			}
		}
	}
</script>