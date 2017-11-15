const stream = weex.requireModule('stream')
const storage = weex.requireModule('storage')
module.exports = {
	fetch(option,callback){
		if (option.cache === true) {
			storage.getItem(option.url,(event) => {
				if(event.result === 'success') {
					console.log('read web cache:' + option.url)
					callback(JSON.parse(event.data))
				} else {
					stream.fetch(option,(res) => {
						console.log('write web cache:' + option.url)
						storage.setItem(option.url,JSON.stringify(res))
						callback(res)
					})
				}
			})
		} else {
			console.log('don\'t read cache:' + option.url)
			stream.fetch(option, (res) => {
				storage.setItem(option.url,JSON.stringify(res))
				callback(res)
			})
		}
	}
}
