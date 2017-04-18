var history = require('history')

var __Weex_Router_History = [];

var History = {
  getHistoryInstance: function (url) {
    for ( var i = 0; i < __Weex_Router_History.length; i++) {
      if (__Weex_Router_History[i].url == url) {
        return __Weex_Router_History[i]
      }
    }
  },

  getBasename: function (url) {
    return this.getHistoryInstance(url).basename
  },

  getUrl: function (url) {
    return this.getHistoryInstance(url).url
  },

  getNavigator: function (url) {

  },

  createHistory: function (basename, url) {
    var instance = this.getHistoryInstance(url)
    if (!instance) {
      var historyInstance = history.createMemoryHistory({
        basename: basename || '',
        forceRefresh: false
      })

      instance = {
        history:historyInstance,
        url: url
      }

      __Weex_Router_History.push(instance)
    }
    return instance
  }
}

module.exports = History
