
const history = require('./history')

module.exports = {

  push: function(url, options){
    options = options? options :{}
    const Navigator = history.getNavigator()
    Navigator.push({
      url:url,
      animated : options.animated ? "true" : "false"
    }, function(){})
  },

  pop: function(options){
    options = options? options : {animated:"true"}
    const Navigator = history.getNavigator()
    var params = {
      animated : options.animated ? "true" : "false"
    }
    Navigator.pop(params, function(){})
  }

}