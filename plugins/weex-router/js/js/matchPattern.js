var  pathToRegexp = require('path-to-regexp')
var  MatcherCache =  require('./MatcherCache')

// cache[exactly][pattern] contains getMatcher(pattern, exactly)
const cache = {
  true: new MatcherCache(),
  false: new MatcherCache()
}

const getMatcher = function(pattern, exactly)  {
  const exactlyStr = exactly ? 'true' : 'false'
  var matcher = cache[exactlyStr].get(pattern)

  if (!matcher) {
    const keys = []
    const regex = pathToRegexp(pattern, keys, { end: exactly, strict: true })
    matcher = { keys: keys, regex: regex }
    cache[exactlyStr].set(pattern, matcher)
  }

  return matcher
}

const parseParams = function(pattern, match, keys) {
  return match.slice(1).reduce(function(params, value, index)  {
    params[keys[index].name] = decodeURIComponent(value)
    return params
  }, {})
}

const matchPattern = function(pattern, location, matchExactly, parent)  {
  const specialCase = !matchExactly && pattern === '/'

  if (specialCase) {
    return {
      params: null,
      isExact: location.pathname === '/',
      pathname: '/'
    }
  } else {
    if (parent && pattern.charAt(0) !== '/') {
      pattern = parent.pathname +
        (parent.pathname.charAt(parent.pathname.length - 1) !== '/' ? '/' : '') +
        pattern
    }

    const matcher = getMatcher(pattern, matchExactly)
    const match = matcher.regex.exec(location.pathname)

    if (match) {
      const params = parseParams(pattern, match, matcher.keys)
      const pathname = match[0]
      const isExact = pathname === location.pathname

      return { params: params, isExact: isExact, pathname: pathname, keys: matcher.keys }
    } else {
      return null
    }
  }
}

module.exports =  matchPattern
