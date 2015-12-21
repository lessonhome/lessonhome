(function() {
  var _path, coffee, crypto, escapeRegExp, fs, jade, jade_runtime, key, readdir, readfile, replaceAll, val,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  jade_runtime = require('./runtime.js');

  jade = require('jade');

  for (key in jade_runtime) {
    val = jade_runtime[key];
    if (typeof val === "function") {
      (function(_this) {
        return (function(key, val) {
          return jade[key] = function() {
            return val.apply(jade_runtime, arguments);
          };
        });
      })(this)(key, val);
    }
  }

  fs = require('fs');

  coffee = require('coffee-script');

  crypto = require('crypto');

  _path = require('path');

  readdir = Q.denodeify(fs.readdir);

  readfile = Q.denodeify(fs.readFile);

  escapeRegExp = function(string) {
    return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
  };

  replaceAll = function(string, find, replace) {
    return string.replace(new RegExp(escapeRegExp(find), 'g'), replace);
  };

  module.exports = (function() {
    function exports(module, site) {
      this.site = site;
      this.hash = bind(this.hash, this);
      this.setHash = bind(this.setHash, this);
      this.makeJs = bind(this.makeJs, this);
      this.jsNames = bind(this.jsNames, this);
      this.jsfilet = bind(this.jsfilet, this);
      this.jsfile = bind(this.jsfile, this);
      this.makeCoffee = bind(this.makeCoffee, this);
      this.parseCss = bind(this.parseCss, this);
      this.makeAllCss = bind(this.makeAllCss, this);
      this.getCssRelativeTo = bind(this.getCssRelativeTo, this);
      this.getAllCssExt = bind(this.getAllCssExt, this);
      this.makeSassAsync = bind(this.makeSassAsync, this);
      this.makeSass = bind(this.makeSass, this);
      this.doJade = bind(this.doJade, this);
      this.rebuildCoffee = bind(this.rebuildCoffee, this);
      this.rebuildJade = bind(this.rebuildJade, this);
      this.makeJade = bind(this.makeJade, this);
      this.replacer2 = bind(this.replacer2, this);
      this.replacer = bind(this.replacer, this);
      this.rescanFiles = bind(this.rescanFiles, this);
      this.init = bind(this.init, this);
      this.files = module.files;
      this.name = module.name;
      this.id = module.name.replace(/\//g, '-');
      this.jade = {};
      this.css = {};
      this.cssSrc = {};
      this.allCssRelative = {};
      this.coffee = {};
      this.coffeenr = {};
      this.js = {};
      this.allCss = "";
      this.allCoffee = "";
      this.allJs = "";
      this.jsHash = '666';
      this.coffeeHash = '666';
    }

    exports.prototype.init = function() {
      return Q().then(this.makeJade).then(this.makeSass).then(this.makeAllCss).then(this.makeCoffee);
    };

    exports.prototype.rescanFiles = function() {
      return readdir(this.site.path.modules + "/" + this.name).then((function(_this) {
        return function(files) {
          var f, i, len, m, results;
          _this.files = {};
          results = [];
          for (i = 0, len = files.length; i < len; i++) {
            f = files[i];
            m = f.match(/^([^\.].*)\.(\w*)$/);
            if (m) {
              results.push(_this.files[f] = {
                name: m[1],
                ext: m[2],
                path: _this.site.path.modules + "/" + _this.name + "/" + f
              });
            } else if (f.match(/^[^\.].*$/)) {
              results.push(_this.files[f] = {
                name: f,
                ext: "",
                path: _this.site.path.modules + "/" + _this.name + "/" + f
              });
            } else {
              results.push(void 0);
            }
          }
          return results;
        };
      })(this));
    };

    exports.prototype.replacer = function(str, p, offset, s) {
      return str.replace(/([\"\ ])(m-[\w-]+)/, "$1mod-" + this.id + "--$2");
    };

    exports.prototype.replacer2 = function(str, p, offset, s) {
      return str.replace(/([\"\ ])js-([\w-]+)/, "$1js-$2--{{UNIQ}} $2");
    };

    exports.prototype.makeJade = function() {
      var _jade, file, filename, n, ref;
      _jade = {};
      ref = this.files;
      for (filename in ref) {
        file = ref[filename];
        if (file.ext === 'jade' && file.name === 'main') {
          _jade.fnCli = Feel.cacheFile(file.path);
          if (_jade.fnCli != null) {
            break;
          }
          console.log("jade\t\t".blue, ("" + this.name).grey);
          _jade.fnCli = jade.compileFileClient(file.path, {
            compileDebug: false
          });
          while (true) {
            n = _jade.fnCli.replace(/class\=\\\"(?:[\w-]+ )*(m-[\w-]+)(?: [\w-]+)*\\\"/, this.replacer);
            if (n === _jade.fnCli) {
              break;
            }
            _jade.fnCli = n;
          }
          while (true) {
            n = _jade.fnCli.replace(/class\=\\\"(?:[\w-]+ )*(js-[\w-]+)(?: [\w-]+)*\\\"/, this.replacer2);
            if (n === _jade.fnCli) {
              break;
            }
            _jade.fnCli = n;
          }
          while (true) {
            n = _jade.fnCli.replace(/class\"\s*\:\s*\"(?:[\w-]+ )*(js-[\w-]+)(?: [\w-]+)*\"/, this.replacer2);
            if (n === _jade.fnCli) {
              break;
            }
            _jade.fnCli = n;
          }

          /*
          m = _jade.fnCli.match(/class=\\\"([\w-\s]+)\\\"/mg)
          console.log m
          if m then for m_ in m
            m_ = m_.match /(js-\w+)/mg
            console.log m_
           */
          Feel.cacheFile(file.path, _jade.fnCli);
          break;
        }
      }
      if (_jade.fnCli != null) {
        _jade.fn = eval("(" + _jade.fnCli + ")");
      }
      return this.jade = _jade;
    };

    exports.prototype.rebuildJade = function() {
      this._rebuildingJade = true;
      return this.rescanFiles().then(this.makeJade)["catch"]((function(_this) {
        return function(e) {
          return console.error(Exception(e));
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._rebuildingJade = false;
        };
      })(this));
    };

    exports.prototype.rebuildCoffee = function() {
      this._rebuildingCoffee = true;
      return this.rescanFiles().then(this.makeCoffee)["catch"]((function(_this) {
        return function(e) {
          return console.error(Exception(e));
        };
      })(this)).then((function(_this) {
        return function() {
          return _this._rebuildingCoffee = false;
        };
      })(this));
    };

    exports.prototype.doJade = function(o, route, state) {
      var e, eo, error;
      eo = {
        F: (function(_this) {
          return function(f) {
            return Feel["static"].F(_this.site.name, f);
          };
        })(this),
        data: (function(_this) {
          return function(s) {
            return _this.site.dataObject(s, _path.relative(_this.site.path.modules + "/../", _this.site.path.modules + "/" + _this.name));
          };
        })(this),
        $tag: (function(_this) {
          return function(f) {
            if (typeof f === 'string') {
              return state.tag[f] != null;
            }
            if (f instanceof RegExp) {
              for (key in state.tag) {
                return key.match(f) != null;
              }
              return false;
            }
            return false;
          };
        })(this),
        $pageTag: (function(_this) {
          return function(f) {
            if (typeof f === 'string') {
              return state.page_tags[f] != null;
            }
            if (f instanceof RegExp) {
              for (key in state.page_tags) {
                return key.match(f) != null;
              }
              return false;
            }
            return false;
          };
        })(this),
        $req: route.req,
        $res: route.res,
        $state: state,
        $modulename: this.name,
        $statename: state.name
      };
      extend(eo, o);
      if (this.jade.fn != null) {
        try {
          return " <div id=\"m-" + this.id + "\" > " + (this.jade.fn(eo)) + " </div>";
        } catch (error) {
          e = error;
          throw new Error(("Failed execute jade in module " + this.name + " with vars " + (_inspect(o)) + ":\n\t") + e);
          console.error(e);
        }
      }
      return "";
    };

    exports.prototype.makeSass = function() {
      var file, filename, qs, ref;
      this.allCssRelative = {};
      this.cssSrc = {};
      this.css = {};
      qs = [];
      ref = this.files;
      for (filename in ref) {
        file = ref[filename];
        if ((file.ext === 'sass') || (file.ext === 'scss') || (file.ext === 'css')) {
          qs.push((function(_this) {
            return function(filename, file) {
              return Q.async(function*() {
                var data, datasrc, e, error, path, src;
                path = _this.site.path.sass + "/" + _this.name + "/" + file.name + ".css";
                data = Feel.qCacheFile(path, null, 'css');
                datasrc = (yield Feel.qCacheFile(path, null, 'csssrc'));
                if (!datasrc) {
                  try {
                    src = ((yield _readFile(path))).toString();
                  } catch (error) {
                    e = error;
                    console.error(e);
                    throw new Error("failed read css in module " + _this.name + ": " + file.name + "(" + path + ")", e);
                  }
                  _this.cssSrc[filename] = src;
                  (yield Feel.qCacheFile(path, src, 'csssrc'));
                } else {
                  _this.cssSrc[filename] = datasrc;
                }
                data = (yield data);
                if (!data) {
                  _this.css[filename] = _this.parseCss(_this.cssSrc[filename], filename);
                  if (_production) {
                    _this.css[filename] = (yield Feel.ycss(_this.css[filename]));
                  } else {
                    _this.css[filename] = Feel.bcss(_this.css[filename]);
                  }
                  return (yield Feel.qCacheFile(path, _this.css[filename], 'css'));
                } else {
                  return _this.css[filename] = data;
                }
              })();
            };
          })(this)(filename, file));
        }
      }
      return Q.all(qs);
    };

    exports.prototype.makeSassAsync = function() {
      return Q.async((function(_this) {
        return function*() {
          var file, filename, qs, ref;
          _this.allCssRelative = {};
          _this.cssSrc = {};
          _this.css = {};
          qs = [];
          ref = _this.files;
          for (filename in ref) {
            file = ref[filename];
            if (!((file.ext === 'sass') || (file.ext === 'scss') || (file.ext === 'css'))) {
              continue;
            }
            qs.push((function(filename, file) {
              return Q.async(function*() {
                var data, datasrc, e, error, path, src;
                path = _this.site.path.sass + "/" + _this.name + "/" + file.name + ".css";
                data = Feel.qCacheFile(path, null, 'css');
                datasrc = (yield Feel.qCacheFile(path, null, 'csssrc'));
                if (!datasrc) {
                  try {
                    src = ((yield _readFile(path))).toString();
                  } catch (error) {
                    e = error;
                    console.error(e);
                    throw new Error("failed read css in module " + _this.name + ": " + file.name + "(" + path + ")", e);
                  }
                  _this.cssSrc[filename] = src;
                  (yield Feel.qCacheFile(path, src, 'csssrc'));
                } else {
                  _this.cssSrc[filename] = datasrc;
                }
                data = (yield data);
                if (!data) {
                  _this.css[filename] = _this.parseCss(_this.cssSrc[filename], filename);
                  if (_production) {
                    _this.css[filename] = (yield Feel.ycss(_this.css[filename]));
                  } else {
                    _this.css[filename] = Feel.bcss(_this.css[filename]);
                  }
                  return (yield Feel.qCacheFile(path, _this.css[filename], 'css'));
                } else {
                  return _this.css[filename] = data;
                }
              })();
            })(filename, file));
          }
          (yield Q.all(qs));
          return (yield _this.makeAllCss());
        };
      })(this))();
    };

    exports.prototype.getAllCssExt = function(exts) {
      var css, ext, ref, ref1;
      css = "";
      for (ext in exts) {
        if (((ref = this.site.modules[ext]) != null ? ref.getCssRelativeTo : void 0) != null) {
          css += (ref1 = this.site.modules[ext]) != null ? typeof ref1.getCssRelativeTo === "function" ? ref1.getCssRelativeTo(this.name) : void 0 : void 0;
        }
      }
      css = Feel.bcss(css);
      return css;
    };

    exports.prototype.getCssRelativeTo = function(rel) {
      var filename, ref, ref1, src;
      if (((ref = this.allCssRelative) != null ? ref[rel] : void 0) != null) {
        return this.allCssRelative[rel];
      }
      if (this.allCssRelative == null) {
        this.allCssRelative = {};
      }
      this.allCssRelative[rel] = "";
      ref1 = this.cssSrc;
      for (filename in ref1) {
        src = ref1[filename];
        this.allCssRelative[rel] += "/*" + this.name + ":" + filename + " relative to " + rel + "*/";
        this.allCssRelative[rel] += this.parseCss(src, filename, this.site.modules[rel].id);
      }
      return this.allCssRelative[rel];
    };

    exports.prototype.makeAllCss = function() {
      var name, ref, results, src;
      this.allCss = "";
      ref = this.css;
      results = [];
      for (name in ref) {
        src = ref[name];
        results.push(this.allCss += "/*" + name + "*/" + src);
      }
      return results;
    };

    exports.prototype.parseCss = function() {
      var a, args, body, css, f, filename, fname, i, ifloop, j, k, l, leftpref, len, len1, len2, len3, m, m2, m3, newpref, post, pref, relative, replaced, ret, ret2, sel;
      css = arguments[0], filename = arguments[1], relative = arguments[2], ifloop = arguments[arguments.length - 1];
      if (relative == null) {
        relative = this.id;
      }
      ret = '';
      m = css.match(/\$FILE--\"([^\$]*)\"--FILE\$/g);
      if (m) {
        for (i = 0, len = m.length; i < len; i++) {
          f = m[i];
          fname = f.match(/\$FILE--\"([^\$]*)\"--FILE\$/)[1];
          css = replaceAll(css, f, "\"" + (Feel["static"].F(this.site.name, fname)) + "\"");
        }
      }
      m = css.match(/\$FILE--([^\$]*)--FILE\$/g);
      if (m) {
        for (j = 0, len1 = m.length; j < len1; j++) {
          f = m[j];
          fname = f.match(/\$FILE--([^\$]*)--FILE\$/)[1];
          css = replaceAll(css, f, "\"" + (Feel["static"].F(this.site.name, fname)) + "\"");
        }
      }
      css = css.replace(/\/\*([^*]|[\r\n]|(\*+([^*\/]|[\r\n])))*\*+\//gmi, '');
      css = css.replace(/\n/gmi, ' ');
      css = css.replace(/\r/gmi, ' ');
      css = css.replace(/\s+/gmi, ' ');
      m = css.match(/([^{]*)([^}]*})(.*)/);
      if (filename.match(/.*\.g\.(sass|scss|css)$/)) {
        return css;
      }
      if (!m) {
        return css;
      }
      pref = m[1];
      body = m[2];
      post = m[3];
      newpref = "";
      m = pref.match(/([^,]+)/g);
      if (m) {
        for (k = 0, len2 = m.length; k < len2; k++) {
          sel = m[k];
          if (newpref !== "") {
            newpref += ",";
          }
          replaced = false;
          if (sel.match(/^main.*/)) {
            sel = sel.replace(/^main/, "#m-" + relative);
            replaced = true;
          }
          if (!(sel.match(/^\.(g-[\w-]+)/)) && (!replaced)) {
            newpref += "#m-" + relative;
          }
          m2 = sel.match(/([^\s]+)/g);
          if (m2) {
            for (l = 0, len3 = m2.length; l < len3; l++) {
              a = m2[l];
              m3 = a.match(/^\.(m-[\w-]+)/);
              leftpref = "";
              if (m3) {
                if (!replaced) {
                  leftpref = " ";
                }
                newpref += leftpref + ("\.mod-" + relative + "--" + m3[1]);
              } else if (a.match(/^\.(g-[\w-]+)/)) {
                if (!replaced) {
                  leftpref = " ";
                }
                newpref += leftpref + a;
              } else {
                if (!replaced) {
                  leftpref = ">";
                }
                newpref += leftpref + a;
              }
            }
          } else {
            m3 = sel.match(/^\.m-[\w-]+/);
            leftpref = "";
            if (m3) {
              if (!replaced) {
                leftpref = " ";
              }
              newpref += leftpref + ("\.mod-" + relative + "--" + m3[1]);
            } else if (sel.match(/^\.(g-[\w-]+)/)) {
              if (!replaced) {
                leftpref = " ";
              }
              newpref += leftpref + sel;
            } else if (sel && !replaced) {
              if (!replaced) {
                leftpref = ">";
              }
              newpref += leftpref + sel;
            }
          }
        }
      } else {
        newpref = pref;
      }
      if (filename.match(/.*\.g\.(sass|scss|css)$/)) {
        newpref = pref;
      }
      if (ifloop === 'loop') {
        return {
          begin: newpref + body,
          args: [post, filename, relative, 'loop']
        };
      }
      ret = newpref + body;
      args = [post, filename, relative, 'loop'];
      while (true) {
        ret2 = this.parseCss.apply(this, args);
        if ((ret2 != null ? ret2.args : void 0) != null) {
          ret += ret2.begin;
          args = ret2.args;
        } else {
          ret += ret2;
        }
        if ((ret2 != null ? ret2.args : void 0) == null) {
          break;
        }
      }
      return ret;
    };

    exports.prototype.makeCoffee = function() {
      return Q.async((function(_this) {
        return function*() {
          var file, filename, m, name, num, qs, ref, ref1, src;
          _this.newCoffee = {};
          _this.newCoffeenr = {};
          qs = [];
          ref = _this.files;
          for (filename in ref) {
            file = ref[filename];
            if (file.ext === 'coffee' && !filename.match(/.*\.[d|c]\.coffee$/)) {
              (function(filename, file) {
                return qs.push(Q.async(function*() {
                  var datasrc, datasrcnr, e, error, src;
                  console.log('coffee\t'.yellow, (_this.name + "/" + filename).grey);
                  src = "";
                  datasrc = (yield Feel.qCacheFile(file.path, null, 'mcoffeefile'));
                  datasrcnr = (yield Feel.qCacheFile(file.path, null, 'mcoffeefilenr'));
                  if (datasrc && datasrcnr) {
                    _this.newCoffee[filename] = datasrc;
                    _this.newCoffeenr[filename] = datasrcnr;
                    return;
                  }
                  try {
                    src = Feel.cacheCoffee(file.path);
                  } catch (error) {
                    e = error;
                    console.error(Exception(e));
                    throw new Error("failed read coffee in module " + _this.name + ": " + file.name + "(" + file.path + ")", e);
                  }
                  _this.newCoffee[filename] = _regenerator(src);
                  _this.newCoffeenr[filename] = src;
                  if (_production) {
                    _this.newCoffee[filename] = (yield Feel.yjs(_this.newCoffee[filename]));
                    _this.newCoffeenr[filename] = (yield Feel.yjs(_this.newCoffeenr[filename]));
                  }
                  return (yield Feel.qCacheFile(file.path, _this.newCoffee[filename], 'mcoffeefile'));
                })());
              })(filename, file);
            }
            if (file.ext === 'js') {
              (function(filename, file) {
                return qs.push(Q.async(function*() {
                  var datasrc, datasrcnr, e, error, src;
                  src = "";
                  datasrc = Feel.cacheFile(file.path, null, 'mcoffeefile');
                  datasrcnr = Feel.cacheFile(file.path, null, 'mcoffeefilenr');
                  if (datasrc && datasrcnr) {
                    _this.newCoffee[filename] = datasrc;
                    _this.newCoffeenr[filename] = datasrcnr;
                    return;
                  }
                  try {
                    src = fs.readFileSync(file.path);
                  } catch (error) {
                    e = error;
                    console.error(Exception(e));
                    throw new Error("failed read js in module " + _this.name + ": " + file.name + "(" + file.path + ")", e);
                  }
                  _this.newCoffee[filename] = _regenerator(src);
                  _this.newCoffeenr[filename] = src;
                  if (_production) {
                    _this.newCoffee[filename] = (yield Feel.yjs(_this.newCoffee[filename]));
                    _this.newCoffeenr[filename] = (yield Feel.yjs(_this.newCoffeenr[filename]));
                  }
                  (yield Feel.qCacheFile(file.path, _this.newCoffee[filename], 'mcoffeefile'));
                  return (yield Feel.qCacheFile(file.path, _this.newCoffeenr[filename], 'mcoffeefilenr'));
                })());
              })(filename, file);
            }
          }
          (yield Q.all(qs));
          _this.coffee = _this.newCoffee;
          _this.coffeenr = _this.newCoffeenr;
          _this.allCoffee = "(function(){ var arr = {}; (function(){";
          _this.allJs = "";
          num = 0;
          ref1 = _this.coffee;
          for (name in ref1) {
            src = ref1[name];
            m = name.match(/^(.*)\.(coffee|js)/);
            if (m) {
              num++;
              _this.allJs += "(function(){ " + src + " }).call(this);";
            }
          }
          _this.allCoffee += _this.allJs;
          _this.allCoffee += "}).call(arr);return arr; })()";
          if (!num) {
            _this.allCoffee = "";
          }
          return _this.setHash();
        };
      })(this))();
    };

    exports.prototype.jsfile = function(fname) {
      var f;
      f = this.coffee[fname];
      if (f == null) {
        f = this.coffee[fname + ".coffee"];
      }
      if (f == null) {
        f = this.coffee[fname + ".js"];
      }
      if (f != null ? f.toString : void 0) {
        f = f.toString();
      }
      return f;
    };

    exports.prototype.jsfilet = function(fname) {
      var f;
      f = this.jsfile(fname);
      if (!f) {
        return f;
      }
      return "(function(){" + f + "}).call(_FEEL_that);";
    };

    exports.prototype.jsNames = function(fname) {
      return Object.keys(this.coffee);
    };

    exports.prototype.makeJs = function() {
      var e, error, file, filename, m, name, num, ref, ref1, src;
      this.newJs = {};
      ref = this.files;
      for (filename in ref) {
        file = ref[filename];
        if (file.ext === 'js') {
          src = "";
          try {
            src = fs.readFileSync(file.path);
          } catch (error) {
            e = error;
            console.error(Exception(e));
            throw new Error("failed read js in module " + this.name + ": " + file.name + "(" + file.path + ")", e);
          }
          this.newJs[filename] = src;
        }
      }
      this.js = this.newJs;
      this.allJs = "(function(){ var arr = {};";
      num = 0;
      ref1 = this.js;
      for (name in ref1) {
        src = ref1[name];
        m = name.match(/^(.*)\.js/);
        if (m) {
          num++;
          this.allJs += "(function(){ " + src + " }).call(arr);";
        }
      }
      this.allJs += "return arr; })()";
      if (!num) {
        this.allJs = "";
      }
      this.allJs = _regenerator(this.allJs);
      this.setHash();
      return Q();
    };

    exports.prototype.setHash = function() {
      this.jsHash = this.hash(this.allJs);
      return this.coffeeHash = this.hash(this.allCoffee);
    };

    exports.prototype.hash = function(f) {
      var sha1;
      sha1 = crypto.createHash('sha1');
      sha1.setEncoding('hex');
      sha1.update(f);
      return sha1.digest('hex').substr(0, 10);
    };

    return exports;

  })();

}).call(this);
