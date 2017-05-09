const log = weex.requireModule('log');
module.exports = {
	js(jsURL) {
		var bundleUrl = weex.config.bundleUrl;
		var baseURL = bundleUrl.substring(0, bundleUrl.lastIndexOf("/") + 1)
		return baseURL + jsURL
	},
	image(imgURL) {
		return "http://images-file.oss-cn-hangzhou.aliyuncs.com/weex/jandan/1.0.1/resources/" + imgURL;
	},
	params(key) {
		var bundleUrl = weex.config.bundleUrl;
		var reg = new RegExp('[?|&]' + key + '=([^&]+)')
		var match = bundleUrl.match(reg)
		return match && match[1]
	},
	event(id) {
		log.event(id)
	},
}