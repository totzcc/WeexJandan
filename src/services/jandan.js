const stream = weex.requireModule('stream');
const html = weex.requireModule('html');
const duanURL = 'http://jandan.net/duan';
const duanPageURL = 'http://jandan.net/duan/page-{page}';

const jokeURL = 'http://jandan.net/duan';
const jokePageURL = 'http://jandan.net/duan/page-{page}';

const girlURL = 'http://jandan.net/ooxx';
const girlPageURL = 'http://jandan.net/ooxx/page-{page}';

const topURL = 'http://jandan.net/top';
const topPageURL = 'http://jandan.net/top/page-{page}';
module.exports = {
	list(type, page) {
		return new Promise((resolve) => {
			if(page) {
				this.listContext(type, page).then(datalist => {
					resolve({
						datalist: datalist
					})
				})
			} else {
				this.maxPage(type).then(page => {
					return this.listContext(type, page).then((datalist) => {
						resolve({
							datalist: datalist,
							maxPage: page
						})
					});
				})
			}
		})
	},
	listContext(type, page) {
		var requestURL = ''
		if(type == 'girl') {
			requestURL = girlPageURL
		} else if(type == 'joke'){
			requestURL = jokePageURL
		} else {
			requestURL = topPageURL
		}
		return new Promise((resolve) => {
			stream.fetch({
				method: 'GET',
				url: requestURL.replace('{page}', page),
				type: 'text'
			}, (ret) => {
				if(!ret.ok) {
					console.log("request failed")

				} else {
					html.css(ret.data, ".commentlist li", (data) => {
						var datalist = new Array()
						data.forEach((value) => {
							var obj = {}
							html.css(value, '.author strong', (data) => {
								html.parse(data[0], (data) => {
									obj['author'] = data.text
								})
							})
							html.css(value, '.text p', (list) => {
								list.forEach((value, index) => {
									obj['text'] = ''
									html.parse(value, (value) => {
										if(value.text) {
											obj['text'] += value.text
											if(index != list.length - 1) {
												obj['text'] += "\n"
											}
										}
									})
								})
							})
							html.css(value, '.text img', (list) => {
								list.forEach((value, index) => {
									obj['imgs'] = []
									html.parse(value, (value) => {
										if(value.src) {
											obj['imgs'].push(value.src)
										}
									})
								})
							})
							datalist.push(obj)
						})
						setTimeout(() => {
							datalist.forEach((value) => {
								if(value.imgs && value.imgs.length>0) {
									value.text = ''
								}
							})
							resolve(datalist)
						}, 500)
					})
				}
			});
		})
	},
	maxPage(type) {
		var requestURL = ""
		if(type == 'girl') {
			requestURL = girlURL
		} else if(type == 'joke'){
			requestURL = jokeURL
		}else {
			requestURL = topURL
		}
		return new Promise(function(resolve, reject) {
			stream.fetch({
				method: 'GET',
				url: requestURL,
				type: 'text'
			}, function(ret) {
				if(!ret.ok) {
					console.log("request failed")
				} else {
					html.css(ret.data, '.current-comment-page', function(find) {
						html.parse(find[0], function(data) {
							var maxPage = data.text.replace('[', '')
							maxPage = maxPage.replace(']', '')
							resolve(maxPage - 1)
						})
					})
				}
			});

		});
	}
}