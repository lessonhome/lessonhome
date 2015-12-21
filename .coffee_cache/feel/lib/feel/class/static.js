(function() {
  var Static, _path, crypto, fs, mime, mkdirp, watch,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  fs = require('fs');

  crypto = require('crypto');

  watch = require('watch');

  _path = require('path');

  mime = require('mime');

  mkdirp = require('mkdirp');

  Static = (function() {
    function Static() {
      this.part = bind(this.part, this);
      this.urlS = bind(this.urlS, this);
      this.url = bind(this.url, this);
      this.hashS = bind(this.hashS, this);
      this.hash = bind(this.hash, this);
      this.res404 = bind(this.res404, this);
      this.F = bind(this.F, this);
      this.write = bind(this.write, this);
      this.res303 = bind(this.res303, this);
      this.res304 = bind(this.res304, this);
      this.handler = bind(this.handler, this);
      this.createHashS = bind(this.createHashS, this);
      this.deleteHash = bind(this.deleteHash, this);
      this.setHash = bind(this.setHash, this);
      this.createHash = bind(this.createHash, this);
      this.checkHash = bind(this.checkHash, this);
      this.mremoved = bind(this.mremoved, this);
      this.mchanged = bind(this.mchanged, this);
      this.mcreated = bind(this.mcreated, this);
      this.watch = bind(this.watch, this);
      this.init = bind(this.init, this);
      this.files = {};
    }

    Static.prototype.init = function() {
      return this.watch();
    };

    Static.prototype.watch = function() {
      var q;
      if (_production) {
        return;
      }
      q = Q();
      return watch.createMonitor('./', (function(_this) {
        return function(monitor) {
          _this.monitor = monitor;

          /*
          for file,stat of @monitor.files
            if file.match /^www\/\w+\/static\/.*\.\w+$/
              if stat.isFile()
                do (file,stat)=> q = q.then =>
                  process.stdout.write '.'
                  Q.rdenode(@createHash) file,stat
          q.done()
           */
          if (_production) {
            return _this.monitor.stop();
          } else {
            _this.monitor.on('created', _this.mcreated);
            _this.monitor.on('changed', _this.mchanged);
            return _this.monitor.on('removed', _this.mremoved);
          }
        };
      })(this));
    };

    Static.prototype.mcreated = function(f, stat) {
      return this.checkHash(f, stat);
    };

    Static.prototype.mchanged = function(f, stat, pstat) {
      return this.checkHash(f, stat);
    };

    Static.prototype.mremoved = function(f, stat) {
      if (this.watch[f]) {
        return delete this.watch[f];
      }
    };

    Static.prototype.checkHash = function(f, stat, cb) {
      f = _path.resolve(f);
      if (this.watch[f] == null) {
        return typeof cb === "function" ? cb() : void 0;
      }
      return this.createHash(f, stat, cb);
    };

    Static.prototype.createHash = function(f, stat, cb) {
      var fd, sha1;
      f = _path.resolve(f);
      if (stat == null) {
        return fs.exists(f, (function(_this) {
          return function(exists) {
            if (!exists) {
              _this.deleteHash(f);
              return typeof cb === "function" ? cb() : void 0;
            }
            return fs.stat(f, function(err, stats) {
              if (err || !stats.isFile()) {
                _this.deleteHash(f);
                return typeof cb === "function" ? cb() : void 0;
              }
              return _this.createHash(f, stats, cb);
            });
          };
        })(this));
      }
      sha1 = crypto.createHash('sha1');
      sha1.setEncoding('hex');
      if (stat.size > 10 * 1024 * 1024) {
        sha1.update(JSON.stringify(stat));
        this.setHash(f, sha1.digest('hex').substr(0, 10));
        return typeof cb === "function" ? cb(this.watch[f]) : void 0;
      }
      fd = fs.createReadStream(f);
      fd.on('end', (function(_this) {
        return function() {
          var hash;
          sha1.end();
          hash = sha1.read();
          _this.setHash(f, hash);
          return typeof cb === "function" ? cb(_this.watch[f]) : void 0;
        };
      })(this));
      return fd.pipe(sha1);
    };

    Static.prototype.setHash = function(f, hash) {
      var cacheDir;
      this.watch[f] = hash.substr(0, 10);
      cacheDir = _path.dirname(".cache/monitor/" + f.replace(process.cwd() + "\/", ""));
      return mkdirp(cacheDir, (function(_this) {
        return function() {};
      })(this));
    };

    Static.prototype.deleteHash = function(f) {
      if (this.watch[f] != null) {
        return delete this.watch[f];
      }
    };

    Static.prototype.createHashS = function(f, stat) {
      var exists, sha1;
      f = _path.resolve(f);
      if (stat == null) {
        exists = fs.existsSync(f);
        if (!exists) {
          return this.deleteHash(f);
        }
        stat = fs.statSync(f);
        if (!(stat != null ? typeof stat.isFile === "function" ? stat.isFile() : void 0 : void 0)) {
          return this.deleteHash(f);
        }
        return this.createHashS(f, stat);
      }
      sha1 = crypto.createHash('sha1');
      sha1.setEncoding('hex');
      if (stat.size > 100 * 1024 * 1024) {
        sha1.update(JSON.stringify(stat));
      } else {
        sha1.update(fs.readFileSync(f));
      }
      this.setHash(f, sha1.digest('hex'));
      return this.watch[f];
    };

    Static.prototype.handler = function(req, res, site) {
      var fname, hash, hhash, m, path;
      m = req.url.match(/^\/file\/(\w+)\/([^\.].*)\.(\w+)$/);
      if (!m) {
        return Feel.res404(req, res);
      }
      if (m[2].match(/\.\./)) {
        if (!m) {
          return Feel.res404(req, res);
        }
      }
      hash = m[1];
      fname = m[2] + "." + m[3];
      path = "./www/" + site + "/static/" + fname;
      hhash = req.headers['if-none-match'];
      if (hhash == null) {
        hhash = 2;
      }
      return this.hash(path, (function(_this) {
        return function(rhash) {
          var ext;
          if (rhash == null) {
            rhash = 1;
          }
          res.setHeader('ETag', rhash);
          res.setHeader('Cache-Control', 'public, max-age=126144001');
          res.setHeader('Expires', "Thu, 07 Mar 2086 21:00:00 GMT");
          if ((rhash === hash && hash === hhash)) {
            return _this.res304(req, res);
          }
          if (rhash !== hash) {
            return _this.url(fname, site, function(url) {
              return _this.res303(req, res, url);
            });
          }
          ext = m[3];
          if (_this.files[path] != null) {
            return _this.write(_this.files[path], req, res);
          }
          return fs.readFile(path, function(err, data) {
            return fs.stat(path, function(err2, stat) {
              if ((err != null) || (err2 != null)) {
                return Feel.res500(req, res, err || err2);
              }
              _this.files[path] = {
                data: data,
                mime: mime.lookup(path),
                stat: stat,
                name: fname
              };
              return _this.write(_this.files[path], req, res);
            });
          });
        };
      })(this));
    };

    Static.prototype.res304 = function(req, res) {
      res.writeHead(304);
      return res.end();
    };

    Static.prototype.res303 = function(req, res, location) {
      if (req.url === location) {
        return Feel.res500(req, res);
      }
      res.statusCode = 303;
      res.setHeader('Location', location);
      return res.end();
    };

    Static.prototype.write = function(file, req, res) {
      var zlib;
      res.setHeader('Content-type', file.mime);
      zlib = require('zlib');
      return zlib.gzip(file.data, {
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
    };

    Static.prototype.F = function(site, file) {
      var f, hash;
      f = _path.resolve("www/" + site + "/static/" + file);
      if (this.watch[f] != null) {
        hash = this.watch[f];
      } else {
        hash = this.hashS(f);
      }
      return "/file/" + hash + "/" + file;
    };

    Static.prototype.res404 = function(req, res, err) {
      res.writeHead(404);
      res.end();
      if (err != null) {
        return console.error(err);
      }
    };

    Static.prototype.hash = function(f, cb) {
      var hash;
      f = _path.resolve(f);
      if (this.watch[f] != null) {
        return cb(this.watch[f]);
      }
      hash = this.createHash(f, null, cb);
      if (hash == null) {
        hash = 666;
      }
      return hash;
    };

    Static.prototype.hashS = function(f) {
      var hash;
      f = _path.resolve(f);
      if (this.watch[f] != null) {
        return this.watch[f];
      }
      hash = this.createHashS(f);
      if (hash == null) {
        hash = 666;
      }
      return hash;
    };

    Static.prototype.url = function(f, site, cb) {
      return this.hash("www/" + site + "/static/" + f, (function(_this) {
        return function(hash) {
          if (hash == null) {
            hash = 666;
          }
          return cb("/file/" + hash + "/" + f);
        };
      })(this));
    };

    Static.prototype.urlS = function(f, site) {
      var hash;
      hash = this.hashS("www/" + site + "/static/" + f);
      if (hash == null) {
        hash = 666;
      }
      return "/file/" + hash + "/" + f;
    };

    Static.prototype.part = function(name, site, data) {
      return name = (".cache/part/" + site + "/") + _path.normalize(name);
    };

    return Static;

  })();

  module.exports = Static;

}).call(this);
