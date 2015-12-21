(function() {
  var Server, _crypto, http, https, os, spdy,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  http = require('http');

  spdy = require('spdy');

  https = require('https');

  _crypto = require('crypto');

  os = require("os");

  Server = (function() {
    function Server() {
      this.run = bind(this.run, this);
      this.handler = bind(this.handler, this);
      this.udataToUrl = bind(this.udataToUrl, this);
      this.handlerHttpRedirect = bind(this.handlerHttpRedirect, this);
      this.google = bind(this.google, this);
      this.runSsh = bind(this.runSsh, this);
      this.init = bind(this.init, this);
      var hostname;
      this._google = {};
      hostname = os.hostname();
      console.log('hostname', hostname);
      this.port = 8081;
      this.ip = '127.0.0.1';
      this.ip2 = '176.9.22.118';
      this.ip3 = '176.9.22.124';
      switch (hostname) {
        case 'pi0h.org':
          this.port = 8081;
          this.ip = this.ip2;
          this.ssh = true;
          break;
        default:
          this.port = 8081;
      }
    }

    Server.prototype.init = function() {
      var domain, i, len, ref, ref1, site, sitename;
      if (!this.ssh) {
        this.server = http.createServer(this.handler);
      } else {
        this.server = http.createServer(this.handlerHttpRedirect);
      }
      if (_production) {
        this.server.listen(this.port, this.ip);
      } else {
        this.server.listen(this.port);
      }
      if (this.ssh) {
        this.runSsh();
      }
      console.log("listen port " + this.ip + ":" + this.port);
      this.domains = {
        text: {},
        reg: []
      };
      ref = Feel.site;
      for (sitename in ref) {
        site = ref[sitename];
        if (site.config.domains != null) {
          switch (typeof site.config.domains) {
            case 'string':
              this.domains.text[site.config.domains] = sitename;
              break;
            case 'object':
              if (site.config.domains instanceof RegExp) {
                this.domains.reg.push([site.config.domains, sitename]);
              } else if (site.config.domains.length) {
                ref1 = site.config.domains;
                for (i = 0, len = ref1.length; i < len; i++) {
                  domain = ref1[i];
                  if (typeof domain === 'string') {
                    this.domains.text[domain] = sitename;
                  }
                  if (domain instanceof RegExp) {
                    this.domains.reg.push([domain, sitename]);
                  }
                }
              }
          }
        }
      }
      return Q();
    };

    Server.prototype.runSsh = function() {
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
      if (_production) {
        return this.sshServer.listen(8083, this.ip);
      } else {
        return this.sshServer.listen(8083);
      }
    };

    Server.prototype.google = function(req, res, params) {
      var hash, p, result;
      hash = _crypto.createHash('sha1').update(params).digest('hex');
      if (this._google[hash] != null) {
        p = this._google[hash];
        res.statusCode = p.statusCode;
        res.writeHead(p.statusCode, p.headers);
        res.write(p.data);
        return res.end();
      }
      result = (function(_this) {
        return function(nres) {
          var data;
          data = "";
          res.statusCode = nres.statusCode;
          res.writeHead(nres.statusCode, nres.headers);
          nres.on('data', function(d) {
            res.write(d);
            return data += d.toString();
          });
          return nres.on('end', function() {
            var base;
            res.end();
            if ((base = _this._google)[hash] == null) {
              base[hash] = {};
            }
            _this._google[hash].statusCode = nres.statusCode;
            _this._google[hash].headers = nres.headers;
            return _this._google[hash].data = data;
          });
        };
      })(this);
      return https.get("https://maps.googleapis.com/maps/api/place/autocomplete/json?" + params + "&key=AIzaSyBUSFJqRf-3yY35quvhW9LY3QLwj_G9d7A", result).on('error', (function(_this) {
        return function(e) {
          res.statusCode = 404;
          return res.end(JSON.strinigfy(e));
        };
      })(this));
    };

    Server.prototype.handlerHttpRedirect = function(req, res) {
      var host, m;
      res.statusCode = 301;
      host = req.headers.host;
      if (m = host != null ? host.match(/^www\.(.*)$/) : void 0) {
        host = m[1];
      }
      res.setHeader('location', "https://" + host + req.url);
      return res.end();
    };

    Server.prototype.udataToUrl = function(req, res, url) {
      return Q.async((function(_this) {
        return function*() {
          var obj, ref, urldata;
          if (url == null) {
            obj = req;
          } else {
            obj = {
              url: url
            };
          }
          if (!(((req != null ? req.udata : void 0) != null) && ((req != null ? req.site : void 0) != null))) {
            return obj.url;
          }
          urldata = (yield req.site.urldata.d2u((ref = req.udata) != null ? ref : {}));
          if (urldata) {
            urldata = "?" + urldata;
          } else {
            urldata = "";
          }
          obj.url = obj.url.replace(/\?.*$/g, "");
          obj.url += urldata;
          return obj.url;
        };
      })(this))();
    };

    Server.prototype.handler = function(req, res) {
      var _end, host, i, len, m, ref, ref1, reg, site;
      req.udataToUrl = (function(_this) {
        return function(url) {
          return _this.udataToUrl(req, res, url);
        };
      })(this);
      m = req.url.match(/^([^\?]*)\?(.*)$/);
      if (m) {
        req.udata = m[2];
        req.originalUrl = req.url;
        req.url = m[1];
      }
      if (req.url === '/404') {
        _end = res.end;
        res.end = function() {
          res.statusCode = 404;
          return _end.apply(res, arguments);
        };
      } else if (req.url === '/500') {
        _end = res.end;
        res.end = function() {
          res.statusCode = 500;
          return _end.apply(res, arguments);
        };
      } else if (req.url === '/403') {
        _end = res.end;
        res.end = function() {
          res.statusCode = 403;
          return _end.apply(res, arguments);
        };
      }
      if (this.ssh) {
        res.setHeader('Strict-Transport-Security', 'max-age=604800; includeSubDomains; preload');
      }
      host = req.headers.host;
      if (m = host != null ? host.match(/^www\.(.*)$/) : void 0) {
        res.statusCode = 301;
        host = m[1];
        res.setHeader('location', "//" + host + req.url);
        return res.end();
      }
      if (m = req.url.match(/^\/google\?(.*)$/)) {
        return this.google(req, res, m[1]);
      }
      req.time = new Date().getTime();
      site = "";
      host = req.headers.host;
      if (this.domains.text[host] != null) {
        site = this.domains.text[host];
      } else {
        ref = this.domains.reg;
        for (i = 0, len = ref.length; i < len; i++) {
          reg = ref[i];
          if (host.match(reg[0])) {
            this.domains.text[host] = reg[1];
            site = reg[1];
            break;
          }
        }
      }
      if (!_production && (Feel.site[site] == null)) {
        site = 'lessonhome';
      }
      if (Feel.site[site] != null) {
        return Q().then((function(_this) {
          return function() {
            return Feel.site[site].router.handler(req, res);
          };
        })(this))["catch"]((function(_this) {
          return function(e) {
            console.error("Failed route " + host + req.url + " to site " + site + ":\n\t");
            console.error(Exception(e));
            if (req.url !== '/500') {
              req.url = "/500";
              return _this.handler(req, res);
            }
            res.statusCode = 500;
            return res.end('Internal Server Error');
          };
        })(this)).done();
      } else {
        if (req.url !== '/404') {
          req.headers.host = (ref1 = Object.keys(this.domains.text)) != null ? ref1[0] : void 0;
          req.url = '/404';
          return this.handler(req, res);
        }
        res.statusCode = 404;
        return res.end('Unknown host');
      }
    };

    Server.prototype.run = function() {};

    return Server;

  })();

  module.exports = Server;

}).call(this);
