<template>
	<navpage
	    dataRole="none"
	    :height="config.barHeight()"
	    title="设置个人信息"
	    backgroundColor="#ffffff"
	    titleColor="#333333"
	    :leftItemSrc="config.image('back.png')"
	    rightItemTitle=" 保存"
	    @naviBarLeftItemClick="naviBarLeftItemClick"
	    @naviBarRightItemClick="naviBarRightItemClick">
	    <div style="padding: 40px;background-color: #F3F3F3; flex: 1;">
	    		<input style="background-color:#FFFFFF;height: 80px; padding-left: 20px; margin-bottom: 20px;" maxlength="20" placeholder="昵称" :value="userInfo.author" @input="inputAuthor"></input>
	    		<input style="background-color:#FFFFFF;height: 80px; padding-left: 20px;" placeholder="邮箱" type="email" :value="userInfo.email" @input="inputEmail"></input>
	    </div>
	</navpage>
</template>
<script>
	const navigator = weex.requireModule('navigator')
	const modal = weex.requireModule('modal')
	import config from './config'
	import jandanComments from './services/jandan-comments'
	module.exports = {
		data(){
			return {
				config:config,
				userInfo:{}
			}
		},
		components: {
			navpage: require('./include/navpage.vue')
		},
		created(){
			jandanComments.getUserInfo().then((userInfo)=>{
				this.userInfo = userInfo
			})
		},
		methods:{
			naviBarLeftItemClick(e){
				navigator.pop({},()=>{})
			},
			naviBarRightItemClick(e){
				const emailReg = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/
				if(this.userInfo.author.length < 2 || this.userInfo.author.length > 20) {
					modal.toast({message:'昵称长度在2到20之间',duration:1})
				} else if(!emailReg.test(this.userInfo.email)) {
					modal.toast({message:'请填写正确的邮箱地址',duration:1})
				} else {
					jandanComments.setUserInfo(this.userInfo.author, this.userInfo.email)
					navigator.pop({},()=>{})
				}
			},
			inputEmail(e){
				this.userInfo.email = e.value
			},
			inputAuthor(e){
				this.userInfo.author = e.value
			}
		}
	}
</script>