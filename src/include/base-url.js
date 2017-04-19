exports.getBaseURL = function(vm) {
	var bundleUrl = weex.config.bundleUrl;
	var nativeBase;
	var isAndroidAssets = bundleUrl.indexOf('your_current_IP') >= 0 || bundleUrl.indexOf('file://assets/') >= 0;
	var isiOSAssets = bundleUrl.indexOf('file:///') >= 0 && bundleUrl.indexOf('WeexDemo.app') > 0;
	if(isAndroidAssets) {
		nativeBase = 'file://assets/';
	} else if(isiOSAssets) {
		nativeBase = bundleUrl.substring(0, bundleUrl.lastIndexOf('/') + 1);
	} else {
		var host = 'localhost:12580';
		var matches = /\/\/([^\/]+?)\//.exec(weex.config.bundleUrl);
		if(matches && matches.length >= 2) {
			host = matches[1];
		}
		nativeBase = 'http://' + host + '/dist/native/';
	}
	return nativeBase
}
exports.getUrlParam = function(key) {
	var reg = new RegExp('[?|&]' + key + '=([^&]+)')
	var match = weex.config.bundleUrl.search.match(reg)
	return match && match[1]
};