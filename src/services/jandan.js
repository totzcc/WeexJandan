
const storage = weex.requireModule('storage')
const browser = weex.requireModule('browser')
const html = weex.requireModule('html')
const navigator = weex.requireModule('navigator')

const duanURL = 'http://jandan.net/duan'
const duanPageURL = 'http://jandan.net/duan/page-{page}'

const jokeURL = 'http://jandan.net/duan'
const jokePageURL = 'http://jandan.net/duan/page-{page}'

const girlURL = 'http://jandan.net/ooxx'
const girlPageURL = 'http://jandan.net/ooxx/page-{page}'

const topURL = 'http://jandan.net/top'
const topPageURL = 'http://jandan.net/top/page-{page}'

const boringURL = "http://jandan.net/pic"
const boringPageURL = "http://jandan.net/pic/page-{page}"

const drawingsURL = "http://jandan.net/drawings"
const drawingsPageURL = "http://jandan.net/drawings/page-{page}"

var jokeVoteMaps = {}
var readMaps = {}

var callbackSleepTime = 1000
import md5 from './md5.js'
import config from '../config'
import stream from './jandan-stream'
storage.getItem('jokeVoteMaps', (res) => {
    if (res.result == 'success') {
        jokeVoteMaps = JSON.parse(res.data)
    }
})

storage.getItem('readMaps', (res) => {
    if (res.result == 'success') {
        readMaps = JSON.parse(res.data)
    }
})
function makeRead(text) {
    readMaps[md5(text)] = true
    storage.setItem('readMaps', JSON.stringify(readMaps))
}
function isRead(text) {
    return readMaps[md5(text)] == true
}
module.exports = {
    makeRead(text){
        makeRead(text)
    },
    isRead(text){
        isRead(text)
    },
    toDetail(item){
        item.href = item.href.replace("http://www.jandan.net", "http://i.jandan.net");
        item.href = item.href.replace("http://jandan.net", "http://i.jandan.net");
        storage.setItem('article-detail',JSON.stringify(item), ()=>{
            navigator.push({url:config.js('article-detail.js')})
        })
    },
    toCommentsDetail(item){
        storage.setItem('article-detail',JSON.stringify(item), ()=>{
            navigator.push({url: config.js('comments.js')}, () => {})
        })
    },
    category(category, page) {
        category = encodeURI(category)
        return new Promise((resolve) => {
            var url = "http://jandan.net/tag/" + category + "/page/" + page
            stream.fetch({
                method: 'GET',
                url: url,
                type: 'text'
            }, function (ret) {
                const datalist = []
                html.css(ret.data, "#content .column", (find) => {
                    find.forEach((value) => {
                        const obj = {}
                        html.css(value, '.time_s a', (find) => {
                            html.parse(find[0], (parse) => {
                                obj['author'] = parse.text
                            })
                        })
                        html.css(value, '.thumbs_b img', (find) => {
                            html.parse(find[0], (parse) => {
                                obj['img'] = parse['data-original']
                            })
                        })
                        html.css(value, '.title2 a', (find) => {
                            html.parse(find[0], (parse) => {
                                obj['title'] = parse.text
                                obj['isRead'] = isRead(parse.text)
                                obj['href'] = parse.href
                            })
                        })
                        datalist.push(obj)
                    })
                })
                setTimeout(() => {
                    resolve(datalist)
                }, callbackSleepTime)
            })
        })
    },
    categoryIndex(){
        return new Promise((resolve) => {
            stream.fetch({
                method: 'GET',
                url: 'http://jandan.net/',
                type: 'text',
                cache: true
            }, function (ret) {

                html.css(ret.data, '.tag-cloud thead tr th', (find) => {
                    const datalist = []
                    const trs = []
                    html.css(ret.data, '.tag-cloud tbody tr', (find) => {
                        find.forEach((value) => {
                            html.css(value, 'a', (find) => {
                                const tds = []
                                find.forEach((value) => {
                                    html.parse(value, (parse) => {
                                        let category = parse.text;
                                        if (category.indexOf("何其低俗焉") != -1) {
                                            if (config.level <= 1) {
                                                return;
                                            }
                                        }
                                        tds.push(parse.text)
                                    })
                                })
                                trs.push(tds)
                            })
                        })
                    })
                    setTimeout(() => {
                        find.forEach((value, index) => {
                            const obj = {}
                            html.parse(value, (parse) => {
                                obj.title = parse.text
                                obj.categorys = []
                                trs.forEach((value) => {
                                    obj.categorys.push({title: value[index]})
                                })
                                datalist.push(obj)
                            })
                        })
                        setTimeout(() => {
                            resolve(datalist)
                        }, 200)
                    }, 200)
                })
            })
        })
    },
    article(page){
        return new Promise((resolve) => {
            if (!page || page < 2) {
                page = 2
            }
            const url = "http://jandan.net/page/" + page
            stream.fetch({
                    method: 'GET',
                    url: url,
                    type: 'text'
                }, function (ret) {
                    const datalist = []
                    html.css(ret.data, "#content .column", (find) => {
                        find.forEach((value) => {
                            const obj = {}
                            html.css(value, '.time_s a', (find) => {
                                html.parse(find[0], (parse) => {
                                    obj['category'] = parse.text
                                })
                            })
                            html.css(value, '.thumbs_b img', (find) => {
                                html.parse(find[0], (parse) => {
                                    obj['img'] = parse['data-original']
                                })
                            })
                            html.css(value, '.title2 a', (find) => {
                                html.parse(find[0], (parse) => {
                                    obj['title'] = parse.text
                                    obj['isRead'] = isRead(parse.text)
                                    obj['href'] = parse.href
                                })
                            })
                            datalist.push(obj)
                        })
                    })
                    setTimeout(() => {
                        resolve(datalist)
                    }, callbackSleepTime)
                }
            )
        })
    },
    articleIndex(){
        return new Promise((resolve) => {
            stream.fetch({
                method: 'GET',
                url: 'http://jandan.net/',
                type: 'text'
            }, function (ret) {
                const datalist = []
                html.css(ret.data, '.list-post', (find) => {
                    find.forEach((value) => {
                        var obj = {}
                        html.css(value, '.thumbs_b img', (find) => {
                            html.parse(find[0], (result) => {
                                if (result.src) {
                                    obj['img'] = result.src
                                } else {
                                    obj['img'] = result['data-original']
                                }
                                datalist.push(obj)
                            })
                        })
                        html.css(value, 'h2 a', (find) => {
                            html.parse(find[0], (result) => {
                                obj['title'] = result.text
                                obj['isRead'] = isRead(result.text)
                                obj['href'] = result.href
                            })
                        })
                        html.css(value, '.time_s', (find) => {
                            html.parse(find[0], (result) => {
                                obj['author'] = result.text
                            })
                        })
                        html.css(value, '.comment-link', (find) => {
                            html.parse(find[0], (result) => {
                                obj['comments'] = result.text
                                obj['commentTime'] = result.title
                            })
                        })
                        html.css(value, '.indexs', (find) => {
                            var html = find[0]
                            html = html.match(/<\/div>(\n+)?(.*)(\n+)?<a/)
                            if (html) {
                                html = html[0]
                                html = html.replace('</div>', '')
                                html = html.replace('<a', '').trim()
                                obj['summary'] = html
                            }
                        })
                    })
                })
                setTimeout(() => {
                    resolve(datalist)
                }, callbackSleepTime)
            })
        })
    },
    list(type, page, cache) {
        return new Promise((resolve) => {
            setTimeout(() => {
                if (page) {
                    this.listContext(type, page, cache).then(datalist => {
                        resolve({
                            datalist: datalist
                        })
                    })
                } else {
                    this.maxPage(type, cache).then(maxPage => {
                        this.listContext(type, maxPage, cache).then((datalist) => {
                            if (datalist.length <= 8) {
                                maxPage -= 1
                                this.listContext(type, maxPage, cache).then((newlist) => {
                                    datalist = datalist.concat(newlist)
                                    resolve({
                                        datalist: datalist,
                                        maxPage: maxPage
                                    })
                                })
                            } else {
                                resolve({
                                    datalist: datalist,
                                    maxPage: maxPage
                                })
                            }
                        })
                    })
                }
            }, 500)
        })
    },
    listContext(type, page, cache) {
        var requestURL = ''
        if (type == 'girl') {
            requestURL = girlPageURL
        } else if (type == 'joke') {
            requestURL = jokePageURL
        } else if (type == 'boring') {
            requestURL = boringPageURL
        } else if (type == 'huashi') {
            requestURL = drawingsPageURL;
        } else {
            requestURL = topPageURL
        }
        return new Promise((resolve) => {
            stream.fetch({
                method: 'GET',
                url: requestURL.replace('{page}', page),
                type: 'text',
                cache: cache
            }, (ret) => {
                html.css(ret.data, ".commentlist li", (data) => {
                    var datalist = new Array()
                    data.forEach((value) => {
                        var obj = {}
                        html.parse(value, (parse) => {
                            const id = parse.id.replace('comment-', '')
                            obj['id'] = id
                            obj['vote'] = jokeVoteMaps[id]
                        })
                        html.css(value, '.author strong', (data) => {
                            html.parse(data[0], (data) => {
                                obj['author'] = data.text
                            })
                        })
                        html.css(value, '.author small a', (data) => {
                            html.parse(data[0], (data) => {
                                obj['time'] = data.text
                            })
                        })
                        html.css(value, '.text .view_img_link', (list) => {
                            html.css(value, '.text p', (list) => {
                                list.forEach((value, index) => {
                                    obj['title'] = ''
                                    html.parse(value, (value) => {
                                        if (value.text) {
                                            obj['title'] += value.text.replace("[查看原图]", "")
                                            if (index != list.length - 1) {
                                                obj['title'] += "\n"
                                            }
                                        }
                                    })
                                })
                            })
                            list.forEach((value, index) => {
                                obj['originImages'] = []
                                html.parse(value, (value) => {
                                    if (value.href) {
                                        obj['originImages'].push(value.href)
                                    }
                                })
                            })
                            html.css(value, '.text img', (list) => {
                                list.forEach((value, index) => {
                                    obj['imgs'] = []
                                    html.parse(value, (value) => {
                                        if (value.src) {
                                            obj['imgs'].push(value.src)
                                        }
                                        if (!obj['isGIF']) {
                                            obj['isGIF'] = value.src.toLowerCase().indexOf('.gif') > -1
                                        }
                                    })
                                })
                            })
                        })
                        html.css(value, '.jandan-vote span', (list) => {
                            html.parse(list[1], (value) => {
                                if (value.text) {
                                    obj['support'] = parseInt(value.text)
                                }
                            })
                            html.parse(list[3], (value) => {
                                if (value.text) {
                                    obj['unsupport'] = parseInt(value.text)
                                }
                            })
                        })
                        html.css(value, '.tucao-btn', (find) => {
                            html.parse(find[0], (value) => {
                                var tucao = value.text;
                                tucao = tucao.substring(tucao.indexOf('[') + 1, tucao.indexOf(']'))
                                obj['tucao'] = tucao
                            })
                        })
                        datalist.push(obj)
                    })
                    setTimeout(() => {
                        resolve(datalist)
                    }, callbackSleepTime)
                })
            })
        })
    },
    maxPage(type, cache) {
        var requestURL = ""
        if (type == 'girl') {
            requestURL = girlURL
        } else if (type == 'joke') {
            requestURL = jokeURL
        } else if (type == 'boring') {
            requestURL = boringURL
        } else if (type == 'huashi') {
            requestURL = drawingsURL
        } else {
            requestURL = topURL
        }
        return new Promise(function (resolve, reject) {
            stream.fetch({
                method: 'GET',
                url: requestURL,
                type: 'text',
                cache: cache
            }, function (ret) {
                html.css(ret.data, '.current-comment-page', function (find) {
                    html.parse(find[0], function (data) {
                        var maxPage = data.text.replace('[', '')
                        maxPage = maxPage.replace(']', '')
                        resolve(maxPage)
                    })
                })
            })

        })
    }
}