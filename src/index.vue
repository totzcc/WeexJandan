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
//					src: config.js('girl.js?type=girl'),
					src: config.js('article.js'),
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
					title: '妹子',
					titleColor: '#000000',
					icon: '',
					image: config.image('girl-normal.png'),
					selectedImage: config.image('girl-highlight.png'),
					src: config.js('girl.js?type=girl'),
					visibility: 'hidden',
				}],
			}
		},
		components: {
			tabbar: require('./include/tabbar.vue')
		}
	}
</script>