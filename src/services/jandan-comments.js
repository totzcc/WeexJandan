const JANDAN_USER_INFO = "JANDAN_USER_INFO"
const stream = weex.requireModule('stream')
const storage = weex.requireModule('storage')
const html = weex.requireModule('html')
import config from '../config'

var userInfo = {author:'小小小不点',email:'totzcc@163.com'}
storage.getItem(JANDAN_USER_INFO,(res)=>{
	if(res.result == 'success') {
		userInfo = JSON.parse(res.data)
	}
})
module.exports = {
	comments(url, page){
		return new Promise((resolve) => {
			if(!page) {
				this.commentsMaxPage(url).then((page)=>{
					page = page.trim()
					if(page) {
						url = url + "/page-"+page+"#comments"
					}
					this.commentsList(url).then((result)=>{
						resolve({maxPage:page,datalist:result.comments, postId:result.postId})
					})
				})
			} else {
				this.commentsList(url + "/page-"+page+"#comments").then((result)=>{
					resolve({datalist:result.comments, postId:result.postId})
				})
			}
		})
	},
	commentsList(url){
		return new Promise((resolve)=>{
			stream.fetch({
				method: 'GET',
				url: url,
				type: 'text'
			}, function(ret) {
				var result = {
					postId:'',
					comments:[]
				}
				html.css(ret.data, '.current-post', (find) => {
					html.parse(find[0], (parse) => {
						result.postId = parse.id
					})
				})
				html.css(ret.data,'.commentlist .row',(find) =>{
					const datalist = []
					find.forEach((value) => {
						const obj = {}
						html.css(value,'.author strong',(find) => {
							html.parse(find[0], (parse) => {
								obj['author'] = parse.text
							})
						})
						html.css(value,'.author small',(find) => {
							html.parse(find[0], (parse) => {
								obj['time'] = parse.text
							})
						})
						
						html.css(value,'.text p',(find) => {
							html.parse(find[0], (parse) => {
								obj['title'] = parse.text
							})
						})
						html.css(value,'.righttext a',(find) => {
							html.parse(find[0], (parse) => {
								obj['id'] = parse.text
							})
						})
						
						html.css(value,'.vote span',(find) => {
							html.parse(find[1], (parse) => {
								obj['support'] = parse.text
							})
							html.parse(find[2], (parse) => {
								obj['unsupport'] = parse.text
							})
						})
						datalist.push(obj)
					})
					setTimeout(()=>{
						result.comments = datalist;
						resolve(result)
					},200)
				})
			})
		})
	},
	commentsMaxPage(url){
		return new Promise((resolve) =>{
			stream.fetch({
				method: 'GET',
				url: url,
				type: 'text'
			}, function(ret) {
				html.css(ret.data,'.current-comment-page',(find) =>{
					html.parse(find[0], function(data) {
						var maxPage = data.text.replace('[', '')
						maxPage = maxPage.replace(']', '')
						resolve(maxPage)
					})
				})
			})
		})
	},
	submitComment(postId,comment){
		return new Promise((resolve,reject) => {
			const param = {
				author:userInfo.author,
				email:userInfo.email,
				comment:comment,
				comment_post_ID:postId
			}
			stream.fetch({
				method: 'POST',
				url: 'http://jandan.net/jandan-comment.php',
				type: 'json',
				body:config.toParams(param)
			}, (ret) => {
				resolve(ret.data)
			})
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
	setUserInfo(author,email){
		userInfo.author = author
		userInfo.email = email
		storage.setItem(JANDAN_USER_INFO,JSON.stringify(userInfo))
	},
	getUserInfo(){
		return new Promise((resolve)=>{
			setTimeout(()=>{
				resolve(userInfo)
			},500)
		})
	}
}
