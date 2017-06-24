<template>
	<div class="container">
		<div style="margin-top: 40px; flex-direction: row; background-color: white;">
			<div v-for="(v,i) in pics" :index="i" @click="click" style="flex: 1; align-items: center; justify-content: center; height: 88px; border-width: 1; border-color: #E3E3E3;">
				<text :style="{color: v.visibility == 'hidden' ? '#000000' : '#D62119'}">{{v.title}}</text>
			</div>
		</div>
		<embed v-for="(v,i) in pics" :src="v.src" :key="i" :style="{ visibility: v.visibility }" class="content"></embed>
	</div>
</template>

<script>
	import config from './config'
	module.exports = {
		data() {
			return {
				config: config,
				pics: [{
						title: '无聊图',
						src: config.js('pics-sub.js?type=boring'),
						visibility: 'visible'
					},
					{
						title: '煎蛋画师',
						src: config.js('pics-sub.js?type=huashi'),
						visibility: 'hidden'
					}
					
				]
			}
		},
		created(){
			if(config.level > 1) {
				this.pics.push({
						title: '妹子图',
						src: config.js('pics-sub.js?type=girl'),
						visibility: 'hidden'
				});
			}
		},
		methods: {
			click(e) {
				this.select(e.target.attr.index)
			},
			select: function(index) {
				for(var i = 0; i < this.pics.length; i++) {
					var item = this.pics[i];
					if(index == i) {
						item.visibility = 'visible'
					} else {
						item.visibility = 'hidden';
					}
				}
			},
		}
	}
</script>

<style>
	.container {
		background-color: #F3F3F3;
	}
	
	.content {
		position: absolute;
		top: 0;
		left: 0;
		right: 0;
		bottom: 0;
		margin-top: 128;
	}
</style>