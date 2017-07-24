const log = weex.requireModule('log')
var pageJS = weex.config.bundleUrl
pageJS = pageJS.substring(pageJS.lastIndexOf('/') + 1)
log.event(pageJS, pageJS)
/**
 * 展示内容等级： 1 普通， 2，17+
 * */
let level = 1;
module.exports = {
    level: level,
    js(jsURL) {
        var bundleUrl = weex.config.bundleUrl;
        var baseURL = bundleUrl.substring(0, bundleUrl.lastIndexOf("/") + 1)
        return baseURL + jsURL
    },
    image(imgURL) {
        // var url = "http://127.0.0.1:12580/resources/" + imgURL
        var url = "http://images-file.oss-cn-hangzhou.aliyuncs.com/weex/jandan/1.0.2/resources/" + imgURL
//		url += "?" + new Date().getTime()
        return url;
    },
    params(key) {
        var bundleUrl = weex.config.bundleUrl;
        var reg = new RegExp('[?|&]' + key + '=([^&]+)')
        var match = bundleUrl.match(reg)
        return match && match[1]
    },
    toParams(obj) {
        var param = ""
        for (const name in obj) {
            if (typeof obj[name] != 'function') {
                param += "&" + name + "=" + encodeURI(obj[name])
            }
        }
        return param.substring(1)
    },
    barHeight(){
        if (weex.config.env.platform == 'android') {
            return 98
        }
        return 128
    }
}