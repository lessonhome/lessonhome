(function() {
  var coffee, fs, path,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  coffee = require('coffee-script');

  path = require('path');

  fs = require('fs');

  module.exports = (function() {
    function exports(site, name1) {
      this.site = site;
      this.name = name1;
      this.function_data = bind(this.function_data, this);
      this.function_extend = bind(this.function_extend, this);
      this.function_F = bind(this.function_F, this);
      this.function_const = bind(this.function_const, this);
      this.function_module = bind(this.function_module, this);
      this.function_template = bind(this.function_template, this);
      this.function_state = bind(this.function_state, this);
      this.modulename_resolve = bind(this.modulename_resolve, this);
      this.statename_resolve = bind(this.statename_resolve, this);
      this.walk_tree_down = bind(this.walk_tree_down, this);
      this.walk_tree_up = bind(this.walk_tree_up, this);
      this.bind_exports = bind(this.bind_exports, this);
      this.make = bind(this.make, this);
      this.checkVar = bind(this.checkVar, this);
      this.checkFoo = bind(this.checkFoo, this);
      this.makeClass = bind(this.makeClass, this);
      this.init = bind(this.init, this);
      this.path = (process.cwd()) + "/" + this.site.path.states + "/" + this.name + ".coffee";
      this.dir = this.name.match(/^(.*\/|)\w+$/)[1];
      this.inited = false;
      this.sdepend = {};
    }

    exports.prototype.init = function() {
      var e, error, src, that;
      console.log("state\t\t".magenta, ("" + this.name).cyan);
      try {
        src = coffee._compileFile(this.path);
      } catch (error) {
        e = error;
        console.error(Exception(e));
        throw new Error("Failed compile satate " + this.name);
      }
      this.context = ['module', 'const', 'state', 'template', 'extend', 'data', 'F'];
      that = this;
      this.src = "var file = {}; (function(){";
      this.src += " var $urls   = that.site.router.url, $router = that.site.router, $site   = that.site, $db     = that.site.db; this.template = that.function_template;";
      this.src += src;
      this.src += "if (this.main && this.main.prototype && this.main.prototype.tree){ var __oldtree = this.main.prototype.tree; this.main.prototype.tree = function(){ var that = this;";
      this.src += "return __oldtree.call.apply(__oldtree, [that].concat([].slice.call(arguments))); };}";
      this.src += " }).call(file); file";
      return this.makeClass();
    };

    exports.prototype.makeClass = function() {
      var e, error, src, that;
      that = this;
      try {
        src = eval(this.src);
      } catch (error) {
        e = error;
        console.error(Exception(e));
        throw new Error(("Failed exec state " + this.name + " ") + e);
      }
      if (src.main == null) {
        return;
      }
      if (src.main == null) {
        throw new Error("Not defined 'class @main' in state '" + this.name + "'");
      }
      this["class"] = src.main;
      this["class"].prototype.__make = (function(_this) {
        return function() {
          return _this.make.apply(_this, arguments);
        };
      })(this);
      this["class"].prototype.__bind_exports = (function(_this) {
        return function() {
          return _this.bind_exports.apply(_this, arguments);
        };
      })(this);
      this["class"].prototype.statename = this.name;
      this.checkFoo('init');
      this.checkFoo('run');
      this.checkFoo('tree', function() {
        return {};
      });
      this.checkVar('route');
      this.checkVar('model');
      this.inited = true;
      if ((this["class"].prototype.route != null) && !this.name.match(/^(dev|test)/)) {
        if (this["class"].prototype.title == null) {
          throw new Error("Undefined title in state '" + this.name + "'");
        }
      }
    };

    exports.prototype.checkFoo = function(name, foo) {
      var ref, ref1;
      if (foo == null) {
        foo = function() {};
      }
      if (((ref = this["class"].prototype.constructor) != null ? (ref1 = ref.__super__) != null ? ref1[name] : void 0 : void 0) != null) {
        if (this["class"].prototype[name] === this["class"].prototype.constructor.__super__[name]) {
          return this["class"].prototype[name] = foo;
        }
      }
    };

    exports.prototype.checkVar = function(name, foo) {
      var ref, ref1;
      if (((ref = this["class"].prototype.constructor) != null ? (ref1 = ref.__super__) != null ? ref1[name] : void 0 : void 0) != null) {
        if (this["class"].prototype[name] === this["class"].prototype.constructor.__super__[name]) {
          return this["class"].prototype[name] = foo;
        }
      }
    };

    exports.prototype.make = function() {
      var j, o, req, res, state;
      o = arguments[0], state = arguments[1], j = arguments.length - 2, req = arguments[j++], res = arguments[j++];
      return Q.async((function(_this) {
        return function*() {
          var __states, _n, _p, base, base1, cont, e, error, error1, error2, f, fn, k, key, l, len, len1, n, name, osdepend, qs, ref, ref1, ref2, ref3, ref4, ref5, tag, tags_, temp, tree, v, val;
          _this.makeClass();
          if (state == null) {
            state = new _this["class"]();
          }
          ref = _this.context;
          fn = function(f, state) {
            return state[f] = function() {
              return _this['function_' + f].apply(_this, slice.call(arguments).concat([state]));
            };
          };
          for (l = 0, len = ref.length; l < len; l++) {
            f = ref[l];
            fn(f, state);
          }
          req._smart = true;
          res._smart = true;
          state.req = req;
          state.res = res;
          state._smart = true;
          state.exports = function(name) {
            if (name == null) {
              name = '{{NULL}}';
            }
            return {
              __exports: name
            };
          };
          state.name = _this.name;
          tree = state.tree();
          tree.__state = state;
          tree._isState = true;
          tree._statename = _this.name;
          if (tree.__states == null) {
            tree.__states = {};
          }
          __states = tree.__states;
          __states[_this.name] = state;
          for (key in tree) {
            val = tree[key];
            state.tree[key] = val;
          }
          if ((state.tags != null) && (typeof state.tags !== 'function')) {
            tags_ = state.tags;
            state.tags = function() {
              return tags_;
            };
          }
          state.tag = typeof state.tags === "function" ? state.tags() : void 0;
          if (typeof state.tag === 'string') {
            state.tag = [state.tag];
          } else if (((ref1 = state.tag) != null ? ref1.length : void 0) == null) {
            state.tag = [];
          }
          if (state.access == null) {
            state.access = [];
          }
          if (typeof state.access === 'function') {
            state.access = state.access();
          }
          if (state.access == null) {
            state.access = [];
          }
          if (typeof state.access === 'string') {
            state.access = [state.access];
          }
          if (state.redirect == null) {
            state.redirect = {};
          }
          temp = {};
          ref2 = state.tag;
          for (n = 0, len1 = ref2.length; n < len1; n++) {
            tag = ref2[n];
            if (typeof tag === 'string') {
              temp[tag] = true;
            }
          }
          state.tag = temp;
          cont = true;
          qs = [];
          while (cont) {
            cont = false;
            _this.walk_tree_down(state.tree, function(node, key, val) {
              if (!(key === '$defer') && Q.isPromise(val)) {
                cont = true;
                return qs.push(val.then(function(ret) {
                  return node[key] = ret;
                }));
              }
            });
            (yield Q.all(qs));
          }
          if (!state.tree._isModule) {
            ref3 = state.tree;
            for (key in ref3) {
              val = ref3[key];
              if (val._isModule) {
                if (val.__state != null) {
                  if ((base = state.tree).__states == null) {
                    base.__states = {};
                  }
                  ref4 = val.__state.tree.__states;
                  for (k in ref4) {
                    v = ref4[k];
                    state.tree.__states[k] = v;
                  }
                }
                val.__state = state;
                val._isState = true;
                val._statename = _this.name;
              }
            }
          }
          try {
            (function(state) {
              return _this.walk_tree_down(state.tree, function(node, key, val) {
                var base1, name, s;
                if ((val != null ? val.__state : void 0) != null) {
                  s = val.__state;
                }
                if (val.__exports != null) {
                  name = val.__exports;
                  if (name === '{{NULL}}') {
                    name = key;
                    delete node[key];
                  } else if (typeof name === 'object') {
                    for (key in name) {
                      val = name[key];
                      name = key;
                      node[key] = val;
                      break;
                    }
                  } else if (typeof name === 'string') {
                    delete node[key];
                  }
                  if ((base1 = state.exports)[name] == null) {
                    base1[name] = [];
                  }
                  return state.exports[name].push({
                    node: node,
                    key: key
                  });
                }
              });
            })(state);
          } catch (error) {
            e = error;
            console.error("failed match exports in state " + _this.name, Exception(e));
            throw e;
          }
          _this.bind_exports(state, o);
          try {
            if (state.constructor.__super__ != null) {
              state.parent = state.constructor.__super__;
              (yield state.parent.__make(null, state.parent, req, res));
              _p = state.parent;
              _n = state;
              while (_p) {
                if ((base1 = _p.tree).__states == null) {
                  base1.__states = {};
                }
                ref5 = _n.tree.__states;
                for (k in ref5) {
                  v = ref5[k];
                  _p.tree.__states[k] = v;
                }

                /*
                unless _p.tree._isModule
                  for key,val of _p.tree
                    if val._isModule
                      if val.__state?
                        for k,v of val.__state.tree.__states
                          _p.tree.__states[k] = v
                 */
                _n = _p;
                _p = _p.constructor.__super__;
              }
            }
          } catch (error1) {
            e = error1;
            console.error("failed make parent in state " + _this.name, Exception(e), state.parent);
            throw e;
          }
          if (state.parent) {
            state.parent.__bind_exports(state.parent, state.tree);
          }
          try {
            (yield (typeof state.init === "function" ? state.init() : void 0));
            cont = true;
            qs = [];
            while (cont) {
              cont = false;
              _this.walk_tree_down(state.tree, function(node, key, val) {
                if (!(key === "$defer") && Q.isPromise(val)) {
                  cont = true;
                  return qs.push(val.then(function(ret) {
                    return node[key] = ret;
                  }));
                }
              });
              (yield Q.all(qs));
            }
          } catch (error2) {
            e = error2;
            console.error("failed state init " + _this.name, Exception(e));
            throw e;
          }
          osdepend = {};
          for (name in _this.sdepend) {
            for (key in _this.site.state[name].sdepend) {
              osdepend[key] = true;
            }
          }
          for (key in osdepend) {
            _this.sdepend[key] = true;
          }
          return state;
        };
      })(this))();
    };

    exports.prototype.bind_exports = function(state, o) {
      var a, arr, b, e, error, exp, field, j, k, key, l, len, len1, newo, node, ref, ref1, ref2, ref3, val, value;
      try {
        if (o && (typeof o === 'object' || typeof o === 'function')) {

          /*
          for key,val of o
            continue if key.match /^_/
           */
          ref = state.exports;
          for (field in ref) {
            arr = ref[field];
            value = _setKey(o, field);
            for (j = 0, len = arr.length; j < len; j++) {
              exp = arr[j];
              node = exp.node;
              k = exp.key;
              if (typeof node[k] === 'object' || typeof node[k] === 'function') {
                for (a in value) {
                  b = value[a];
                  node[k][a] = b;
                }
              } else {
                node[k] = value;
              }

              /*
              if node == state.tree
                if state.parent?.exports?[k]?
                  newo = {}
                  newo[k] = node[k]
                  state.parent.__bind_exports state.parent,newo
               */
            }
          }
          newo = null;
          if (((ref1 = state.parent) != null ? ref1.exports : void 0) != null) {
            for (key in o) {
              val = o[key];
              if (key.match(/^_/)) {
                continue;
              }
              if (state.exports[key] != null) {
                ref2 = state.exports[key];
                for (l = 0, len1 = ref2.length; l < len1; l++) {
                  exp = ref2[l];
                  node = exp.node;
                  k = exp.key;
                  if (node === state.tree) {
                    if (newo == null) {
                      newo = {};
                    }
                    newo[k] = node[k];
                  }
                }
              }
            }
          }
          if (newo) {
            return state != null ? (ref3 = state.parent) != null ? typeof ref3.__bind_exports === "function" ? ref3.__bind_exports(state.parent, newo) : void 0 : void 0 : void 0;
          }

          /*
            if !state.exports[key]?
              console.error "can't find exports name '#{key}' in state #{@name}"
            else
              for exp in state.exports[key]
                node = exp.node
                k    = exp.key
                if typeof node[k] == 'object' || typeof node[k]=='function'
                  for a,b of val
                    node[k][a] = b
                else node[k] = val
                if node == state.tree
                  if state.parent?.exports?[k]?
                    newo = {}
                    newo[k] = node[k]
                    state.parent.__bind_exports state.parent, newo
           */
        }
      } catch (error) {
        e = error;
        console.error("failed merge tree in state " + this.name + " with object", o, Exception(e));
        throw e;
      }
    };

    exports.prototype.walk_tree_up = function(node, foo) {
      var key, results, val;
      if (node && (typeof node === 'object' || typeof node === 'function') && !(node != null ? node._smart : void 0)) {
        results = [];
        for (key in node) {
          val = node[key];
          this.walk_tree_up(node[key], foo);
          results.push(foo(node, key, val));
        }
        return results;
      }
    };

    exports.prototype.walk_tree_down = function(node, foo) {
      var key, results, val;
      if (node && (typeof node === 'object' || typeof node === 'function') && !(node != null ? node._smart : void 0)) {
        for (key in node) {
          val = node[key];
          if (val != null) {
            foo(node, key, val);
          }
        }
        results = [];
        for (key in node) {
          val = node[key];
          results.push(this.walk_tree_down(node[key], foo));
        }
        return results;
      }
    };

    exports.prototype.statename_resolve = function(str) {
      var m;
      m = str.match(/^\/(.*)$/);
      if (m) {
        return this.statename_resolve(m[1]);
      }
      m = str.match(/^\.(.*)/);
      if (m) {
        return path.normalize(this.dir + str);
      }
      return str;
    };

    exports.prototype.modulename_resolve = function(str) {
      var m;
      str = str.replace(/\$/g, this.name);
      m = str.match(/^\.(.*)/);
      if (m) {
        return path.normalize(this.dir + str);
      }
      return str;
    };

    exports.prototype.function_state = function() {
      var o, state;
      o = arguments[0], state = arguments[arguments.length - 1];
      return Q.async((function(_this) {
        return function*() {
          var e, error, key, name, ref, tree, val;
          if (typeof o === 'string') {
            name = _this.statename_resolve(o);
            o = null;
          } else if (typeof o === 'object' || typeof o === 'function') {
            name = '';
            for (key in o) {
              val = o[key];
              if (name !== '') {
                console.error('wrong statename in ', o, " from state " + _this.name);
                throw new Error('wrong statename');
              }
              name = key;
            }
            if (name === '') {
              console.error('wrong statename in ', o, " from state " + _this.name);
              throw new Error('wrong statename');
            }
            o = o[name];
            name = _this.statename_resolve(name);
          }
          try {
            _this.site.createState(name);
            _this.sdepend[name] = true;
            state = (yield _this.site.state[name].make(o, null, state.req, state.res));
            tree = {};
            ref = state.tree;
            for (key in ref) {
              val = ref[key];
              tree[key] = val;
            }
            return tree;
          } catch (error) {
            e = error;
            throw new Error(("Failed make state '" + o + "':'" + name + "' from state '" + _this.name + "':\n") + e);
          }
        };
      })(this))();
    };

    exports.prototype.function_template = function(o) {
      var e, error, key, name, val;
      if (typeof o === 'string') {
        name = this.statename_resolve(o);
        o = null;
      } else if (typeof o === 'object' || typeof o === 'function') {
        name = '';
        for (key in o) {
          val = o[key];
          if (name !== '') {
            console.error('wrong statename in ', o, " from state " + this.name);
            throw new Error('wrong statename');
          }
          name = key;
        }
        if (name === '') {
          console.error('wrong statename in ', o, " from state " + this.name);
          throw new Error('wrong statename');
        }
        o = o[name];
        name = this.statename_resolve(name);
      }
      try {
        this.site.createState(name);
        this.sdepend[name] = true;
        return this.site.state[name]["class"];
      } catch (error) {
        e = error;
        throw new Error(("Failed make state '" + o + "':'" + name + "' from state '" + this.name + "':\n") + e);
      }
    };

    exports.prototype.function_module = function() {
      var arr, ext, i, j, key, lastn, len, m, mod, name, o, state, val;
      o = arguments[0], state = arguments[arguments.length - 1];
      mod = {};
      mod._isModule = true;
      name = 'unknown';
      m = {};
      switch (typeof o) {
        case 'string':
          name = this.modulename_resolve(o);
          break;
        case 'object':
        case 'function':
          for (key in o) {
            val = o[key];
            name = this.modulename_resolve(key);
            m = val;
          }
          break;
        default:
          throw new Error('wrong module name', o);
      }
      lastn = name;
      arr = name.split(':');
      name = arr.shift();
      mod._name = name;
      for (i = j = 0, len = arr.length; j < len; i = ++j) {
        ext = arr[i];
        arr[i] = path.normalize(name + "/" + ext);
        if (this.site.modules[arr[i]] == null) {
          throw new Error(("extends module '" + arr[i] + "' not exists in state:" + this.name + "::" + lastn).red);
        }
      }
      mod._extends_modules = arr;
      for (key in m) {
        val = m[key];
        mod[key] = val;
      }
      if ((!name.match(/^\/\/.*/)) && (this.site.modules[name] == null)) {
        throw new Error("Can't find module '" + name + "' in state '" + this.name + "'");
      }
      return mod;
    };

    exports.prototype.function_const = function() {
      var name, state;
      name = arguments[0], state = arguments[arguments.length - 1];
      return require((process.cwd()) + "/" + this.site.path["const"] + "/" + name);
    };

    exports.prototype.function_F = function() {
      var f, state;
      f = arguments[0], state = arguments[arguments.length - 1];
      return Feel["static"].F(this.site.name, f);
    };

    exports.prototype.function_extend = function() {
      return {};
    };

    exports.prototype.function_data = function() {
      var get_, ha, obj, s, st, state;
      s = arguments[0], state = arguments[arguments.length - 1];
      ha = _randomHash(5);
      st = new Date().getTime();
      obj = this.site.dataObject(s, _path.relative((process.cwd()) + "/" + this.site.path.states + "/../", this.path));
      obj.$site = this.site;
      obj.$req = state.req;
      obj.$res = state.res;
      obj.$user = state.req.user;
      obj.$session = state.req.session;
      obj.$register = state.req.register;
      obj.$cookie = state.req.cookie;
      obj.$status = state.req.status;
      if ((obj.get != null) && (typeof obj.get === 'function')) {
        get_ = obj.get;
        obj.get = (function(_this) {
          return function() {
            var args;
            args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
            return get_.apply(obj, args).then(function(a) {
              return a;
            });
          };
        })(this);
      }
      return obj;
    };

    return exports;

  })();

}).call(this);
