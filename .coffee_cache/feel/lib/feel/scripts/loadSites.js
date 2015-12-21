(function() {
  var Site, fs, readdir;

  fs = require('fs');

  readdir = Q.denodeify(fs.readdir);

  Site = require('../class/site.coffee');

  module.exports = function() {
    return Q().then(function() {
      return readdir(Feel.path.www);
    }).then(function(sites) {
      var i, len, sitename;
      for (i = 0, len = sites.length; i < len; i++) {
        sitename = sites[i];
        Feel.site[sitename] = new Site(sitename);
      }
      return sites.reduce((function(_this) {
        return function(promise, sitename) {
          return promise.then(Feel.site[sitename].init);
        };
      })(this), Q());
    });
  };

}).call(this);
