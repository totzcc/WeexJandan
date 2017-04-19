<template>
	<div style="flex-direction: column;">
		<tabbar :tabItems="tabItems"></tabbar>
	</div>
</template>

<script>
	var getBaseURL = require('./include/base-url.js').getBaseURL
	module.exports = {
		data: function() {
			return {
				dir: 'examples',
				tabItems: [{
					index: 0,
					title: '段子',
					titleColor: '#000000',
					icon: '',
					image: '/resources/joke-normal.png',
					selectedImage: '/resources/joke-highlight.png',
					src: 'joke.js?type=joke',
					visibility: 'visible',
				},{
					index: 1,
					title: '妹子',
					titleColor: '#000000',
					icon: '',
					image: '/resources/girl-normal.png',
					selectedImage: '/resources/girl-highlight.png',
					src: 'joke.js?type=girl',
					visibility: 'hidden',
				}],
			}
		},
		components: {
			tabbar: require('./include/tabbar.vue')
		},
		created: function() {
			var baseURL = getBaseURL(this)
			for(var i = 0; i < this.tabItems.length; i++) {
				var tabItem = this.tabItems[i];
				tabItem.src = baseURL + tabItem.src;
			}
		}
	}
</script>