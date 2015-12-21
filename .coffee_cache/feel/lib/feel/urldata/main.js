(function() {
  var UrlData, UrlDataFunctions, coffee, kwords, words,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  words = "qwertyuioplkjhgfdsazxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM0123456789";

  kwords = {};

  coffee = require('coffee-script');

  UrlDataFunctions = require('../client/urlDataFunctions').UrlDataFunctions;

  UrlData = (function() {
    function UrlData() {
      this.filterHash = bind(this.filterHash, this);
      this.toObject = bind(this.toObject, this);
      this.objectTo = bind(this.objectTo, this);
      this.filter = bind(this.filter, this);
      this.d2o = bind(this.d2o, this);
      this.u2d = bind(this.u2d, this);
      this.d2u = bind(this.d2u, this);
      this.next = bind(this.next, this);
      this.readConsts = bind(this.readConsts, this);
      this.genFiles = bind(this.genFiles, this);
      this.getJsonString = bind(this.getJsonString, this);
      this.getFFiles = bind(this.getFFiles, this);
      this.getFFile = bind(this.getFFile, this);
      this.init = bind(this.init, this);
      var i, j, len, w;
      Wrap(this);
      for (i = j = 0, len = words.length; j < len; i = ++j) {
        w = words[i];
        kwords[w] = i;
      }
      this.path = _path.resolve(process.cwd() + "/www/lessonhome");
      this.forms = {};
      this.fforms = {};
      this.files = {};
      this["const"] = {};
      this.udata = new UrlDataFunctions;
    }

    UrlData.prototype.init = function*() {
      var base, base1, base2, base3, base4, e, error, f, files, fname, foo, form, j, key, len, m, name1, ref, ref1, ref2, res, val;
      this.Feel = (yield Main.service('feel'));
      (yield this.readConsts());
      this.hostname = require('os').hostname();
      try {
        this.json = require(this.path + "/static/urldata/" + this.hostname + ".json");
        this.json = JSON.parse(JSON.stringify(this.json));
      } catch (error) {
        e = error;
        this.json = {};
      }
      files = (yield _readdir(this.path + "/runtime/urldata"));
      for (j = 0, len = files.length; j < len; j++) {
        f = files[j];
        if (!(m = f.match(/(.*)\.coffee$/))) {
          continue;
        }
        this.fforms[m[1]] = require(this.path + "/runtime/urldata/" + f);
      }
      ref = this.fforms;
      for (fname in ref) {
        form = ref[fname];
        this.forms[fname] = {};
        if (form.U2D != null) {
          this.forms[fname].U2D = Wrap(new form.U2D);
        }
        if (form.D2U != null) {
          this.forms[fname].D2U = Wrap(new form.D2U);
        }
      }
      if ((base = this.json).shorts == null) {
        base.shorts = {};
      }
      if ((base1 = this.json).forms == null) {
        base1.forms = {};
      }
      ref1 = this.forms;
      for (fname in ref1) {
        form = ref1[fname];
        if ((base2 = this.json.forms)[fname] == null) {
          base2[fname] = {};
        }
        ref2 = form.D2U;
        for (key in ref2) {
          foo = ref2[key];
          if (!(m = key.match(/^\$(.*)$/))) {
            continue;
          }
          res = (yield foo({}));
          if (res.cookie == null) {
            res.cookie = false;
          }
          if (!res.type) {
            throw new Error("need type in field " + m[1] + " in urlform " + fname);
          }
          if ((base3 = this.json.forms[fname])[name1 = m[1]] == null) {
            base3[name1] = (yield this.next());
          }
          if (res["default"] == null) {
            switch (res.type) {
              case 'int':
                res["default"] = void 0;
                break;
              case 'string':
                res["default"] = '';
                break;
              case 'bool':
                res["default"] = false;
                break;
              case 'obj':
                res["default"] = {};
            }
          }
          this.json.shorts[this.json.forms[fname][m[1]]] = {
            form: fname,
            field: m[1],
            type: res.type,
            cookie: res.cookie,
            "default": res["default"]
          };
          for (key in res) {
            val = res[key];
            if ((base4 = this.json.shorts[this.json.forms[fname][m[1]]])[key] == null) {
              base4[key] = val;
            }
          }
        }
      }
      (yield _writeFile(this.path + "/static/urldata/" + this.hostname + ".json", JSON.stringify(this.json, 4, 4)));
      this.jsonstring = JSON.stringify(this.json);
      (yield this.genFiles());
      return (yield this.udata.init(this.json, this.forms));
    };

    UrlData.prototype.getFFile = function(fname) {
      var ref;
      return (ref = this.files[fname]) != null ? ref : {};
    };

    UrlData.prototype.getFFiles = function(fname) {
      return this.files;
    };

    UrlData.prototype.getJsonString = function() {
      return this.jsonstring;
    };

    UrlData.prototype.genFiles = function*() {
      var file, fname, ref, results;
      for (fname in this.forms) {
        this.files[fname] = {
          src: coffee._compileFile(this.path + "/runtime/urldata/" + fname + ".coffee")
        };
      }
      ref = this.files;
      results = [];
      for (fname in ref) {
        file = ref[fname];
        this.files[fname].src = "(function(){" + ((yield file.src)) + "}).call(_FEEL_that);";
        results.push(this.files[fname].hash = _shash(this.files[fname].src));
      }
      return results;
    };

    UrlData.prototype.readConsts = function() {
      return Q.async((function(_this) {
        return function*() {
          var base, file, files, i, readed, w8for;
          if (global.Feel == null) {
            global.Feel = {};
          }
          if ((base = global.Feel)["const"] == null) {
            base["const"] = function(name) {
              return _this["const"][name];
            };
          }
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
          return (yield Q.all(w8for));
        };
      })(this))();
    };

    UrlData.prototype.next = function*(str) {
      var base, make, n, w;
      make = false;
      if (str == null) {
        make = true;
      }
      if ((base = this.json).last == null) {
        base.last = '';
      }
      if (str == null) {
        str = this.json.last;
      }
      if (str === '') {
        str = 'q';
        if (make) {
          this.json.last = str;
        }
        return str;
      }
      w = str.substr(-1);
      w = words[kwords[w] + 1];
      if (w) {
        str = (str.substr(0, str.length - 1)) + w;
        if (make) {
          this.json.last = str;
        }
        return str;
      }
      n = (yield this.next(str.substr(0, str.length - 1)));
      n += 'q';
      if (make) {
        this.json.last = n;
      }
      return n;
    };

    UrlData.prototype.d2u = function() {
      var ref;
      return (ref = this.udata).d2u.apply(ref, arguments);
    };

    UrlData.prototype.u2d = function() {
      var ref;
      return (ref = this.udata).u2d.apply(ref, arguments);
    };

    UrlData.prototype.d2o = function() {
      var ref;
      return (ref = this.udata).d2o.apply(ref, arguments);
    };

    UrlData.prototype.filter = function*(obj, field, value) {
      var key, ref, ref1, ref2, ret, string, val;
      if (value == null) {
        value = true;
      }
      string = false;
      if (typeof obj === 'string') {
        obj = (yield this.toObject(obj));
        string = true;
      }
      ret = {};
      for (key in obj) {
        val = obj[key];
        if (((ref = this.json) != null ? (ref1 = ref.shorts) != null ? (ref2 = ref1[key]) != null ? ref2[field] : void 0 : void 0 : void 0) === value) {
          ret[key] = val;
        }
      }
      if (string) {
        return this.objectTo(ret);
      }
      return ret;
    };

    UrlData.prototype.objectTo = function(obj) {
      var j, key, len, r, ret, str, val;
      if (!(obj && typeof obj === 'object')) {
        obj = {};
      }
      ret = [];
      for (key in obj) {
        val = obj[key];
        ret.push([key, val]);
      }
      ret.sort(function(a, b) {
        return (a != null ? a[0] : void 0) < (b != null ? b[0] : void 0);
      });
      str = '';
      for (j = 0, len = ret.length; j < len; j++) {
        r = ret[j];
        if (!r[0]) {
          continue;
        }
        if (str) {
          str += '&';
        }
        str += r[0];
        if (r[1] != null) {
          str += "=" + r[1];
        }
      }
      return str;
    };

    UrlData.prototype.toObject = function(url) {
      var j, len, ref, ref1, ret, u;
      if (typeof url !== 'string') {
        url = '';
      }
      url = (ref = url != null ? (ref1 = url.match(/^[^\?]*\??(.*)$/)) != null ? ref1[1] : void 0 : void 0) != null ? ref : '';
      url = url.split('&');
      ret = {};
      for (j = 0, len = url.length; j < len; j++) {
        u = url[j];
        u = u != null ? typeof u.split === "function" ? u.split('=' != null ? '=' : []) : void 0 : void 0;
        if (u[0] != null) {
          ret[u[0]] = u[1];
        }
      }
      return ret;
    };

    UrlData.prototype.filterHash = function*(o, field) {
      var ref, url;
      if (o == null) {
        o = {};
      }
      if (field == null) {
        field = 'filter';
      }
      if (typeof o === 'object') {
        url = (yield this.d2u(o));
      } else {
        url = o;
      }
      return (ref = (yield this.filter("blablabla?" + url, field))) != null ? ref : '';
    };

    return UrlData;

  })();

  module.exports = UrlData;

}).call(this);
