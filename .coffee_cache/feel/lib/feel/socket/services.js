(function() {
  var Services,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Services = (function() {
    function Services() {
      this.get = bind(this.get, this);
      $W(this);
      this.services = {};
      this.startPort = 8900;
    }

    Services.prototype.init = function*() {
      var file, files, i, o, readed, w8for;
      readed = (yield _readdirp({
        root: 'www/lessonhome',
        fileFilter: '*.c.coffee'
      }));
      files = (function() {
        var j, len, ref, results;
        ref = readed.files;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          file = ref[j];
          results.push(file.path.replace(/\.c\.coffee$/, ''));
        }
        return results;
      })();
      w8for = (function() {
        var j, len, results;
        results = [];
        for (i = j = 0, len = files.length; j < len; i = ++j) {
          file = files[i];
          o = this.services[file] = {};
          o.port = this.startPort + i;
          results.push(Main.serviceManager.master.runService('socket2', {
            file: file,
            port: o.port
          }));
        }
        return results;
      }).call(this);
      return (yield Q.all(w8for));
    };

    Services.prototype.get = function() {
      return this.services;
    };

    return Services;

  })();

  module.exports = Services;

}).call(this);
