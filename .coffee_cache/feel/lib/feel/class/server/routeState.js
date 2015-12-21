(function() {
  var RouteState, _cookies, crypto, get_ip, rand, urldataLinks, useragent,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  crypto = require('crypto');

  _cookies = require('cookies');

  rand = function(num) {
    return crypto.createHash('sha1').update(num).digest('hex').substr(0, 10);
  };

  get_ip = require('ipware')().get_ip;

  useragent = require('useragent');

  urldataLinks = "";

  RouteState = (function() {
    function RouteState(statename, req1, res1, site) {
      var sha1;
      this.statename = statename;
      this.req = req1;
      this.res = res1;
      this.site = site;
      this.redirect = bind(this.redirect, this);
      this.getO = bind(this.getO, this);
      this.parse = bind(this.parse, this);
      this.cssModuleExt = bind(this.cssModuleExt, this);
      this.cssModule = bind(this.cssModule, this);
      this.removeHtml = bind(this.removeHtml, this);
      this.addModuleJs = bind(this.addModuleJs, this);
      this.go = bind(this.go, this);
      this.walk_tree_down = bind(this.walk_tree_down, this);
      this.getTree = bind(this.getTree, this);
      this.getTop = bind(this.getTop, this);
      this.getTopNode = bind(this.getTopNode, this);
      this.time = bind(this.time, this);
      this.time();
      this.rand = "1";
      this.reqHash = {
        url: this.req.url,
        session: this.req.session
      };
      sha1 = require('crypto').createHash('sha1');
      sha1.update(JSON.stringify(this.reqHash));
      this.reqHash = sha1.digest('hex');
      this.reqEtag = this.req.headers['if-none-match'];
      this.o = {
        res: this.res,
        req: this.req
      };
      this.time("constr");
    }

    RouteState.prototype.time = function(str) {
      var t;
      if (str == null) {
        str = "";
      }
      if (this._time == null) {
        return this._time = new Date().getTime();
      } else {
        t = new Date().getTime();
        return this._time = t;
      }
    };

    RouteState.prototype.getField = function(obj, field) {
      var a, f, i, len;
      a = field != null ? typeof field.split === "function" ? field.split('.') : void 0 : void 0;
      if (a == null) {
        a = [null];
      }
      for (i = 0, len = a.length; i < len; i++) {
        f = a[i];
        obj = obj != null ? obj[f] : void 0;
      }
      return obj;
    };

    RouteState.prototype.getTopNode = function(node, force) {
      var key, o, p, ref, val;
      if (force == null) {
        force = false;
      }
      if (node != null ? node._isModule : void 0) {
        return node;
      }
      if (node.__gotted) {
        return node;
      }
      node.__gotted = true;
      if (((ref = node.__state) != null ? ref.parent : void 0) == null) {
        return node;
      }
      p = this.getTopNode(node.__state.parent.tree);
      if (force) {
        o = node;
      } else {
        o = {};
        for (key in node) {
          val = node[key];
          if (key.match(/^_.*/)) {
            o[key] = val;
          }
        }
      }
      for (key in o) {
        val = o[key];
        if (!key.match(/^_.*/)) {
          delete o[key];
        }
      }
      for (key in p) {
        val = p[key];
        if (o[key] == null) {
          o[key] = val;
        }
      }
      return o;
    };

    RouteState.prototype.getTop = function(node) {
      if (this.top != null) {
        return this.top;
      }
      if (node == null) {
        node = this.state;
      }
      if (node.parent != null) {
        return this.getTop(node.parent);
      } else {
        return this.top = node.tree;
      }
    };

    RouteState.prototype.getTree = function(top) {
      var key, tree, val;
      if (top.__inner) {
        return;
      }
      top.__inner = true;
      tree = {};
      for (key in top) {
        val = top[key];
        if (val && (typeof val === 'function' || typeof val === 'object') && !val._smart) {
          tree[key] = this.getTree(val);
        } else {
          tree[key] = val;
        }
      }
      delete tree.__inner;
      delete top.__inner;
      return tree;
    };

    RouteState.prototype.walk_tree_down = function(node, pnode, key, foo) {
      var results, val;
      if (node && (typeof node === 'object' || typeof node === 'function') && !(node != null ? node._smart : void 0)) {
        foo(node, pnode, key);
        results = [];
        for (key in node) {
          val = node[key];
          results.push(this.walk_tree_down(node[key], node, key, foo));
        }
        return results;
      }
    };

    RouteState.prototype.go = function() {
      return Q.async((function(_this) {
        return function*() {
          var access, arr, base, base1, base2, base3, base4, base5, base6, d, e, el, end, error, fields, fn, fn1, form, i, j, json_, json_tree, key, l, len, len1, len2, len3, len4, modname, n, name, names, neg, o, path, q, qforms, qs, r, ref, ref1, ref10, ref11, ref12, ref13, ref14, ref15, ref16, ref17, ref18, ref19, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, resHash, s, sclass, sha1, sn, title, uform, val, vv, zlib;
          if ((base = _this.req).user == null) {
            base.user = {};
          }
          if ((base1 = _this.req.user).type == null) {
            base1.type = {
              other: true
            };
          }
          _this.res.on('finish', function() {
            var agent, host, ip, ref, ref1, ref2, ua;
            agent = "";
            ip = (ref = get_ip(_this.req)) != null ? ref.clientIp : void 0;
            if (ip == null) {
              ip = "";
            }
            ua = useragent.parse(_this.req.headers['user-agent']);
            if (ua.family == null) {
              ua.family = "";
            }
            if (ua.major == null) {
              ua.major = "";
            }
            if (ua.minor == null) {
              ua.minor = "";
            }
            host = (ref1 = _this.req) != null ? (ref2 = ref1.headers) != null ? ref2.host : void 0 : void 0;
            if (host == null) {
              host = "";
            }
            return console.log(process.pid + ":time".yellow + ("\t" + (new Date().getTime() - _this.req.time) + "ms").cyan + (" " + host + _this.req.url + ":" + ip + ":" + ua.family + ":" + ua.major + ":" + ua.minor).grey);
          });
          sclass = _this.site.state[_this.statename]["class"];
          if ((base2 = sclass.prototype).access == null) {
            base2.access = [];
          }
          if (typeof sclass.prototype.access === 'function') {
            sclass.prototype.access = sclass.prototype.access();
          }
          if ((base3 = sclass.prototype).access == null) {
            base3.access = [];
          }
          if (typeof sclass.prototype.access === 'string') {
            sclass.prototype.access = [sclass.prototype.access];
          }
          if (sclass.prototype.access.length) {
            s = {};
            ref = sclass.prototype.access;
            for (i = 0, len = ref.length; i < len; i++) {
              el = ref[i];
              s[el] = true;
            }
            sclass.prototype.access = s;
          }
          if ((base4 = sclass.prototype).redirect == null) {
            base4.redirect = {};
          }
          access = false;
          ref1 = _this.req.user.type;
          for (key in ref1) {
            val = ref1[key];
            if (!val) {
              continue;
            }
            if (sclass.prototype.access[key]) {
              access = true;
              break;
            }
          }
          if (!(access || _this.req.user.admin)) {
            _setKey(_this.req.udata, 'accessRedirect.redirect', _this.req.url);
            ref2 = sclass.prototype.redirect;
            for (key in ref2) {
              val = ref2[key];
              if (((ref3 = _this.req.user) != null ? (ref4 = ref3.type) != null ? ref4[key] : void 0 : void 0) != null) {
                return _this.redirect(_this.req, _this.res, val);
              }
            }
            if (sclass.prototype.redirect["default"]) {
              return _this.redirect(_this.req, _this.res, sclass.prototype.redirect["default"]);
            }
            return Feel.res403(_this.req, _this.res);
          }
          if (sclass.prototype.status != null) {
            qs = [];
            ref5 = sclass.prototype.status;
            fn = function(key, val, neg, name) {
              return qs.push(_this.req.status(name).then(function(status) {
                if (typeof val === 'string') {
                  val = {
                    value: true,
                    redirect: val
                  };
                }
                if (!neg) {
                  if (status === val.value) {
                    return {
                      redirect: val.redirect
                    };
                  }
                } else {
                  if (status !== val.value) {
                    return {
                      redirect: val.redirect
                    };
                  }
                }
              }));
            };
            for (key in ref5) {
              val = ref5[key];
              neg = false;
              name = key;
              if (name.match(/^\!/)) {
                neg = true;
                name = name.substr(1);
              }
              fn(key, val, neg, name);
            }
            arr = (yield Q.all(qs));
            for (j = 0, len1 = arr.length; j < len1; j++) {
              el = arr[j];
              if ((el != null ? el.redirect : void 0) != null) {
                return _this.redirect(_this.req, _this.res, el.redirect);
              }
            }
          }
          _this.time("go s");
          _this.state = (yield _this.site.state[_this.statename].make(null, null, _this.req, _this.res));
          _this.time('make');
          _this.tags = {};
          _this.$forms = {};
          _this.getTop();
          qforms = [];
          _this.walk_tree_down(_this.top, _this, 'top', function(node, pnode, key) {
            var base5, boo, f, field, fields, fname, k, l, len2, len3, o, q, ref6, results, sn;
            if (node._isState) {
              if (node.__states) {
                o = node.__states;
              } else {
                o = {};
                o[node._statename] = node.__state;
              }
              for (sn in o) {
                s = o[sn];
                if (s.forms != null) {
                  if (typeof s.forms === 'function') {
                    s.forms = s.forms();
                  }
                  if (typeof s.forms === 'string') {
                    s.forms = [s.forms];
                  }
                  ref6 = s.forms;
                  for (l = 0, len2 = ref6.length; l < len2; l++) {
                    f = ref6[l];
                    fname = f;
                    fields = void 0;
                    if (typeof f === 'object') {
                      fname = Object.keys(f)[0];
                      fields = f[fname];
                      if (typeof fields === 'string') {
                        fields = [fields];
                      }
                    }
                    if ((base5 = _this.$forms)[fname] == null) {
                      base5[fname] = {};
                    }
                    boo = false;
                    if (fields) {
                      for (q = 0, len3 = fields.length; q < len3; q++) {
                        field = fields[q];
                        boo = true;
                        _this.$forms[fname][field] = true;
                      }
                    }
                    if (!boo) {
                      _this.$forms[fname].__all = true;
                    }
                  }
                }
                for (k in s.tag) {
                  _this.tags[k] = true;
                }
              }
              results = [];
              for (sn in o) {
                s = o[sn];
                results.push(s.page_tags = _this.tags);
              }
              return results;
            }
          });
          _this.time('walk tree');
          ref6 = _this.$forms;
          fn1 = function(form, fields) {
            return qforms.push(Q.async(function*() {
              if (!(fields != null ? fields.__all : void 0)) {
                fields = Object.keys(fields);
                if (!((fields != null ? fields.length : void 0) > 0)) {
                  fields = void 0;
                }
              } else {
                fields = void 0;
              }
              return _this.$forms[form] = (yield _this.site.form.get(form, _this.req, _this.res, fields));
            })());
          };
          for (form in ref6) {
            fields = ref6[form];
            fn1(form, fields);
          }
          if (_this.top._isState) {
            if (_this.top.__states) {
              o = _this.top.__states;
            } else {
              o = {};
              o[node._statename] = _this.top.__state;
            }
            for (sn in o) {
              s = o[sn];
              s.page_tags = _this.tags;
            }
          }
          _this.modules = {};
          _this.modulesExt = {};
          _this.css = "";
          _this.jsModules = "";
          _this.jsClient = Feel.clientJs;
          _this.stack = [];
          (yield Q.all(qforms));
          _this.time('forms get');
          _this.$urlforms = [];
          _this.$durlforms = [];
          _this.w8defer = [];
          _this.walk_tree_down(_this.top, _this, 'top', function(node, pnode, key) {
            var deffoo;
            if (!node["$defer"]) {
              return;
            }
            deffoo = node["$defer"];
            delete pnode[key];
            return _this.w8defer.push(Q.async(function*() {
              return pnode[key] = (yield $W(deffoo)());
            })());
          });
          (yield Q.all(_this.w8defer));
          _this.walk_tree_down(_this.top, _this, 'top', function(node, pnode, key) {
            (function() {
              if (!(node != null ? node._isModule : void 0)) {
                return;
              }
              if ((node != null ? node.value : void 0) == null) {
                return;
              }
              _objRelativeKey(node != null ? node.value : void 0, '$urlform', function(obj, part, fkf) {
                var base5, path, ref10, ref11, ref12, ref13, ref14, ref7, ref8, ref9, uform, vd, vv;
                uform = {
                  node: node,
                  part: part,
                  fkf: fkf
                };
                vv = _setKey((ref7 = _this.req) != null ? (ref8 = ref7.udata) != null ? ref8[uform != null ? (ref9 = uform.fkf) != null ? ref9.form : void 0 : void 0] : void 0 : void 0, uform != null ? (ref10 = uform.fkf) != null ? ref10.key : void 0 : void 0);
                if (typeof uform.fkf.foo === 'function') {
                  vv = uform.fkf.foo(vv);
                }
                vd = _setKey((ref11 = _this.req) != null ? (ref12 = ref11.udatadefault) != null ? ref12[uform != null ? (ref13 = uform.fkf) != null ? ref13.form : void 0 : void 0] : void 0 : void 0, uform != null ? (ref14 = uform.fkf) != null ? ref14.key : void 0 : void 0);
                if (typeof uform.fkf.foo === 'function') {
                  vd = uform.fkf.foo(vd);
                }
                if (vv == null) {
                  vv = vd;
                }
                if ((base5 = uform.node).$urlforms == null) {
                  base5.$urlforms = {};
                }
                uform.node.$urlforms[uform.part] = uform.fkf;
                path = 'value';
                if (uform.part) {
                  path += "." + uform.part;
                }
                _setKey(uform.node, path, vv, true);
                if (vd != null) {
                  path = 'default';
                  if (uform.part) {
                    path += "." + uform.part;
                  }
                  return _setKey(uform.node, path, vd, true);
                }
              });
              return _objRelativeKey(node != null ? node.value : void 0, '$durlform', function(obj, part, fkf) {
                var base5, path, ref10, ref11, ref12, ref13, ref14, ref7, ref8, ref9, uform, vd, vv;
                uform = {
                  node: node,
                  part: part,
                  fkf: fkf
                };
                vv = _setKey((ref7 = _this.req) != null ? (ref8 = ref7.udata) != null ? ref8[uform != null ? (ref9 = uform.fkf) != null ? ref9.form : void 0 : void 0] : void 0 : void 0, uform != null ? (ref10 = uform.fkf) != null ? ref10.key : void 0 : void 0);
                if (typeof uform.fkf.foo === 'function') {
                  vv = uform.fkf.foo(vv);
                }
                vd = _setKey((ref11 = _this.req) != null ? (ref12 = ref11.udatadefault) != null ? ref12[uform != null ? (ref13 = uform.fkf) != null ? ref13.form : void 0 : void 0] : void 0 : void 0, uform != null ? (ref14 = uform.fkf) != null ? ref14.key : void 0 : void 0);
                if (typeof uform.fkf.foo === 'function') {
                  vd = uform.fkf.foo(vd);
                }
                if (vd == null) {
                  vd = vv;
                }
                vv = vd;
                if ((base5 = uform.node).$durlforms == null) {
                  base5.$durlforms = {};
                }
                uform.node.$durlforms[uform.part] = uform.fkf;
                path = 'value';
                if (uform.part) {
                  path += "." + uform.part;
                }
                _setKey(uform.node, path, vv, true);
                if (vd != null) {
                  path = 'default';
                  if (uform.part) {
                    path += "." + uform.part;
                  }
                  return _setKey(uform.node, path, vd, true);
                }
              });
            })();
            (function() {
              var ref7, results, v;
              if (!(node != null ? node._isModule : void 0)) {
                return;
              }
              if ((node != null ? node["default"] : void 0) != null) {
                if (typeof node["default"] !== 'object') {
                  if (node.value == null) {
                    node.value = node["default"];
                  }
                  return;
                }
                ref7 = node["default"];
                results = [];
                for (key in ref7) {
                  val = ref7[key];
                  v = _setKey(node.value, key);
                  if (v == null) {
                    results.push(_setKey(node.value, key, val));
                  } else {
                    results.push(void 0);
                  }
                }
                return results;
              }
            })();
            (function() {
              var field, fname, func, place, ref7, t;
              if (!(node != null ? node._isModule : void 0)) {
                return;
              }
              if (!(node.$form && (typeof node.$form === 'object'))) {
                return;
              }
              fname = (ref7 = Object.keys(node.$form)) != null ? ref7[0] : void 0;
              if (!(fname && (_this.$forms[fname] != null))) {
                return console.error("bad form" + _inspect(node.$form));
              }
              field = node.$form[fname];
              place = 'value';
              func = void 0;
              if (typeof field === 'object') {
                t = Object.keys(field)[0];
                if (typeof field[t] === 'function') {
                  func = field[t];
                  field = t;
                } else {
                  place = field[t];
                  field = t;
                  if (typeof place === 'object') {
                    t = Object.keys(place)[0];
                    if (typeof place[t] === 'function') {
                      func = place[t];
                    }
                    place = t;
                  }
                }
              }
              delete node.$form;
              node[place] = _this.getField(_this.$forms[fname], field);
              if (func) {
                return node[place] = typeof func === "function" ? func(node[place]) : void 0;
              }
            })();
            return (function() {
              var boo, field, fname, func, k, place, ref7, results, t;
              results = [];
              for (k in node) {
                val = node[k];
                if (val != null ? val._isModule : void 0) {
                  continue;
                }
                if (typeof val !== 'object') {
                  continue;
                }
                if (!val) {
                  continue;
                }
                if (!val.$form) {
                  continue;
                }
                if (typeof val.$form !== 'object') {
                  continue;
                }
                fname = (ref7 = Object.keys(val.$form)) != null ? ref7[0] : void 0;
                if (!(fname && (_this.$forms[fname] != null))) {
                  console.error("bad form" + _inspect(val.$form));
                  continue;
                }
                field = val.$form[fname];
                place = 'value';
                func = void 0;
                boo = false;
                if (typeof field === 'object') {
                  t = Object.keys(field)[0];
                  if (typeof field[t] === 'function') {
                    func = field[t];
                    field = t;
                  } else {
                    boo = true;
                    place = field[t];
                    field = t;
                    if (typeof place === 'object') {
                      t = Object.keys(place)[0];
                      if (typeof place[t] === 'function') {
                        func = place[t];
                      }
                      place = t;
                    }
                  }
                }
                delete node[k];
                if (!boo) {
                  node[k] = _this.getField(_this.$forms[fname], field);
                  if (func) {
                    results.push(node[k] = typeof func === "function" ? func(node[k]) : void 0);
                  } else {
                    results.push(void 0);
                  }
                } else {
                  node[place] = _this.getField(_this.$forms[fname], field);
                  if (func) {
                    results.push(node[place] = typeof func === "function" ? func(node[place]) : void 0);
                  } else {
                    results.push(void 0);
                  }
                }
              }
              return results;
            })();
          });
          ref7 = _this.$urlforms;
          for (l = 0, len2 = ref7.length; l < len2; l++) {
            uform = ref7[l];
            vv = _setKey((ref8 = _this.req) != null ? (ref9 = ref8.udata) != null ? ref9[uform != null ? (ref10 = uform.fkf) != null ? ref10.form : void 0 : void 0] : void 0 : void 0, uform != null ? (ref11 = uform.fkf) != null ? ref11.key : void 0 : void 0);
            if ((base5 = uform.node).$urlforms == null) {
              base5.$urlforms = {};
            }
            uform.node.$urlforms[uform.part] = uform.fkf;
            if (typeof uform.fkf.foo === 'function') {
              vv = uform.fkf.foo(vv);
            }
            path = 'value';
            if (uform.part) {
              path += "." + uform.part;
            }
            _setKey(uform.node, path, vv, true);
            if (uform.fkf["default"] != null) {
              path = 'default';
              if (uform.part) {
                path += "." + uform.part;
              }
              _setKey(uform.node, path, uform.fkf["default"], true);
            }
          }
          ref12 = _this.$durlforms;
          for (q = 0, len3 = ref12.length; q < len3; q++) {
            uform = ref12[q];
            vv = _setKey((ref13 = _this.req) != null ? (ref14 = ref13.udata) != null ? ref14[uform != null ? (ref15 = uform.fkf) != null ? ref15.form : void 0 : void 0] : void 0 : void 0, uform != null ? (ref16 = uform.fkf) != null ? ref16.key : void 0 : void 0);
            if ((base6 = uform.node).$urlforms == null) {
              base6.$urlforms = {};
            }
            uform.node.$urlforms[uform.part] = uform.fkf;
            if (typeof uform.fkf.foo === 'function') {
              vv = uform.fkf.foo(vv);
            }
            path = 'value';
            if (uform.part) {
              path += "." + uform.part;
            }
            if (uform.fkf["default"] != null) {
              _setKey(uform.node, path, uform.fkf["default"], true);
              path = 'default';
              if (uform.part) {
                path += "." + uform.part;
              }
              _setKey(uform.node, path, uform.fkf["default"], true);
            }
          }
          _this.time('forms set');
          (yield _this.parse(_this.top, null, _this.top, _this.top, _this, 'top'));
          if (_this.site.modules['default'].allCss && (_this.modules['default'] == null) && (!_this.state.page_tags['skip:default'])) {
            _this.cssModule('default');
          }
          for (modname in _this.modules) {
            if (_this.site.modules[modname].allCss && (!_this.state.page_tags['skip:' + modname])) {
              _this.cssModule(modname);
            }
          }
          ref17 = _this.modulesExt;
          for (modname in ref17) {
            val = ref17[modname];
            if (_this.site.modules[modname].allCss && (!_this.state.page_tags['skip:' + modname])) {
              _this.cssModuleExt(modname, val);
            }
            for (key in val) {
              _this.modules[key] = true;
            }
          }
          _this.time('parse');
          title = _this.state.title;
          if (title == null) {
            title = _this.statename;
          }
          end = "";
          end += '<!DOCTYPE html><html><head>';
          end += _this.site.router.head;
          end += '<title>' + title + '</title>';
          end += '<link rel="shortcut icon" href="' + Feel["static"].F(_this.site.name, 'favicon.ico') + '" />';
          end += _this.css + '</head><body>';
          end += _this.site.router.body;
          end += _this.top._html;
          _this.removeHtml(_this.top);
          _this.time("remove html");
          json_tree = _this.getTree(_this.top);
          try {
            json_ = JSON.stringify(json_tree);
          } catch (error) {
            e = error;
            json_ = "InfiniteJSON.parse(decodeURIComponent('" + (encodeURIComponent(_toJson(json_tree))) + "'))";
          }
          json_tree = json_;
          _this.time("stringify");
          end += "<script> 'use strict'; window.StopIteration = undefined;</script> <script type='text/javascript' src='/jsclient/" + Feel.clientRegeneratorHash + "/regenerator'></script>";
          end += _this.addModuleJs('lib/jquery') + _this.addModuleJs('lib/jquery/plugins') + _this.addModuleJs('lib/q') + _this.addModuleJs('lib/event_emitter') + _this.addModuleJs('lib/jade') + _this.addModuleJs('lib/lodash') + _this.addModuleJs('lib/object_hash');
          end += '<script id="feel-js-client"> "use strict";' + ('window.EE = EventEmitter; var $Feel = {}; $Feel.version = ' + Feel.version + '; $Feel.oldversion = $.localStorage.get("coreVersion"); if ($Feel.oldversion != $Feel.version) { $.localStorage.removeAll(); $.localStorage.set("coreVersion",$Feel.version); } $Feel.root = { "tree" : ' + json_tree + '}; $Feel.constJson = ' + _this.site.constJson + '; $Feel.user = {}; $Feel.servicesIp = ' + _this.site.servicesIp + '; $Feel.user.id = "' + (_this.req.user.id || 666) + '"; $Feel.user.type = ' + JSON.stringify((ref18 = _this.req.user.type) != null ? ref18 : {}) + '; $Feel.user.sessionpart = "' + (_this.req.session.substr(0, 8)) + '"; $Feel.modules = {}; $Feel.urlforms = {};') + '</script>' + ("<script type='text/javascript' src='/jsclient/" + Feel.clientJsHash + "/client'></script>") + '<script id="feed-js-modules"> "use strict"; console.log("Feel",$Feel);' + _this.jsModules + '</script>';
          end += _this.site.urldataFilesStr;
          for (modname in _this.modules) {
            if (_this.state.page_tags['skip:' + modname]) {
              continue;
            }
            if ((ref19 = _this.site.modules[modname]) != null ? ref19.allCoffee : void 0) {
              end += "<script>window._FEEL_that = $Feel.modules['" + modname + "'] = {};</script>";
              names = _this.site.modules[modname].jsNames();
              for (r = 0, len4 = names.length; r < len4; r++) {
                n = names[r];
                end += _this.site.moduleJsFileTag(modname, n);
              }
            }
          }
          end += '<script id="feel-js-startFeel"> "use strict"; Feel.init().done();</script>' + ' </body></html>';
          _this.time("end str finish");
          sha1 = require('crypto').createHash('sha1');
          sha1.update(end);
          resHash = sha1.digest('hex').substr(0, 8);
          _this.time("create hash");
          if (resHash === _this.reqEtag) {
            _this.res.statusCode = 304;
            return _this.res.end();
          }
          _this.res.setHeader('Access-Control-Allow-Origin', '*');
          _this.res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
          _this.res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
          _this.res.setHeader('Access-Control-Allow-Credentials', true);
          _this.res.setHeader('ETag', resHash);
          _this.res.setHeader('Cache-Control', 'public, max-age=1');
          _this.res.setHeader('content-encoding', 'gzip');
          d = new Date();
          d.setTime(d.getTime() + 1);
          _this.res.setHeader('Expires', d.toGMTString());
          zlib = require('zlib');
          return zlib.gzip(end, {
            level: 9
          }, function(err, resdata) {
            if (err != null) {
              return Feel.res500(_this.req, _this.res, err);
            }
            _this.res.setHeader('content-length', resdata.length);
            _this.res.end(resdata);
            _this.time('zlib');
            return console.log(process.pid + (":state " + _this.statename), _this.res.statusCode || 200, resdata.length / 1024, end.length / 1024, Math.ceil((resdata.length / end.length) * 100) + "%");
          });
        };
      })(this))();
    };

    RouteState.prototype.addModuleJs = function(name) {
      if (!this.state.page_tags['skip:' + name]) {
        return this.site.moduleJsTag(name);
      } else {
        return "";
      }
    };

    RouteState.prototype.removeHtml = function(node) {
      var key, results, val;
      if (node.req != null) {
        delete node.req;
      }
      if (node.res != null) {
        delete node.res;
      }
      if (node != null ? node._smart : void 0) {
        return;
      }
      results = [];
      for (key in node) {
        val = node[key];
        if (key === '_html') {
          results.push(delete node[key]);
        } else if (typeof val === 'object' && val) {
          results.push(this.removeHtml(val));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    RouteState.prototype.cssModule = function(modname) {
      return this.css += "<style id=\"f-css-" + modname + "\">" + this.site.modules[modname].allCss + "</style>";
    };

    RouteState.prototype.cssModuleExt = function(modname, exts) {
      var css;
      css = this.site.modules[modname].getAllCssExt(exts);
      return this.css += "<style id=\"f-css-" + modname + "-exts\">" + css + "</style>";
    };

    RouteState.prototype.parse = function(now, uniq, module, state, _pnode, _pkey) {
      return Q.async((function(_this) {
        return function*() {
          var base, e, error, error1, ext, filetag, i, j, key, len, len1, m, ms, name1, new_module, new_state, o, ref, ref1, ref2, ref3, ref4, tempGThis, val;
          if ((now != null ? (ref = now.__state) != null ? (ref1 = ref.parent) != null ? ref1.tree : void 0 : void 0 : void 0) != null) {
            _this.getTopNode(now, true);
          }
          new_module = module;
          new_state = state;
          if (now._isModule) {
            uniq = _this.rand = rand(_this.rand);
            if (now._uniq == null) {
              now._uniq = uniq;
            }
            uniq = now._uniq;
            m = now._name.match(/^\/\/(.*)$/);
            if (m) {
              if (!_this.stack.length) {
                throw new Error("can't find parent module for // in modname '" + now._name + "' in state '" + _this.statename + "'");
              }
              now._name = _this.stack[_this.stack.length - 1] + ("/" + m[1]);
            }
            _this.stack.push(now._name);
          }
          for (key in now) {
            val = now[key];
            if (val && typeof val === 'object' && !val._smart) {
              if (val.__state != null) {
                new_state = val;
              } else {
                new_state = state;
              }
              if (val._isModule) {
                new_module = val;
              } else {
                new_module = module;
              }
              (yield _this.parse(val, uniq, new_module, new_state, now, key));
            }
          }
          if (now._isModule) {
            _this.modules[now._name] = true;
            if (now._extends_modules.length) {
              if ((base = _this.modulesExt)[name1 = now._name] == null) {
                base[name1] = {};
              }
              ref2 = now._extends_modules;
              for (i = 0, len = ref2.length; i < len; i++) {
                ext = ref2[i];
                _this.modulesExt[now._name][ext] = true;
              }
            }
            o = _this.getO(now, uniq);
            if (_this.site.modules[now._name] == null) {
              throw new Error("can't find module '" + now._name + "' in state '" + _this.statename + "'");
            }
            filetag = (ref3 = _this.site.modules[now._name]) != null ? (ref4 = ref3.coffeenr) != null ? ref4['parse.coffee'] : void 0 : void 0;
            if (filetag) {
              tempGThis = {};
              try {
                eval("(function(){" + filetag + "}).apply(tempGThis);");
              } catch (error) {
                e = error;
                console.error("failed eval parse.coffee in " + now._name);
                console.error(e);
              }
              try {
                tempGThis.parse = $W(tempGThis.parse);
                o.value = (yield tempGThis.parse(o.value));
              } catch (error1) {
                e = error1;
                console.error("failed parse.coffee:parse() value:'" + o.value + "' in " + now._name);
                console.error(e);
              }
            }
            now._html = _this.site.modules[now._name].doJade(o, _this, state.__state);
            ms = now._html.match(/js-\w+--{{UNIQ}}/mg);
            now._domregx = {};
            if (ms) {
              for (j = 0, len1 = ms.length; j < len1; j++) {
                m = ms[j];
                m = m.match(/js-(\w+)--/)[1];
                now._domregx[m] = true;
              }
            }
            now._html = now._html.replace(/{{UNIQ}}/mg, uniq);
            return _this.stack.pop();
          }
        };
      })(this))();
    };

    RouteState.prototype.getO = function(obj, uniq) {
      var base, html, idn, k_, key, ref, ref1, ret, save_, v_, val;
      ret = {};
      for (key in obj) {
        val = obj[key];
        ret[key] = val;
        if (val && typeof val === 'object' && !val._smart) {
          ret[key] = this.getO(val, uniq);
        }
        if ((ref = ret[key]) != null ? ref._isModule : void 0) {
          if ((base = ret[key])._uniq == null) {
            base._uniq = this.rand = rand(this.rand);
          }
          html = "";
          if (ret[key]._html != null) {
            idn = ret[key]._name.replace(/\//g, '-');
            save_ = ret[key]._html.replace("m-" + idn, "m-" + idn + "\" uniq=\"" + uniq + ":" + ret[key]._uniq + "\" class=\"m-" + uniq + "-" + idn);
            ref1 = ret[key];
            for (k_ in ref1) {
              v_ = ref1[k_];
              save_[k_] = v_;
            }
            ret[key] = save_;
          }
        }
      }
      return ret;
    };

    RouteState.prototype.redirect = function(req, res, val) {
      return Q.async((function(_this) {
        return function*() {
          if (_this.site.state[val] != null) {
            val = _this.site.state[val]["class"].prototype.route;
          }
          if (!val) {
            return Feel.res403(req, res);
          }
          val = (yield req.udataToUrl(val));
          res.statusCode = 301;
          res.setHeader('location', val);
          res.setHeader('Cache-Control', 'no-cache');
          return res.end();
        };
      })(this))();
    };

    return RouteState;

  })();

  module.exports = RouteState;

}).call(this);
