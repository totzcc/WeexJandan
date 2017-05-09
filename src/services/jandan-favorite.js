const favortesKey = 'jandan-favorite-favorites'
const storage = weex.requireModule('storage')
import md5 from './md5.js'

var favortesData = {md5Maps:{},favortes:[]}
storage.getItem(favortesKey,(res)=>{
	if(res.result == 'success') {
		favortesData = JSON.parse(res.data)
	}
})
module.exports = {
	isLike(href){
		return favortesData.md5Maps[md5(href)] == true
	},
	toggleLike(href,title,img){
		const isLike = favortesData.md5Maps[md5(href)] == true
		favortesData.md5Maps[md5(href)] = !isLike
		if(isLike) {
			delete favortesData.md5Maps[md5(href)]
			for(var index = 0; index < favortesData.favortes.length; index ++ ){
				if(favortesData.favortes[index].href == href) {
					removeByArrays(favortesData.favortes, index)
					break;
				}
			}
		} else {
			favortesData.favortes.unshift({
				href:href,
				title:title,
				img:img
			})
		}
		
		storage.setItem(favortesKey,JSON.stringify(favortesData))
		return !isLike
	},
	getFavortesData(){
		return new Promise((resolve,reject) => {
			storage.getItem(favortesKey,(res)=>{
				setTimeout(()=>{
					resolve(favortesData)
				},500)
			})
		})
	},
}

/** 
 *删除数组指定下标或指定对象 
 */
function removeByArrays(arrays,obj) {
	for(var i = 0; i < arrays.length; i++) {
		var temp = arrays[i];
		if(!isNaN(obj)) {
			temp = i;
		}
		if(temp == obj) {
			for(var j = i; j < arrays.length; j++) {
				arrays[j] = arrays[j + 1];
			}
			arrays.length = arrays.length - 1;
		}
	}
}