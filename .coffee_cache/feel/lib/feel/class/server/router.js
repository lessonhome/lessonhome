(function() {
  var RouteState, Router, _cookies,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  RouteState = require('./routeState');

  _cookies = require('cookies');

  Router = (function() {
    function Router(site) {
      this.site = site;
      this.redirect = bind(this.redirect, this);
      this.setSession = bind(this.setSession, this);
      this.handler = bind(this.handler, this);
      this.init = bind(this.init, this);
      this._redirects = require(process.cwd() + ("/www/" + this.site.name + "/router/redirects"));
      this.url = {
        text: {},
        reg: []
      };
    }

    Router.prototype.init = function() {
      var r, ref, results, route, state, statename;
      try {
        this.head = _fs.readFileSync(process.cwd() + ("/www/" + this.site.name + "/config/head/head.html")).toString();
      } catch (undefined) {}
      try {
        this.body = _fs.readFileSync(process.cwd() + ("/www/" + this.site.name + "/config/body/body.html")).toString();
      } catch (undefined) {}
      if (this.head == null) {
        this.head = '';
      }
      if (this.body == null) {
        this.body = '';
      }
      ref = this.site.state;
      results = [];
      for (statename in ref) {
        state = ref[statename];
        route = state["class"].prototype.route;
        if (route) {
          if (typeof route === 'string') {
            if (this.url.text[route] != null) {
              throw new Error("same route('" + route + "') in states '" + this.url.text[route] + "' and '" + statename + "'!");
            }
            results.push(this.url.text[route] = statename);
          } else if (route instanceof RegExp) {
            results.push(this.url.reg.push([route, statename]));
          } else if (route.length) {
            results.push((function() {
              var i, len, results1;
              results1 = [];
              for (i = 0, len = route.length; i < len; i++) {
                r = route[i];
                if (typeof r === 'string') {
                  if (this.url.text[r] != null) {
                    throw new Error("same route('" + r + "') in states '" + this.url.text[r] + "' and '" + statename + "'!");
                  }
                  results1.push(this.url.text[r] = statename);
                } else if (r instanceof RegExp) {
                  results1.push(this.url.reg.push([r, statename]));
                } else {
                  results1.push(void 0);
                }
              }
              return results1;
            }).call(this));
          } else {
            results.push(void 0);
          }
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    Router.prototype.handler = function(req, res) {
      return Q.async((function(_this) {
        return function*() {
          var _session, abTest, abchanged, abcookie, ahash, base, cookie, i, key, len, nurl, redirect, ref, ref1, ref2, ref3, ref4, ref5, ref6, reg, route, statename, ucook, ucookstr, uredirect, val;
          req.site = _this.site;
          req.status = function() {
            var args, ref;
            args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
            return (ref = _this.site).status.apply(ref, [req, res].concat(slice.call(args)));
          };
          if ((redirect = (ref = _this._redirects) != null ? (ref1 = ref.redirect) != null ? ref1[req != null ? req.url : void 0] : void 0 : void 0) != null) {
            return _this.redirect(req, res, redirect);
          }
          if (req.url === '/favicon.ico') {
            req.url = '/file/666/favicon.ico';
          }
          if (req.url.match(/^\/(js|jsfile|jsfilet|urlform|jsclient)\/.*/)) {
            return Q().then(function() {
              return _this.site.handler(req, res, _this.site.name);
            });
          }
          if (req.url.match(/^\/file\/.*/)) {
            return Q().then(function() {
              return Feel["static"].handler(req, res, _this.site.name);
            });
          }
          cookie = new _cookies(req, res);
          req.cookie = cookie;
          ucook = (ref2 = cookie.get('urldata')) != null ? ref2 : '%257B%257D';
          ucook = (ref3 = decodeURIComponent(decodeURIComponent(ucook))) != null ? ref3 : '{}';
          ucook = (ref4 = JSON.parse(ucook)) != null ? ref4 : {};
          ucookstr = '';
          for (key in ucook) {
            val = ucook[key];
            if (!key) {
              continue;
            }
            if (ucookstr) {
              ucookstr += '&';
            }
            ucookstr += key;
            if (val != null) {
              ucookstr += '=' + val;
            }
          }
          if (ucookstr) {
            if (req.udata == null) {
              req.udata = '';
            }
            if (req.udata) {
              req.udata += "&";
            }
            req.udata += ucookstr;
          }
          _session = cookie.get('session');
          req.udata = _this.site.urldata.u2d(req.udata);
          req.udatadefault = _this.site.urldata.u2d("");
          (yield _this.setSession(req, res, cookie, _session));
          req.udata = (yield req.udata);
          req.udatadefault = (yield req.udatadefault);
          if (req.udata == null) {
            req.udata = {};
          }
          if (req.udatadefault == null) {
            req.udatadefault = {};
          }
          if (req.url.match(/^\/(upload)\/.*/)) {
            return Q().then(function() {
              return _this.site.handler(req, res, _this.site.name);
            });
          }
          if (req.url.match(/^\/(uploaded)\/.*/)) {
            return Q().then(function() {
              return _this.site.handler(req, res, _this.site.name);
            });
          }
          if (req.url.match(/^\/form\/tutor\/login$/)) {
            uredirect = _setKey(req.udata, 'accessRedirect.redirect');
            if (uredirect) {
              _setKey(req.udata, 'accessRedirect.redirect', '');
            } else {
              uredirect = '/tutor/profile';
            }
            return _this.redirect(req, res, uredirect);
          }
          if (req.url.match(/^\/form\/tutor\/register$/)) {
            return _this.redirect(req, res, '/tutor/profile/first_step');
          }
          if (req.url.match(/^\/form\/tutor\/logout$/)) {
            (yield _this.setSession(req, res, cookie, ""));
            ahash = cookie.get('adminHash');
            if (ahash) {
              console.log({
                ahash: ahash
              });
              cookie.set('adminHash');
              (yield req.register.removeAdminHash(ahash));
            }
            return _this.redirect(req, res, '/');
          }
          if ((base = req.udata).abTest == null) {
            base.abTest = {};
          }
          try {
            abcookie = JSON.parse(decodeURIComponent(cookie.get('abTest')));
          } catch (undefined) {}
          if (abcookie == null) {
            abcookie = {};
          }
          abchanged = false;
          ref5 = req.udata.abTest;
          for (key in ref5) {
            val = ref5[key];
            if (val < 0) {
              abchanged = true;
              delete abcookie[key];
            } else if (val > 0) {
              abchanged = true;
              abcookie[key] = val;
            }
          }
          if (abchanged) {
            try {
              cookie.set('abTest', encodeURIComponent(JSON.stringify(abcookie)));
            } catch (undefined) {}
          }
          if ((abTest = abcookie[req.url.replace(/\//, '')]) != null) {
            if (abTest > 0) {
              nurl = req.url + '_abTest_' + abTest;
              if (_this.url.text[nurl] != null) {
                req.url = nurl;
              }
            }
          }
          statename = "";
          if (_this.url.text[req.url] != null) {
            statename = _this.url.text[req.url];
          } else {
            ref6 = _this.url.reg;
            for (i = 0, len = ref6.length; i < len; i++) {
              reg = ref6[i];
              if (req.url.match(reg[0])) {
                statename = reg[1];
                _this.url.text[req.url] = statename;
              }
            }
          }
          if (!statename) {
            return Feel.res404(req, res);
          }
          route = new RouteState(statename, req, res, _this.site);
          return route.go();
        };
      })(this))();
    };

    Router.prototype.setSession = function(req, res, cookie, session) {
      return Q.async((function(_this) {
        return function*() {
          var register, unknown;
          req.register = _this.site.register;
          unknown = cookie.get('unknown');
          register = (yield _this.site.register.register(session, unknown, cookie.get('adminHash')));
          req.session = register.session;
          cookie.set('session', null, {
            expires: new Date("21 May 2020 10:12"),
            overwrite: true
          });
          cookie.set('session', register.session, {
            expires: new Date("21 May 2020 10:12"),
            overwrite: true
          });
          if (register.account.unknown !== unknown) {
            cookie.set('unknown', register.account.unknown, {
              httpOnly: false
            });
          }
          return req.user = register.account;
        };
      })(this))();
    };

    Router.prototype.redirect = function(req, res, location) {
      if (location == null) {
        location = '/';
      }
      return Q.async((function(_this) {
        return function*() {
          (yield console.log('redirect', location));
          res.statusCode = 302;
          location = (yield req.udataToUrl(location));
          res.setHeader('location', location);
          return res.end();
        };
      })(this))();
    };

    return Router;

  })();

  module.exports = Router;

}).call(this);
