const JANDAN_USER_INFO = "JANDAN_USER_INFO"
const storage = weex.requireModule('storage')
const html = weex.requireModule('html')
import config from '../config'
import stream from './jandan-stream'
var userInfo = {author:'',email:''}
var jokeVoteMaps = {}
storage.getItem(JANDAN_USER_INFO,(res)=>{
	if(res.result == 'success') {
		userInfo = JSON.parse(res.data)
	}
})
storage.getItem('jokeVoteMaps',(res)=>{
	if(res.result == 'success') {
		jokeVoteMaps = JSON.parse(res.data)
	}
})

module.exports = {
	comments(url, page){
        url = url.replace("http://www.jandan.net", "http://i.jandan.net");
        url = url.replace("http://jandan.net", "http://i.jandan.net");
        return new Promise((resolve) => {
            stream.fetch({
                method: 'GET',
                url: url,
                cache:false,
                type: 'text'
            }, function(ret) {
                html.css(ret.data,'.commentlist li', find =>{
                    var result = {
                        postId:'',
                        datalist:[]
                    }
                    find.forEach(item => {

						let obj = {};
                        html.css(item,'b', (find) => {
                            html.parse(find[0], (parse)=>{
                                obj['author'] = parse.text;
							})
						})
                        html.css(item,'.time', (find) => {
                            html.parse(find[0], (parse)=>{
                                obj['time'] = parse.text;
                            })
                        })
                        html.css(item,'.righttext', (find) => {
                            html.parse(find[0], (parse)=>{
                                obj['id'] = parse.text;
                            })
                        })
						html.css(item,'.commenttext', (find) => {
                            html.parse(find[0], (parse)=>{
                                obj['title'] = parse.text;
                            })
                        })
                        html.css(item,'.jandan-vote span', (find) => {
                            html.parse(find[1], (parse)=>{
                                obj['support'] = parse.text;
                            })
                            html.parse(find[3], (parse)=>{
                                obj['unsupport'] = parse.text;
                            })
                        })
                        result.datalist.push(obj)
                        setTimeout(()=>{
                            resolve(result)
                        },200)
					})
                })
            })
		})
	},
	getCommentCount(url){
		return new Promise((resolve, reject) => {
			stream.fetch({
				method: 'GET',
				url: url,
				cache:true,
				type: 'text'
			}, function(ret) {
				html.css(ret.data,'#comments h3', find =>{
					if(find.length > 0) {
						html.parse(find[0], parse => {
							resolve(parse.text.trim().substr(2,1))
						})
					} else {
						resolve(0)
					}
				})
			})
		})
	},
	request(url){
		return new Promise((resolve) =>{
			stream.fetch({
				method: 'GET',
				url: url,
				type: 'text'
			}, function(ret) {
				resolve(ret.data)
			})
		})
	},
	submitComment(postId,comment, type){
		if(type == 'comment') {
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
		} else {
			return new Promise((resolve,reject) => {
				const param = {
					author:userInfo.author,
					email:userInfo.email,
					content:comment,
					comment_id:postId
				}
				stream.fetch({
					method: 'POST',
					url: 'http://jandan.net/jandan-tucao.php',
					type: 'json',
					body:config.toParams(param)
				}, (ret) => {
					resolve(ret.data)
				})
			})
		}
	},
	vote(jokeId, voteType){
		jokeVoteMaps[jokeId] = voteType
		storage.setItem('jokeVoteMaps',JSON.stringify(jokeVoteMaps))
		return new Promise((resolve)=>{
			var body;
			if(voteType == 1) {
				body = "comment_id="+jokeId+"&like_type=pos&data_type=comment"
			} else {
				body = "comment_id="+jokeId+"&like_type=neg&data_type=comment"
			}
			stream.fetch({
				method: 'POST',
				url: 'http://jandan.net/jandan-vote.php',
				type: 'json',
				body:body
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
			storage.getItem(JANDAN_USER_INFO,(res)=>{
				if(res.result == 'success') {
					userInfo = JSON.parse(res.data)
				}
				resolve(userInfo)
			})
		})
	}
}
