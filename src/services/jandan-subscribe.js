let stream = weex.requireModule('stream')
let storage = weex.requireModule('storage')
let app = weex.requireModule('app')
let subscribeStorageKey = 'subscribeStorageKey'
module.exports = {
	getSubscribe(){
		return new Promise((resolve)=>{
			storage.getItem(subscribeStorageKey,(e)=>{
				if(e.result == 'success') {
					resolve(JSON.parse(e.data))
				} else {
					resolve([])
				}
			})
		})
	},
	setSubscribe(subscribes) {
		storage.setItem(subscribeStorageKey,JSON.stringify(subscribes))
	}
}
