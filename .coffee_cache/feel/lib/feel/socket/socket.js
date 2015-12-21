(function() {
  var Form, Socket, _cookies, http, os, spdy, url,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  http = require('http');

  os = require('os');

  spdy = require('spdy');

  url = require('url');

  _cookies = require('cookies');

  Form = require('../class/form');

  Socket = (function() {
    function Socket() {
      this.resolve = bind(this.resolve, this);
      this.updateUser = bind(this.updateUser, this);
      this.status = bind(this.status, this);
      this.handler = bind(this.handler, this);
      this.initHandler = bind(this.initHandler, this);
      this.run = bind(this.run, this);
      this.runSsh = bind(this.runSsh, this);
      this.init = bind(this.init, this);
      Wrap(this);
    }

    Socket.prototype.init = function*() {
      this.db = (yield Main.service('db'));
      this.form = new Form;
      (yield this.form.init());
      this.register = (yield Main.service('register'));
      if (os.hostname() === 'pi0h.org') {
        (yield this.runSsh());
      } else {
        this.server = http.createServer(this.handler);
        this.server.listen(Main.conf.args.port);
      }
      return this.handlers = {};
    };

    Socket.prototype.runSsh = function() {
      var options;
      options = {
        key: _fs.readFileSync('/key/server.key'),
        cert: _fs.readFileSync('/key/server.crt'),
        ciphers: "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4",
        honorCipherOrder: true,
        autoSpdy31: true,
        ssl: true
      };
      this.sshServer = spdy.createServer(options, this.handler);
      return this.sshServer.listen(Main.conf.args.port);
    };

    Socket.prototype.run = function*() {
      return (yield this.initHandler(Main.conf.args.file));
    };

    Socket.prototype.initHandler = function*(clientName) {
      var key, obj, ref, val;
      if (this.handlers[clientName] == null) {
        this.handlers[clientName] = require((process.cwd()) + "/www/lessonhome/" + clientName + ".c.coffee");
        obj = this.handlers[clientName];
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
        return (yield (obj != null ? typeof obj.init === "function" ? obj.init() : void 0 : void 0));
      }
    };

    Socket.prototype.handler = function(req, res) {
      return Q.spawn((function(_this) {
        return function*() {
          var $, _, _keys, cb, clientName, context, cookie, d, data, e, error, error1, error2, host, i, len, path, pref, ref, register, ret, session, unknown;
          host = req.headers.host;
          console.log(host);
          $ = {};
          $.req = req;
          $.res = res;
          $.register = _this.register;
          req.cookie = cookie = new _cookies(req, res);
          session = cookie.get('session');
          unknown = cookie.get('unknown');
          register = (yield _this.register.register(session, unknown, cookie.get('adminHash')));
          session = register.session;
          req.user = register.account;
          if (req.user.unknown !== unknown) {
            cookie.set('unknown', req.user.unknown, {
              httpOnly: false
            });
          }
          _ = url.parse(req.url, true);
          try {
            data = JSON.parse(_.query.data);
            context = JSON.parse(_.query.context);
            pref = JSON.parse(_.query.pref);
          } catch (error) {
            e = error;
            console.error(e);
            return res.end();
          }
          cb = _.query.callback;
          path = _.pathname;
          clientName = (yield _this.resolve(context, path, pref));
          _keys = [];
          for (i = 0, len = data.length; i < len; i++) {
            d = data[i];
            if (typeof d === 'object' && d !== null) {
              _keys.push('{' + Object.keys(d).join(',') + '}');
            } else {
              _keys.push(d);
            }
          }
          console.log("client:".blue + clientName.yellow + ("::handler(" + _keys.join(',') + ");").grey);
          (yield _this.initHandler(clientName));
          $.db = _this.db;
          (function(req, res) {
            if (req == null) {
              req = {};
            }
            if (req.status == null) {
              req.status = {};
            }
            return req.status = function() {
              var args;
              args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
              return _this.status.apply(_this, [req, res].concat(slice.call(args)));
            };
          })(req, res);
          $.status = $.req.status;
          $.user = req.user;
          $.session = session;
          $.cookie = cookie;
          $.form = _this.form;
          $.updateUser = function(session) {
            return _this.updateUser(req, res, $, session);
          };
          try {
            ret = (yield (ref = _this.handlers[clientName]).handler.apply(ref, [$].concat(slice.call(data))));
          } catch (error1) {
            e = error1;
            console.error(Exception(e));
            ret = {
              err: "internal_error",
              status: 'failed'
            };
          }
          res.statusCode = 200;
          res.setHeader('content-type', 'application/json; charset=UTF-8');
          ret = ret;
          try {
            return res.end(cb + "(" + (JSON.stringify({
              data: ret
            })) + ");");
          } catch (error2) {
            e = error2;
            console.error(Exception(new Error("failed JSON.stringify client returned object")));
            ret = {
              status: "failed",
              err: "internal_error"
            };
            return res.end(cb + "(" + (JSON.stringify({
              data: ret
            })) + ");");
          }
        };
      })(this));
    };

    Socket.prototype.status = function*(req, res, name, value) {
      var db, ref, status;
      db = (yield this.db.get('accounts'));
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

    Socket.prototype.updateUser = function*(req, res, $, session) {
      var cookie, register, unknown;
      cookie = req.cookie;
      if (session == null) {
        session = cookie.get('session');
      }
      unknown = cookie.get('unknown');
      console.log(session);
      register = (yield this.register.register(session, cookie.get('unknown'), cookie.get('adminHash')));
      session = register.session;
      req.user = register.account;
      $.user = req.user;
      if (unknown !== register.account.unknown) {
        cookie.set('unknown', register.account.unknown, {
          httpOnly: false
        });
      }
      $.user = req.user;
      return $.session = session;
    };

    Socket.prototype.resolve = function(context, path, pref) {
      var file, m, name, p, postfix, s, suffix;
      name = pref + path.substr(1);
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
        file = _path.normalize(suffix + "/" + p + "/" + postfix);
      } else if (postfix.match(/^\//)) {
        if (!suffix) {
          suffix = "runtime";
        }
        file = _path.normalize(suffix + postfix);
      } else {
        if (!suffix) {
          suffix = "runtime";
        }
        file = _path.normalize(suffix + "/" + postfix);
      }
      return file;
    };

    return Socket;

  })();

  module.exports = Socket;

}).call(this);
