<template>
	<div style="flex-direction: column;">
		<tabbar :tabItems="tabItems"></tabbar>
	</div>
</template>

<script>
	import config from './config'
	module.exports = {
		data() {
			return {
				dir: 'examples',
				tabItems: [{
					index: 0,
					title: '文章',
					titleColor: '#000000',
					icon: '',
					image: config.image('article-normal.png'),
					selectedImage: config.image('article-highlight.png'),
//					src: config.js('pics.js'),
					src: config.js('article.js'),
//					src: config.js('joke.js'),
					visibility: 'visible',
				},{
					index: 1,
					title: '段子',
					titleColor: '#000000',
					icon: '',
					image: config.image('joke-normal.png'),
					selectedImage: config.image('joke-highlight.png'),
					src: config.js('joke.js?type=joke'),
					visibility: 'visible',
				},{
					index: 2,
					title: '蛋图',
					titleColor: '#000000',
					icon: '',
					image: config.image('boring-normal.png'),
					selectedImage: config.image('boring-highlight.png'),
					src: config.js('pics.js'),
					visibility: 'hidden',
				},
				{
					index: 3,
					title: '我的',
					titleColor: '#000000',
					icon: '',
					image: config.image('my-normal.png'),
					selectedImage: config.image('my-highlight.png'),
					src: config.js('my.js'),
					visibility: 'hidden',
				}],
			}
		},
		components: {
			tabbar: require('./include/tabbar.vue')
		}
	}
</script>