
const DEFAULT_OPTIONS = {

}

var MatcherCache = function() {
    this.cache = {}
    this.cachedKeys = []
    this.options = {
      limit: 200
    }
  }

MatcherCache.prototype = {
  set: function (key, value) {
    // If this key is not cached add key to cachedKeys array
    if (this.cache[key] === undefined) {
      this.cachedKeys.push(key)
    }
    this.cache[key] = value
    this.checkCacheLimit()
  },

  get: function (key) {
    return this.cache[key]
  },

  checkCacheLimit: function () {
    // Clear a cache item if we are over limit
    if (this.cachedKeys.length > this.options.limit) {
      const keyToUncache = this.cachedKeys.shift()
      delete this.cache[keyToUncache]
    }
  }
}

module.exports = MatcherCache
