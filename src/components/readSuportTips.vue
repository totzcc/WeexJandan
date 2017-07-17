<template>
	<div @click="makeRead" v-if="!isReadedSuportTips" style="position: absolute; top: 0; left: 0; width: 750px; height: 2334px; background-color: rgba(0,0,0,0.5);">
		<image style="width: 750px; height:750px;" resize="contain"  :src="config.image('tips-suppor-unsuppor.png')"></image>
	</div>
</template>

<script>
	import config from '../config'
	import jandanComments from '../services/jandan-comments'
	const storage = weex.requireModule('storage')
	module.exports = {
		data(){
			return {
				config:config,
				isReadedSuportTips:true,
			}
		},
		created(){
			storage.getItem('isReadedSuportTips',(res)=>{
				if(res.result != 'success') {
					this.isReadedSuportTips = false
				}
			})
		},
		methods:{
			makeRead(){
				this.isReadedSuportTips = true
				storage.setItem('isReadedSuportTips','true',(res)=>{})
			}
		}
	}
</script>