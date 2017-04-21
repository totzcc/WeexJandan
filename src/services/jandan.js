const stream = weex.requireModule('stream');
const storage = weex.requireModule('storage');
const html = weex.requireModule('html');

const duanURL = 'http://jandan.net/duan';
const duanPageURL = 'http://jandan.net/duan/page-{page}';

const jokeURL = 'http://jandan.net/duan';
const jokePageURL = 'http://jandan.net/duan/page-{page}';

const girlURL = 'http://jandan.net/ooxx';
const girlPageURL = 'http://jandan.net/ooxx/page-{page}';

const topURL = 'http://jandan.net/top';
const topPageURL = 'http://jandan.net/top/page-{page}';

var jokeVoteMaps = {};
storage.getItem('jokeVoteMaps',(res)=>{
	if(res.result == 'success') {
		jokeVoteMaps = JSON.parse(res.data)
	} else {
		jokeVoteMaps = {}
	}
});
module.exports = {
	article(){
		return new Promise((resolve)=>{
			stream.fetch({
				method: 'GET',
				url: 'http://jandan.net/',
				type: 'text'
			}, function(ret) {
				const datalist = []
				html.css(ret.data, '.list-post', (find) => {
					find.forEach((value)=>{
						var obj = {}
						html.css(value, '.thumbs_b img',(find) => {
							html.parse(find[0], (result) => {
								if(result.src) {
									obj['src'] = result.src
								} else {
									obj['src'] = result['data-original']
								}
								datalist.push(obj)
							})
						})
						html.css(value, 'h2 a',(find) => {
							html.parse(find[0], (result) => {
								obj['title'] = result.text
								obj['href'] = result.href
							})
						})
						html.css(value, '.time_s',(find) => {
							html.parse(find[0], (result) => {
								obj['author'] = result.text
							})
						})
						html.css(value, '.indexs',(find) => {
							var html = find[0]
							html = html.match(/<\/div>(\n+)?(.*)(\n+)?<a/)
							if(html) {
								html = html[0]
								html = html.replace('</div>','')
								html = html.replace('<a','').trim()
								obj['summary'] = html
							}
						})
						datalist.push(obj)
					})
				})
				setTimeout(()=>{
					resolve(datalist)
				},1000)
			});
		})
	},
	vote(jokeId, voteType){
		jokeVoteMaps[jokeId] = voteType
		storage.setItem('jokeVoteMaps',JSON.stringify(jokeVoteMaps))
		return new Promise((resolve)=>{
			stream.fetch({
				method: 'POST',
				url: 'http://jandan.net/jandan-vote.php',
				type: 'json',
				body:'id='+jokeId+'&vote_type='+ voteType
			}, (ret) => {
				resolve(ret.data)
			})
		})
	},
	list(type, page) {
		return new Promise((resolve) => {
			setTimeout(()=>{
				if(page) {
					this.listContext(type, page).then(datalist => {
						resolve({
							datalist: datalist
						})
					})
				} else {
					this.maxPage(type).then(maxPage => {
						this.listContext(type, maxPage).then((datalist) => {
							if(datalist.length <=8) {
								maxPage -= 1
								this.listContext(type, maxPage).then((newlist) => {
									datalist = datalist.concat(newlist)
									resolve({
										datalist: datalist,
										maxPage: maxPage
									})
								})
							} else {
								resolve({
									datalist: datalist,
									maxPage: maxPage
								})
							}
						});
					})
				}
			},500)
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
				html.css(ret.data, ".commentlist li", (data) => {
					var datalist = new Array()
					data.forEach((value) => {
						var obj = {}
						html.parse(value, (parse)=>{
							const id = parse.id.replace('comment-','')
							obj['id'] = id
							obj['vote'] = jokeVoteMaps[id]
						})
						html.css(value, '.author strong', (data) => {
							html.parse(data[0], (data) => {
								obj['author'] = data.text
							})
						})
						html.css(value, '.author small a', (data) => {
							html.parse(data[0], (data) => {
								obj['time'] = data.text
							})
						})
						html.css(value, '.text .view_img_link', (list) => {
							if(list.length == 0) {
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
							} else {
								list.forEach((value, index) => {
									obj['originImages'] = []
									html.parse(value, (value) => {
										if(value.href) {
											obj['originImages'].push(value.href)
										}
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
								});
							}
						})
						html.css(value, '.vote span', (list) => {
							html.parse(list[1], (value) => {
								if(value.text) {
									obj['support'] = parseInt(value.text)
								}
							})
							html.parse(list[2], (value) => {
								if(value.text) {
									obj['unsupport'] = parseInt(value.text)
								}
							})
						})
						datalist.push(obj)
					})
					setTimeout(() => {
						resolve(datalist)
					}, 500)
				})
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
				html.css(ret.data, '.current-comment-page', function(find) {
					html.parse(find[0], function(data) {
						var maxPage = data.text.replace('[', '')
						maxPage = maxPage.replace(']', '')
						resolve(maxPage)
					})
				})
			});

		});
	}
}