module.exports = {
	js(jsURL) {
		var bundleUrl = weex.config.bundleUrl;
		var baseURL = bundleUrl.substring(0, bundleUrl.lastIndexOf("/") + 1)
		return baseURL + jsURL
	},
	image(imgURL) {
		var bundleUrl = weex.config.bundleUrl;
		var baseURL = bundleUrl.substring(0, bundleUrl.lastIndexOf("dist")) + "resources/"
		return baseURL + imgURL + '?t=' + new Date().getTime()
	},
	params(key) {
		var bundleUrl = weex.config.bundleUrl;
		var reg = new RegExp('[?|&]' + key + '=([^&]+)')
		var match = bundleUrl.match(reg)
		return match && match[1]
	}
}