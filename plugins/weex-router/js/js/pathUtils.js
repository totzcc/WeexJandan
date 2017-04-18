module.exports = {
  addLeadingSlash : function (path) {
    return path.charAt(0) === '/' ? path : '/' + path
  },

  stripLeadingSlash : function (path) {
    return path.charAt(0) === '/' ? path.substr(1) : path
  },

  stripPrefix : function (path, prefix) {
     return  path.indexOf(prefix) === 0 ? path.substr(prefix.length) : path
  },

  getRealURL: function (url) {
    var bundleUrl = decodeURIComponent(url);
    var realURL =  bundleUrl.split("#")[1]||"/"
    var lastIndexOf = realURL.lastIndexOf("random=")
    if(lastIndexOf !== -1){
      realURL = realURL.substring(0,lastIndexOf);
    }

    if(realURL.endsWith("&")){
      realURL = realURL.substring(0, realURL.length-1)
    }

    if(realURL.endsWith("?")){
      realURL = realURL.substring(0, realURL.length-1)
    }

    return realURL

  },
  nomalizeBundleUrl: function (bundleUrl) {
    var url  = decodeURIComponent(bundleUrl)
    var result = url.match(/(.+)(&random=-?\d+\b)/)
    if(result){
      url = result[1]
    }
    return url;
  },

  addTimestamp: function(url){
    if(/_w_r_t_/.test(url)){
      url = url.replace(/_w_r_t_=\d+/, '_w_r_t_='+Date.now())
    }
    else {
      url+="&_w_r_t_="+ Date.now();
    }

    return url;
  },

  createPath : function (location)  {
    const pathname = location.pathname, search = location.search, hash = location.hash

    var path = pathname || '/'

    if (search && search !== '?')
      path += (search.charAt(0) === '?' ? search : '?'+search)

    if (hash && hash !== '#')
      path += (hash.charAt(0) === '#' ? hash : '#'+hash)

    return path
  },

  parsePath :function (path)  {
    var pathname = path || '/'
    var search = ''
    var hash = ''

    const hashIndex = pathname.indexOf('#')
    if (hashIndex !== -1) {
      hash = pathname.substr(hashIndex+1)
      pathname = pathname.substr(0, hashIndex)
    }

    const searchIndex = pathname.indexOf('?')
    if (searchIndex !== -1) {
      search = pathname.substr(searchIndex+1)
      pathname = pathname.substr(0, searchIndex)
    }

    return {
      pathname:pathname,
      search: search === '?' ? '' : search,
      hash: hash === '#' ? '' : hash
    }
  }
}

