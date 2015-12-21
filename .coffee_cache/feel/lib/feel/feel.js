(function() {
  var LoadSites, Server, Static, _beautify, _path, _readFile, _rmrf, _writeFile, coffee, curl, fs, mkdirp, readdir, spawn, unlink, watch, ycompress, yui,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  global.Q = require("q");

  Q.longStackSupport = true;

  global.CLONE = require('./lib/clone');

  _beautify = require('js-beautify');

  LoadSites = require('./scripts/loadSites');

  Server = require('./class/server/server');

  fs = require('fs');

  _path = require('path');

  mkdirp = require('mkdirp');

  unlink = Q.denodeify(fs.unlink);

  readdir = Q.denodeify(fs.readdir);

  spawn = require('child_process').spawn;

  watch = require('node-watch');

  coffee = require('coffee-script');

  Static = require('./class/static');

  _readFile = Q.denodeify(fs.readFile);

  _writeFile = Q.denodeify(fs.writeFile);

  _rmrf = Q.denodeify(require('rimraf'));

  yui = require('yuicompressor');

  ycompress = Q.denode(yui.compress);

  curl = function(url) {
    var def, http, req;
    def = Q.defer();
    http = require("http");
    req = http.get("http://127.0.0.1:8081" + url);
    req.on('finish', (function(_this) {
      return function() {
        return def.resolve();
      };
    })(this));
    return def.promise;
  };

  module.exports = (function() {
    function exports() {
      this.res500 = bind(this.res500, this);
      this.res403 = bind(this.res403, this);
      this.res404 = bind(this.res404, this);
      this.dycss = bind(this.dycss, this);
      this.ycss = bind(this.ycss, this);
      this.dyjs = bind(this.dyjs, this);
      this.yjs = bind(this.yjs, this);
      this.bjs = bind(this.bjs, this);
      this.bcss = bind(this.bcss, this);
      this.checkPages = bind(this.checkPages, this);
      this.loadClientDir = bind(this.loadClientDir, this);
      this.loadClient = bind(this.loadClient, this);
      this.compileSass = bind(this.compileSass, this);
      this.rebuildSass = bind(this.rebuildSass, this);
      this.watchHandler = bind(this.watchHandler, this);
      this.watch = bind(this.watch, this);
      this.npm = bind(this.npm, this);
      this.compass = bind(this.compass, this);
      this.qCacheCoffee = bind(this.qCacheCoffee, this);
      this.cacheCoffee = bind(this.cacheCoffee, this);
      this.qCacheFile = bind(this.qCacheFile, this);
      this.cacheFile = bind(this.cacheFile, this);
      this["const"] = bind(this["const"], this);
      this.checkCacheFile = bind(this.checkCacheFile, this);
      this.checkCacheDir = bind(this.checkCacheDir, this);
      this.checkCache = bind(this.checkCache, this);
      this.version = bind(this.version, this);
      this.createServer = bind(this.createServer, this);
      this.init = bind(this.init, this);
      global.Feel = this;
      this.site = {};
      this.sassChanged = {};
      this["static"] = new Static();
      this.path = {
        www: "www",
        cache: ".cache"
      };
    }

    exports.prototype.init = function() {
      return Q().then((function(_this) {
        return function() {
          return _this.version();
        };
      })(this)).then((function(_this) {
        return function() {
          if (_this.version === _this.oversion) {
            return;
          }
          return _rmrf('.cache').then(function() {
            return _rmrf('feel/.sass-cache');
          });
        };
      })(this)).then((function(_this) {
        return function() {
          return mkdirp('.cache');
        };
      })(this)).then((function(_this) {
        return function() {
          return _writeFile('.cache/version', _this.sVersion);
        };
      })(this)).then((function(_this) {
        return function() {
          return Q.async(function*() {
            _this.redis = (yield Main.service('redis'));
            _this.redis = (yield _this.redis.get());
            return (yield mkdirp('log'));
          })();
        };
      })(this)).then(this.checkCache).then(this.compass).then(LoadSites).then(this.watch).then(this["static"].init).then(this.loadClient).then(this.createServer);
    };

    exports.prototype.createServer = function() {
      this.server = new Server();
      return Q().then(this.server.init);
    };

    exports.prototype.version = function() {
      return _readFile('feel/version').then((function(_this) {
        return function(text) {
          var m, v;
          m = text.toString().match(/(\d+)\.(\d+)\.(\d+)/);
          v = (m[1] * 100 + m[2]) * 1000 + m[3];
          _this.version = v;
          _this.sVersion = text;
          return _readFile('.cache/version');
        };
      })(this)).then((function(_this) {
        return function(text) {
          var m, v;
          m = text.toString().match(/(\d+)\.(\d+)\.(\d+)/);
          v = (m[1] * 100 + m[2]) * 1000 + m[3];
          return _this.oversion = v;
        };
      })(this))["catch"]((function(_this) {
        return function(e) {
          return console.error(e);
        };
      })(this));
    };

    exports.prototype.checkCache = function() {
      return this.checkCacheDir(this.path.cache);
    };

    exports.prototype.checkCacheDir = function(dir) {
      return readdir(dir).then((function(_this) {
        return function(files) {
          var f, i, len, results, stat;
          results = [];
          for (i = 0, len = files.length; i < len; i++) {
            f = files[i];
            stat = fs.statSync(dir + "/" + f);
            if (stat.isDirectory()) {
              results.push(_this.checkCacheDir(dir + "/" + f));
            } else {
              results.push(_this.checkCacheFile(dir + "/" + f));
            }
          }
          return results;
        };
      })(this));
    };

    exports.prototype.checkCacheFile = function(file) {
      var sass;
      if (file.match(/.*(\.css)$/)) {
        sass = file.match(/^.cache\/(.*)\.css$/);
        if (sass[1] && ((!fs.existsSync("www/" + sass[1] + ".sass")) && (!fs.existsSync("www/" + sass[1] + ".scss")) && (!fs.existsSync("www/" + sass[1] + ".css")))) {
          return fs.unlinkSync(file);
        }
      }
    };

    exports.prototype["const"] = function(name) {
      return this.site['lessonhome']["const"][name];
    };

    exports.prototype.cacheFile = function(path, data, sfx) {
      var cache, cacheStat, cachedir, srcStat;
      if (sfx == null) {
        sfx = "";
      }
      path = _path.normalize(path);
      cache = path.replace(/^\w+\//, ".cache\/");
      cache = _path.normalize(cache + sfx);
      if (!cache.match(/^\.cache\//)) {
        cache = ".cache/" + cache;
      }
      if (cache === path) {
        return null;
      }
      cachedir = _path.dirname(cache);
      srcStat = fs.statSync(path);
      if (fs.existsSync(cache)) {
        cacheStat = fs.statSync(cache);
        if (cacheStat.isFile() && (cacheStat.mtime > srcStat.mtime) && (data == null)) {
          return fs.readFileSync(cache).toString();
        }
        if (cacheStat.isFile()) {
          fs.unlinkSync(cache);
        }
      }
      if (data == null) {
        return data;
      }
      if (!fs.existsSync(cachedir)) {
        mkdirp.sync(cachedir);
      }
      fs.writeFileSync(cache, data);
      return data;
    };

    exports.prototype.qCacheFile = function(path, data, sfx) {
      if (sfx == null) {
        sfx = "";
      }
      return Q.async((function(_this) {
        return function*() {
          var cache, cacheStat, cachedir, srcStat;
          path = _path.normalize(path);
          cache = path.replace(/^\w+\//, ".cache\/");
          cache = _path.normalize(cache + sfx);
          if (!cache.match(/^\.cache\//)) {
            cache = ".cache/" + cache;
          }
          if (cache === path) {
            return null;
          }
          cachedir = _path.dirname(cache);
          srcStat = (yield _stat(path));
          if ((yield _exists(cache))) {
            cacheStat = (yield _stat(cache));
            if (cacheStat.isFile() && (cacheStat.mtime > srcStat.mtime) && (data == null)) {
              return ((yield _readFile(cache))).toString();
            }
            if (cacheStat.isFile()) {
              (yield _unlink(cache));
            }
          }
          if (data == null) {
            return data;
          }
          if (!(yield _exists(cachedir))) {
            (yield _mkdirp(cachedir));
          }
          (yield _writeFile(cache, data));
          return data;
        };
      })(this))();
    };

    exports.prototype.cacheCoffee = function(path) {
      var data;
      data = this.cacheFile(path);
      if (data != null) {
        return data;
      }
      data = coffee._compileFile(path);
      return this.cacheFile(path, data);
    };

    exports.prototype.qCacheCoffee = function(path) {
      return Q.async((function(_this) {
        return function*() {
          var data;
          data = (yield _this.qCacheFile(path));
          if (data != null) {
            return data;
          }
          data = coffee._compileFile(path);
          return _this.qCacheFile(path, data);
        };
      })(this))();
    };

    exports.prototype.compass = function() {
      var compass, defer;
      defer = Q.defer();
      process.chdir('feel');
      console.log('compass compile'.magenta);
      compass = spawn('compass', ['compile']);
      process.chdir('..');
      compass.stdout.on('data', (function(_this) {
        return function(data) {
          var m;
          if (data.toString().substr(5, 9).match(/directory/mg)) {
            return;
          }
          if (data.toString().substr(9, 5).match(/write/)) {
            m = data.toString().substr(14).match(/.*(modules\/.*)\.css/);
            if (m) {
              return console.log("css\t\t".cyan, ("" + m[1]).grey);
            }
          } else {
            return process.stdout.write(data);
          }
        };
      })(this));
      compass.stderr.on('data', (function(_this) {
        return function(data) {
          return process.stderr.write('compass: ' + data);
        };
      })(this));
      compass.on('close', (function(_this) {
        return function(code) {
          if (code !== 0) {
            return defer.reject(new Error('compass failed'));
          } else {
            return defer.resolve();
          }
        };
      })(this));
      return defer.promise.then(Q.async((function(_this) {
        return function*() {
          var file, qs, readed;
          readed = (yield _readdirp({
            root: 'www/lessonhome/modules',
            fileFilter: '*.css'
          }));
          qs = (function() {
            var i, len, ref, results;
            ref = readed.files;
            results = [];
            for (i = 0, len = ref.length; i < len; i++) {
              file = ref[i];
              results.push(_fs_copy("www/lessonhome/modules/" + file.path, ".cache/lessonhome/modules/" + file.path, {
                clobber: true
              }));
            }
            return results;
          })();
          return (yield Q.all(qs));
        };
      })(this)));
    };

    exports.prototype.npm = function() {
      var defer, npm;
      defer = Q.defer();
      process.chdir('feel');
      console.log('npm install'.red);
      npm = spawn('npm', ['i']);
      process.chdir('..');
      npm.stdout.on('data', (function(_this) {
        return function(data) {
          return process.stdout.write(data);
        };
      })(this));
      npm.stderr.on('data', (function(_this) {
        return function(data) {
          return process.stderr.write(data);
        };
      })(this));
      npm.on('close', (function(_this) {
        return function(code) {
          if (code !== 0) {
            return defer.reject(new Error('npm i failed'));
          } else {
            return defer.resolve();
          }
        };
      })(this));
      return defer.promise;
    };

    exports.prototype.watch = function() {
      if (_production) {
        return;
      }
      return watch(this.path.www, {
        recursive: true
      }, this.watchHandler);
    };

    exports.prototype.watchHandler = function(file) {
      var m, o, ref, ref1;
      m = file.match(/^[^\/]+\/([^\/]+)\/([^\/]+)\/?(.*)\/([^\.][^\/]+)\.(\w+)$/);
      if (!m) {
        return;
      }
      o = {
        site: m[1],
        type: m[2],
        dir: m[3],
        name: m[4],
        ext: m[5]
      };
      if (o.type === 'modules') {
        switch (o.ext) {
          case 'sass':
          case 'scss':
          case 'css':
            this.rebuildSass(o.site, o.dir, o.name);
            break;
          case 'jade':
            if ((ref = this.site[o.site].modules[o.dir]) != null) {
              ref.rebuildJade();
            }
            break;
          case 'coffee':
            if ((ref1 = this.site[o.site].modules[o.dir]) != null) {
              ref1.rebuildCoffee();
            }
        }
      }
      if (o.type === 'states') {
        return this.site[o.site].loadStates();
      }
    };

    exports.prototype.rebuildSass = function(site, module, name) {
      var cache;
      console.log(("rebuild css for " + site + "/" + module + ":" + name).yellow);
      cache = this.path.cache + "/" + site + "/modules/" + module + "/" + name + ".css";
      this.sassChanged[site + "/" + module] = {
        site: site,
        module: module
      };
      return fs.exists(cache, (function(_this) {
        return function(ex) {
          if (!ex) {
            return _this.compileSass();
          }
          return fs.unlink(cache, function() {
            return _this.compileSass();
          });
        };
      })(this));
    };

    exports.prototype.compileSass = function() {
      this._compiling = true;
      return this.compass().then((function(_this) {
        return function() {
          var arr, key, ref, val;
          arr = [];
          ref = _this.sassChanged;
          for (key in ref) {
            val = ref[key];
            arr.push(val);
          }
          _this.sassChanged = {};
          return arr.reduce(function(promise, o) {
            var m;
            m = _this.site[o.site].modules[o.module];
            return promise.then(function() {
              return m.rescanFiles().then(m.makeSassAsync);
            });
          }, Q());
        };
      })(this))["catch"]((function(_this) {
        return function(e) {
          return console.error(Exception(e));
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._compiling = false;
        };
      })(this)).done();
    };

    exports.prototype.loadClient = function() {
      return Q.async((function(_this) {
        return function*() {
          var key, ref, val;
          _this.client = {};
          _this.clientJs = _this.cacheCoffee('feel/lib/feel/client.lib.coffee');
          _this.clientRegenerator = ((yield _readFile('feel/lib/feel/regenerator.runtime.js'))).toString();
          _this.clientRegeneratorHash = _shash(_this.clientRegenerator);
          (yield _this.loadClientDir('feel/lib/feel/client', ''));
          ref = _this.client;
          for (key in ref) {
            val = ref[key];
            if (key !== 'main') {
              _this.clientJs += val;
            }
          }
          _this.clientJs += _this.client['main'];
          _this.clientJs = _regenerator(_this.clientJs);
          return _this.clientJsHash = _shash(_this.clientJs);
        };
      })(this))();
    };

    exports.prototype.loadClientDir = function(path, dir) {
      return readdir("" + path + dir).then((function(_this) {
        return function(files) {
          var f, file, i, len, n, ndir, results, src, stat;
          results = [];
          for (i = 0, len = files.length; i < len; i++) {
            f = files[i];
            file = "" + path + dir + "/" + f;
            stat = fs.statSync(file);
            ndir = dir + "/" + f;
            if (stat.isDirectory()) {
              results.push(_this.loadClientDir(path, ndir));
            } else if (stat.isFile() && f.match(/^[^\.].*\.coffee$/)) {
              src = _this.cacheCoffee(file);
              n = ndir.match(/^\/(.*)\.coffee$/);
              results.push(_this.client[n[1]] = src);
            } else {
              results.push(void 0);
            }
          }
          return results;
        };
      })(this));
    };

    exports.prototype.checkPages = function() {
      var q, ref, ref1, site, sitename, state, statename;
      q = Q();
      ref = this.site;
      for (sitename in ref) {
        site = ref[sitename];
        ref1 = site.state;
        for (statename in ref1) {
          state = ref1[statename];
          if ((state["class"].prototype.route != null) && (state["class"].prototype.title != null) && (state["class"].prototype.model != null)) {
            (function(_this) {
              return (function(state, statename) {
                return q = q.then(function() {
                  return curl(state["class"].prototype.route);
                });
              });
            })(this)(state, statename);
          }
        }
      }
      return q;
    };

    exports.prototype.bcss = function(css) {
      return _beautify.css(css, {
        "indent-size": 2,
        "selector-separator-newline": true,
        "newline-between-rules": true
      });
    };

    exports.prototype.bjs = function(js) {
      return _beautify.js(js, {
        "indent_size": 2,
        "indent_char": " ",
        "indent_level": 1,
        "indent_with_tabs": false,
        "preserve_newlines": true,
        "max_preserve_newlines": 10,
        "jslint_happy": true,
        "space_after_anon_function": false,
        "brace_style": "collapse",
        "keep_array_indentation": false,
        "keep_function_indentation": false,
        "space_before_conditional": true,
        "break_chained_methods": false,
        "eval_code": false,
        "unescape_strings": false,
        "wrap_line_length": 0,
        "wrap_attributes": "auto",
        "wrap_attributes_indent_size": 4
      });
    };

    exports.prototype.yjs = function(js) {
      return Q.async((function(_this) {
        return function*() {
          var ret;
          ret = (yield ycompress(js, {
            type: 'js'
          }));
          if (typeof ret !== 'string') {
            ret = ret != null ? ret[0] : void 0;
          }
          return ret != null ? ret : "";
        };
      })(this))();
    };

    exports.prototype.dyjs = function(js) {
      return ycompress(js, {
        type: 'js'
      }).then((function(_this) {
        return function(yjs) {
          if (typeof yjs !== 'string') {
            yjs = yjs != null ? yjs[0] : void 0;
          }
          return _gzip(yjs != null ? yjs : "");
        };
      })(this));
    };

    exports.prototype.ycss = function(css) {
      return Q.async((function(_this) {
        return function*() {
          var ret;
          console.log('ycss');
          ret = (yield ycompress(css, {
            type: "css"
          }));
          if (typeof ret !== 'string') {
            ret = ret != null ? ret[0] : void 0;
          }
          return ret != null ? ret : "";
        };
      })(this))();
    };

    exports.prototype.dycss = function(css) {
      return ycompress(css, {
        type: "css"
      }).then((function(_this) {
        return function(ycss) {
          if (typeof ycss !== 'string') {
            ycss = ycss != null ? ycss[0] : void 0;
          }
          return _gzip(ycss != null ? ycss : "");
        };
      })(this));
    };

    exports.prototype.res404 = function(req, res, err) {
      if (err != null) {
        console.error(err);
      }
      req.url = '/404';
      res.statusCode = 404;
      return this.server.handler(req, res);
    };

    exports.prototype.res403 = function(req, res, err) {
      if (err != null) {
        console.error(err);
      }
      req.url = '/403';
      res.statusCode = 403;
      return this.server.handler(req, res);
    };

    exports.prototype.res500 = function(req, res, err) {
      if (err != null) {
        console.error(err);
      }
      req.url = '/500';
      res.statusCode = 500;
      return this.server.handler(req, res);
    };

    return exports;

  })();

}).call(this);
