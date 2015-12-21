(function() {
  var FileUpload, Form, Module, Router, State, _path, fs, readdir,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  State = require('./state');

  Module = require('./module');

  fs = require('fs');

  readdir = Q.denodeify(fs.readdir);

  Router = require('./server/router');

  _path = require('path');

  FileUpload = require('./server/fileupload');

  Form = require('./form');

  module.exports = (function() {
    function exports(name1) {
      this.name = name1;
      this.status = bind(this.status, this);
      this.res304 = bind(this.res304, this);
      this.res404 = bind(this.res404, this);
      this.moduleJsFileTag = bind(this.moduleJsFileTag, this);
      this.moduleJsTag = bind(this.moduleJsTag, this);
      this.moduleJsFileUrl = bind(this.moduleJsFileUrl, this);
      this.moduleJsUrl = bind(this.moduleJsUrl, this);
      this.handler = bind(this.handler, this);
      this.dataObject = bind(this.dataObject, this);
      this.createModules = bind(this.createModules, this);
      this.loadModules = bind(this.loadModules, this);
      this.createState = bind(this.createState, this);
      this.createStates = bind(this.createStates, this);
      this.loadStates = bind(this.loadStates, this);
      this.configDir = bind(this.configDir, this);
      this.configInit = bind(this.configInit, this);
      this.readConsts = bind(this.readConsts, this);
      this.init = bind(this.init, this);
      this.cacheRes = {};
      this.path = {};
      this.path.root = Feel.path.www + "/" + this.name;
      this.path.src = this.path.root + "/";
      this.path.states = this.path.src + "/states";
      this.path["const"] = this.path.src + "/const";
      this.path.modules = this.path.src + "/modules";
      this.path.config = this.path.root + "/config";
      this.path.cache = Feel.path.cache + "/" + this.name;
      this.path.sass = this.path.cache + "/modules";
      this["const"] = {};
      this.constJson = "";
      this.config = {};
      this.state = {};
      this.nstate = {};
      this.modules = {};
      this.router = new Router(this);
      this.fileupload = new FileUpload(this);
    }

    exports.prototype.init = function() {
      return Q.async((function(_this) {
        return function*() {
          var file, fname, ref;
          _this.db = (yield Main.service('db'));
          _this.register = (yield Main.service('register'));
          _this.servicesIp = JSON.stringify((yield ((yield Main.service('services'))).get()));
          _this.form = new Form;
          _this.urldata = (yield Main.service('urldata'));
          Feel.udata = _this.urldata;
          _this.urldataFiles = (yield _this.urldata.getFFiles());
          _this.urldataFilesStr = "";
          ref = _this.urldataFiles;
          for (fname in ref) {
            file = ref[fname];
            _this.urldataFilesStr += "<script>window._FEEL_that = $Feel.urlforms['" + fname + "'] = {};</script>";
            _this.urldataFilesStr += "<script type='text/javascript' src='/urlform/" + file.hash + "/" + fname + "'></script>";
          }
          _this.urldataFilesStr += "<script>$Feel.urldataJson = " + ((yield _this.urldata.getJsonString())) + ";</script>";
          (yield _this.readConsts());
          (yield _this.form.init());
          (yield _this.fileupload.init());
          (yield _this.configInit());
          (yield _this.loadModules());
          (yield _this.loadStates());
          return (yield _this.router.init());
        };
      })(this))();
    };

    exports.prototype.readConsts = function() {
      return Q.async((function(_this) {
        return function*() {
          var file, files, i, readed, w8for;
          _this["const"] = {};
          readed = (yield _readdirp({
            root: 'www/lessonhome/const',
            fileFilter: '*.coffee'
          }));
          files = (function() {
            var j, len, ref, results;
            ref = readed.files;
            results = [];
            for (j = 0, len = ref.length; j < len; j++) {
              file = ref[j];
              results.push(file.path);
            }
            return results;
          })();
          w8for = (function() {
            var j, len, results;
            results = [];
            for (i = j = 0, len = files.length; j < len; i = ++j) {
              file = files[i];
              results.push(this["const"][file.replace(/\.coffee$/, '')] = require(process.cwd() + '/www/lessonhome/const/' + file));
            }
            return results;
          }).call(_this);
          (yield Q.all(w8for));
          return _this.constJson = JSON.stringify(_this["const"]);
        };
      })(this))();
    };

    exports.prototype.configInit = function() {
      if (!fs.existsSync(this.path.config)) {
        return Q();
      }
      if (!fs.statSync(this.path.config).isDirectory()) {
        return Q();
      }
      return this.configDir(this.path.config);
    };

    exports.prototype.configDir = function(dir) {
      return readdir(dir).then((function(_this) {
        return function(files) {
          return files.reduce(function(promise, file) {
            var cfg, key, stat, val;
            stat = fs.statSync(dir + "/" + file);
            if (stat.isDirectory()) {
              return promise.then(function() {
                return _this.configDir(dir + "/" + file);
              });
            }
            if (stat.isFile()) {
              if (!file.match(/^(\w.*\.coffee)$/)) {
                return promise;
              }
              cfg = require(process.cwd() + ("/" + dir + "/" + file));
              for (key in cfg) {
                val = cfg[key];
                _this.config[key] = val;
              }
              return promise;
            }
          }, Q());
        };
      })(this));
    };

    exports.prototype.loadStates = function() {
      return Q.async((function(_this) {
        return function*() {
          var key, ref, val;
          ref = _this.state;
          for (key in ref) {
            val = ref[key];
            delete _this.state[key];
          }
          return (yield _this.createStates(_this.path.states, ""));
        };
      })(this))();
    };

    exports.prototype.createStates = function(path, dir) {
      return Q.async((function(_this) {
        return function*() {
          return (yield readdir(path).then(function(files) {
            return files.reduce(function(promise, filename) {
              var name, stat;
              stat = fs.statSync(path + "/" + filename);
              if (stat.isDirectory()) {
                return promise.then(function() {
                  return _this.createStates(path + "/" + filename, dir + filename + "/");
                });
              }
              if (stat.isFile() && filename.match(/^\w.*\.coffee$/) && !filename.match(/^.*\.[c|d]\.coffee$/)) {
                name = dir + filename.match(/^(.*)\.\w+$/)[1];
                return promise.then(function() {
                  return _this.createState(name);
                });
              }
              return promise;
            }, Q());
          }));
        };
      })(this))();
    };

    exports.prototype.createState = function(name) {
      if (name.match(/^test/)) {
        return;
      }
      if (this.state[name] == null) {
        this.state[name] = new State(this, name);
        this.state[name].init();
        if (this.state[name]["class"] == null) {
          delete this.state[name];
        }
        return;
      }
      if (!this.state[name].inited) {
        throw new Error("create state '" + name + "' circular depend");
      }
    };

    exports.prototype.loadModules = function() {
      return this.createModules(this.path.modules, "");
    };

    exports.prototype.createModules = function(path, dir) {
      return Q.async((function(_this) {
        return function*() {
          var filename, files, fn, j, len, module, q;
          module = {};
          module.files = {};
          files = (yield readdir(path));
          q = Q();
          fn = function(filename) {
            return q = q.then(function() {
              return Q.async(function*() {
                var filepath, reg, stat;
                stat = (yield _stat(path + "/" + filename));
                if (stat.isDirectory()) {
                  (yield _this.createModules(path + "/" + filename, dir + filename + "/"));
                }
                if (stat.isFile() && dir && !filename.match(/^\..*$/)) {
                  reg = filename.match(/^(.*)\.(\w+)$/);
                  filepath = path + "/" + filename;
                  if (reg) {
                    return module.files[filename] = {
                      name: reg[1],
                      ext: reg[2],
                      path: filepath
                    };
                  } else {
                    return module.files[filename] = {
                      name: filename,
                      ext: "",
                      path: filepath
                    };
                  }
                }
              })();
            });
          };
          for (j = 0, len = files.length; j < len; j++) {
            filename = files[j];
            fn(filename);
          }
          (yield q);
          if (!dir) {
            return;
          }
          module.name = dir.match(/^(.*)\/$/)[1];
          _this.modules[module.name] = new Module(module, _this);
          return _this.modules[module.name].init();
        };
      })(this))();
    };

    exports.prototype.dataObject = function(name, context) {
      var file, key, m, obj, p, postfix, ref, s, suffix, val;
      suffix = "";
      postfix = name;
      file = "";
      m = name.match(/^(\w)\:(.*)$/);
      if (m) {
        suffix = m[1];
        postfix = m[2];
      }
      suffix = (function() {
        switch (suffix) {
          case 's':
            return 'states';
          case 'm':
            return 'modules';
          case 'r':
            return 'runtime';
          default:
            return '';
        }
      })();
      m = context.match(/^(\w+)\/(.*)$/);
      s = m[1];
      p = m[2];
      if (postfix.match(/^\./)) {
        if (!suffix) {
          suffix = s;
        }
        file = _path.normalize(this.path.src + "/" + suffix + "/" + p + "/" + postfix + ".d.coffee");
      } else if (postfix.match(/^\//)) {
        if (!suffix) {
          suffix = "runtime";
        }
        file = _path.normalize(this.path.src + "/" + suffix + postfix + ".d.coffee");
      } else {
        if (!suffix) {
          suffix = "runtime";
        }
        file = _path.normalize(this.path.src + "/" + suffix + "/" + postfix + ".d.coffee");
      }
      delete require.cache[require.resolve(process.cwd() + "/" + file)];
      obj = require(process.cwd() + "/" + file);
      for (key in obj) {
        val = obj[key];
        if (typeof val === 'function') {
          if ((val != null ? (ref = val.constructor) != null ? ref.name : void 0 : void 0) === 'GeneratorFunction') {
            obj[key] = Q.async(val);
          } else {
            (function(obj, key, val) {
              return obj[key] = function() {
                var args;
                args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
                return Q.then(function() {
                  return val.apply(obj, args);
                });
              };
            })(obj, key, val);
          }
        }
      }
      obj.$db = this.db;
      return obj;
    };

    exports.prototype.handler = function(req, res, site) {
      var data, fname, hash, m, module, ref, ref1, ref2, ref3, ref4, ref5, zlib;
      if (req.url.match(/^\/upload\//)) {
        return this.fileupload.handler(req, res);
      }
      if (req.url.match(/^\/uploaded\//)) {
        return this.fileupload.uploaded(req, res);
      }
      if (req.url.match(/\.\./)) {
        if (!m) {
          return Feel.res404(req, res);
        }
      }
      if (m = req.url.match(/^\/js\/(\w+)\/(.+)$/)) {
        hash = m[1];
        module = m[2];
        data = (ref = this.modules[module]) != null ? ref.allJs : void 0;
        hash = (ref1 = this.modules[module]) != null ? ref1.jsHash : void 0;
      } else if (m = req.url.match(/^\/jsfile\/(\w+)\/(.+)\/([\w-\.]+)$/)) {
        hash = m[1];
        module = m[2];
        fname = m[3];
        data = (ref2 = this.modules[module]) != null ? ref2.jsfile(fname) : void 0;
        hash = (ref3 = this.modules[module]) != null ? ref3.jsHash : void 0;
      } else if (m = req.url.match(/^\/jsfilet\/(\w+)\/(.+)\/([\w-\.]+)$/)) {
        hash = m[1];
        module = m[2];
        fname = m[3];
        data = (ref4 = this.modules[module]) != null ? ref4.jsfilet(fname) : void 0;
        hash = (ref5 = this.modules[module]) != null ? ref5.jsHash : void 0;
      } else if (m = req.url.match(/^\/urlform\/(\w+)\/(.*)$/)) {
        hash = m[1];
        module = m[2];
        data = this.urldataFiles[module];
        if (!data.src) {
          return Feel.res404(req, res);
        }
        hash = data.hash;
        data = data.src;
      } else if (m = req.url.match(/^\/jsclient\/(\w+)\/(client)$/)) {
        hash = m[1];
        module = m[2];
        data = "(function(){" + Feel.clientJs + "}).call($Feel);";
        hash = Feel.clientJsHash;
      } else if (m = req.url.match(/^\/jsclient\/(\w+)\/(regenerator)$/)) {
        hash = m[1];
        module = m[2];
        data = Feel.clientRegenerator;
        hash = Feel.clientRegeneratorHash;
      }
      if (data != null) {
        res.setHeader("Content-Type", "text/javascript; charset=utf-8");
        if (hash) {
          if (req.headers['if-none-match'] === hash) {
            return this.res304(req, res);
          }
          res.setHeader('ETag', hash);
          res.setHeader('Cache-Control', 'public, max-age=126144001');
          res.setHeader('Cache-Control', 'public, max-age=126144001');
          res.setHeader('Expires', "Thu, 07 Mar 2086 21:00:00 GMT");
        }
        zlib = require('zlib');
        return zlib.gzip(data, {
          level: 9
        }, (function(_this) {
          return function(err, resdata) {
            if (err != null) {
              return Feel.res500(req, res, err);
            }
            res.statusCode = 200;
            res.setHeader('Content-Length', resdata.length);
            res.setHeader('Content-Encoding', 'gzip');
            return res.end(resdata);
          };
        })(this));
      }
      return Feel.res404(req, res);
    };

    exports.prototype.moduleJsUrl = function(name) {
      var hash, ref;
      hash = (ref = this.modules[name]) != null ? ref.jsHash : void 0;
      return "/js/" + hash + "/" + name;
    };

    exports.prototype.moduleJsFileUrl = function(name, fname) {
      var hash, ref;
      hash = (ref = this.modules[name]) != null ? ref.jsHash : void 0;
      return "/jsfilet/" + hash + "/" + name + "/" + fname;
    };

    exports.prototype.moduleJsTag = function(name) {
      return "<script type='text/javascript' src='" + (this.moduleJsUrl(name)) + "'></script>";
    };

    exports.prototype.moduleJsFileTag = function(name, fname) {
      return "<script type='text/javascript' src='" + (this.moduleJsFileUrl(name, fname)) + "'></script>";
    };

    exports.prototype.res404 = function(req, res, err) {
      res.writeHead(404);
      res.end();
      if (err != null) {
        return console.error('error', err);
      }
    };

    exports.prototype.res304 = function(req, res) {
      res.writeHead(304);
      return res.end();
    };

    exports.prototype.status = function(req, res, name, value) {
      return Q.async((function(_this) {
        return function*() {
          var db, ref, status;
          db = (yield _this.db.get('accounts'));
          status = (yield _invoke(db.find({
            id: req.user.id
          }, {
            status: 1
          }), 'toArray'));
          status = status != null ? (ref = status[0]) != null ? ref.status : void 0 : void 0;
          if (status == null) {
            status = {};
          }
          if ((value != null) && status[name] !== value) {
            status[name] = value;
            (yield _invoke(db, 'update', {
              id: req.user.id
            }, {
              $set: {
                status: status
              }
            }, {
              upsert: true
            }));
          }
          return status[name];
        };
      })(this))();
    };

    return exports;

  })();

}).call(this);
