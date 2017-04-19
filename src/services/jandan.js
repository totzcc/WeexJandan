var stream = weex.requireModule('stream');
var html = weex.requireModule('html');
var duanURL = 'http://jandan.net/duan/page-{page}';
module.exports = {
	duan(page){
		return new Promise((resolve)=>{
			if(page) {
				this.duanList(page).then((datalist) =>{
					resolve({
						datalist:datalist
					})
				})
			} else {
				this.duanMaxPage().then((maxPage)=>{
					this.duanList(maxPage).then((datalist)=>{
						resolve({
							datalist:datalist,
							maxPage:maxPage
						})
					})
				})
			}
		})
	},
	duanList(page){
		return new Promise((resolve)=>{
			stream.fetch({
			method: 'GET',
			url: duanURL.replace('{page}', page),
			type: 'text'
		}, (ret) => {
			if(!ret.ok) {
				console.log("request failed")
				console.log(duanURL.replace('{page}', page))
			} else {
				html.css(ret.data,".commentlist li",(data)=>{
					var datalist = new Array()
					data.forEach((value) =>{
						var obj = {}
						html.css(value,'.author',(data) => {
							html.parse(data[0],(data)=>{
								obj['author'] = data.text
							})
						})
						html.css(value,'.text p',(data)=>{
							data.forEach((value)=>{
								obj['text'] = ''
								html.parse(value,(data)=>{
									if(data.text) {
										obj['text'] += data.text + "\n"
									}
								})
							})
						})
						datalist.push(obj)
					})
					setTimeout(()=>{
						resolve(datalist)
					},500)
				})
			}
		});
		})
	},
	duanMaxPage:function(){
		return new Promise(function(resolve,reject){
			stream.fetch({
				method: 'GET',
				url: 'http://jandan.net/duan',
				type: 'text'
			}, function(ret) {
				if(!ret.ok) {
					console.log("request failed")
				} else {
					html.css(ret.data, '.current-comment-page',function(find){
						html.parse(find[0],function(data){
							var maxPage = data.text.replace('[','')
							maxPage = maxPage.replace(']','')
							resolve(maxPage)
						})
					})
				}
			});
			
		});
	}
}