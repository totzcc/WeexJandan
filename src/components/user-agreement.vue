<template>
	<navpage dataRole="none" :height="config.barHeight()" title="用户服务协议" backgroundColor="#ffffff" titleColor="#333333">
		<div style="flex: 1;">
			<web :src="config.image('userAgreement.html')" style="flex: 1;"></web>
			<div style="flex-direction: row;">
				<div style="height: 100px; width: 200px; background-color: #333333; justify-content: center; align-items: center;" @click="agree(0)">
					<text style="color: #FFFFFF;">我不同意</text>
				</div>
				<div style="height: 100px; flex: 1; background-color: #0088FB; justify-content: center; align-items: center;" @click="agree(1)">
					<text style="color: #FFFFFF;">我同意</text>
				</div>
			</div>
		</div>
	</navpage>
</template>

<script>
	let navigator = weex.requireModule('navigator')
	let modal = weex.requireModule('modal')
	let storage = weex.requireModule('storage')
	import config from '../config'
	export default {
		data: {
			config: config,
		},
		components: {
			navpage: require('../include/navpage.vue')
		},
		methods: {
			agree(type) {
				switch(type) {
					case 0:
						modal.toast({
							message:'不同意此协议您将无法使用此App, 请直接退出',
							duration:1
						})
					break;
					default:
						storage.setItem('agreeRegister','true')
						navigator.pop({}, () => {})
				}
			}
		}
	}
</script>

<style>

</style>