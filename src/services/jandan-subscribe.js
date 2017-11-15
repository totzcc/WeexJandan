import stream from './jandan-stream'
let storage = weex.requireModule('storage')
let app = weex.requireModule('app')
let subscribeStorageKey = 'subscribeStorageKey'
//let apiHost = "http://192.168.199.200:8088"
let apiHost = "http://svn.longxipu.cn:8088"
module.exports = {
	getSubscribe(){
		return new Promise((resolve)=>{
			app.getDeviceId((deviceId)=>{
				stream.fetch({
					url: apiHost + '/app/v1/subscribe',
					method:'GET',
					type:'json',
					headers:{deviceId:deviceId,platform:'android'}
				},(e) => {
					resolve(e.data)
				})
			})
		})
	},
	setSubscribe(subscribes) {
		app.getDeviceId((deviceId)=>{
			stream.fetch({
				url:apiHost + '/app/v1/subscribe',
				method:'POST',
				type:'json',
				headers:{deviceId:deviceId,platform:'android',"Content-Type":'application/json;charset=UTF-8'},
				body:JSON.stringify(subscribes)
			},(e) => {
				console.log(e)
			})
		})
		storage.setItem(subscribeStorageKey,JSON.stringify(subscribes))
	},
}
