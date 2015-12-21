(function() {
  var Data,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Data = (function() {
    function Data() {
      this.loadForm = bind(this.loadForm, this);
      this.flush = bind(this.flush, this);
      this.returnData = bind(this.returnData, this);
      this.findtohash = bind(this.findtohash, this);
      this.loadDataMulti = bind(this.loadDataMulti, this);
      this.loadDataSingle = bind(this.loadDataSingle, this);
      this.loadData = bind(this.loadData, this);
      this.get = bind(this.get, this);
      this.init = bind(this.init, this);
      Wrap(this);
      this.form = {};
      this.data = {};
      this.flushs = {};
    }

    Data.prototype.init = function*() {
      return this.db = (yield Main.service('db'));
    };

    Data.prototype.get = function*(fname, find, fields) {
      var data, fhash, hash;
      fhash = (yield this.findtohash(find));
      hash = _shash(fname + fhash);
      if (this.data[hash]) {
        return this.returnData(fname, find, fields, hash, this.data[hash]);
      }
      data = (yield this.loadData(fname, find, fields, hash, fhash));
      return this.returnData(fname, find, fields, hash, data);
    };

    Data.prototype.loadData = function*(fname, find, fields, hash, fhash) {
      var $, base, data, obj;
      if (this.form[fname] == null) {
        (yield this.loadForm(fname));
      }
      $ = {};
      $.find = find;
      $.form = this.form[fname];
      $.db = this.db;
      obj = (yield this.form[fname].dbread.read($));
      if (this.form[fname].multi) {
        data = (yield this.loadDataMulti(obj, $, fname));
      } else {
        data = (yield this.loadDataSingle(obj, $, fname));
      }
      data.form = this.form[fname];
      data.hash = hash;
      this.data[hash] = data;
      if ((base = this.flushs)[fhash] == null) {
        base[fhash] = [];
      }
      this.flushs[fhash].push([this.data, hash]);
      return data;
    };

    Data.prototype.loadDataSingle = function*(obj, $, fname) {
      var data, key, m, qs, ref, ref1, ref2, ref3, val;
      data = {};
      data.data = obj;
      data.fdata = {};
      ref = data.data;
      for (key in ref) {
        val = ref[key];
        data.fdata[key] = val;
      }
      qs = [];
      if ($.form.b2f != null) {
        ref1 = $.form.b2f;
        for (key in ref1) {
          val = ref1[key];
          if ((m = key.match(/^\$(.*)$/)) && (typeof val === 'function')) {
            (function(_this) {
              return (function(m, key) {
                return qs.push($.form.b2f[key](data.data).then(function(v) {
                  data.fdata[m[1]] = v;
                }));
              });
            })(this)(m, key);
          }
        }
      }
      (yield Q.all(qs));
      data.vdata = {};
      ref2 = data.fdata;
      for (key in ref2) {
        val = ref2[key];
        data.vdata[key] = val;
      }
      qs = [];
      if ($.form.f2v != null) {
        ref3 = $.form.f2v;
        for (key in ref3) {
          val = ref3[key];
          if ((m = key.match(/^\$(.*)$/)) && (typeof val === 'function')) {
            (function(_this) {
              return (function(m, key) {
                return qs.push($.form.f2v[key](data.fdata).then(function(v) {
                  data.vdata[m[1]] = v;
                }));
              });
            })(this)(m, key);
          }
        }
      }
      (yield Q.all(qs));
      return data;
    };

    Data.prototype.loadDataMulti = function*(obj, $, fname) {
      var data, dt, fdt, i, index, j, key, len, len1, m, qs, ref, ref1, ref2, ref3, ref4, ref5, val, vdt;
      data = {};
      data.data = obj;
      data.fdata = [];
      qs = [];
      ref = data.data;
      for (index = i = 0, len = ref.length; i < len; index = ++i) {
        dt = ref[index];
        fdt = {};
        data.fdata.push(fdt);
        for (key in dt) {
          val = dt[key];
          fdt[key] = val;
        }
        if ($.form.b2f != null) {
          ref1 = $.form.b2f;
          for (key in ref1) {
            val = ref1[key];
            if ((m = key.match(/^\$(.*)$/)) && (typeof val === 'function')) {
              (function(_this) {
                return (function(m, key, fdt, dt, index) {
                  return qs.push($.form.b2f[key](dt, data.data, index).then(function(v) {
                    fdt[m[1]] = v;
                  }));
                });
              })(this)(m, key, fdt, dt, index);
            }
          }
        }
      }
      (yield Q.all(qs));
      qs = [];
      if ($.form.mb2f != null) {
        ref2 = $.form.mb2f;
        for (key in ref2) {
          val = ref2[key];
          if ((m = key.match(/^\$(.*)$/)) && (typeof val === 'function')) {
            (function(_this) {
              return (function(m, key) {
                return qs.push($.form.mb2f[key](data.data, data.fdata).then(function(v) {
                  if (v != null) {
                    data.fdata[m[1]] = v;
                  }
                }));
              });
            })(this)(m, key);
          }
        }
      }
      (yield Q.all(qs));
      data.vdata = [];
      qs = [];
      ref3 = data.fdata;
      for (index = j = 0, len1 = ref3.length; j < len1; index = ++j) {
        fdt = ref3[index];
        vdt = {};
        data.vdata.push(vdt);
        for (key in fdt) {
          val = fdt[key];
          vdt[key] = val;
        }
        if ($.form.f2v != null) {
          ref4 = $.form.f2v;
          for (key in ref4) {
            val = ref4[key];
            if ((m = key.match(/^\$(.*)$/)) && (typeof val === 'function')) {
              (function(_this) {
                return (function(m, key, vdt, fdt, index) {
                  return qs.push($.form.f2v[key](fdt, data.fdata, index).then(function(v) {
                    vdt[m[1]] = v;
                  }));
                });
              })(this)(m, key, vdt, fdt, index);
            }
          }
        }
      }
      (yield Q.all(qs));
      qs = [];
      if ($.form.mf2v != null) {
        ref5 = $.form.mf2v;
        for (key in ref5) {
          val = ref5[key];
          if ((m = key.match(/^\$(.*)$/)) && (typeof val === 'function')) {
            (function(_this) {
              return (function(m, key) {
                return qs.push($.form.mf2v[key](data.fdata, data.vdata).then(function(v) {
                  if (v != null) {
                    data.vdata[m[1]] = v;
                  }
                }));
              });
            })(this)(m, key);
          }
        }
      }
      (yield Q.all(qs));
      return data;
    };

    Data.prototype.findtohash = function(find) {
      var i, k, keys, len, o;
      keys = Object.keys(find).sort();
      o = {};
      for (i = 0, len = keys.length; i < len; i++) {
        k = keys[i];
        o[k] = find[k];
      }
      return _shash(JSON.stringify(o));
    };

    Data.prototype.returnData = function(fname, find, fields, hash, data) {
      var f, i, len, ret;
      if (data == null) {
        data = this.data[hash];
      }
      if (fields == null) {
        fields = Object.keys(data.vdata);
      }
      ret = {};
      for (i = 0, len = fields.length; i < len; i++) {
        f = fields[i];
        ret[f] = data.vdata[f];
      }
      return ret;
    };

    Data.prototype.flush = function*(find, dbname) {
      var fhash, i, len, o, ref, ref1;
      fhash = (yield this.findtohash(find));
      if (((ref = this.flushs) != null ? ref[fhash] : void 0) != null) {
        ref1 = this.flushs[fhash];
        for (i = 0, len = ref1.length; i < len; i++) {
          o = ref1[i];
          delete o[0][o[1]];
        }
      }
      return delete this.flushs[fhash];
    };

    Data.prototype.loadForm = function*(fname) {
      var arr, base, bf, bname, f, files, form, i, j, len, len1, m, readed, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9;
      form = {};
      form.name = fname;
      form.dir = "www/lessonhome/runtime/forms/" + fname;
      readed = (yield _readdir(form.dir));
      files = {};
      for (i = 0, len = readed.length; i < len; i++) {
        f = readed[i];
        if (m = f.match(/^(.*)\.coffee$/)) {
          files[m[1]] = true;
        }
      }
      form.f = {};
      form.f.base = require(process.cwd() + ("/" + form.dir + "/base.coffee"));
      if (form != null ? (ref = form.f) != null ? (ref1 = ref.base) != null ? ref1.multi : void 0 : void 0 : void 0) {
        form.multi = true;
      }
      if (files['db.read']) {
        form.f['db.read'] = require(process.cwd() + ("/" + form.dir + "/db.read.coffee"));
      } else if (!form.multi) {
        form.f['db.read'] = require(process.cwd() + "/www/lessonhome/runtime/forms/db.read.coffee");
      } else {
        form.f['db.read'] = require(process.cwd() + "/www/lessonhome/runtime/forms/db.multiread.coffee");
      }
      if (files.convert) {
        form.f.convert = require(process.cwd() + ("/" + form.dir + "/convert.coffee"));
        if (((ref2 = form.f.convert) != null ? ref2.F2V : void 0) != null) {
          form.f2v = Wrap(new form.f.convert.F2V);
        }
        if (((ref3 = form.f.convert) != null ? ref3.V2F : void 0) != null) {
          form.v2f = Wrap(new form.f.convert.V2F);
        }
        if (((ref4 = form.f.convert) != null ? ref4.F2B : void 0) != null) {
          form.F2B = Wrap(new form.f.convert.F2B);
        }
        if (((ref5 = form.f.convert) != null ? ref5.B2F : void 0) != null) {
          form.b2f = Wrap(new form.f.convert.B2F);
        }
        if (((ref6 = form.f.convert) != null ? ref6.MF2V : void 0) != null) {
          form.mf2v = Wrap(new form.f.convert.MF2V);
        }
        if (((ref7 = form.f.convert) != null ? ref7.MB2F : void 0) != null) {
          form.mb2f = Wrap(new form.f.convert.MB2F);
        }
      }
      form.dbread = Wrap(new form.f['db.read']);
      form.fields = [];
      form.bfields = {};
      form.ffields = {};
      ref8 = form.f.base;
      for (bname in ref8) {
        arr = ref8[bname];
        if ((base = form.bfields)[bname] == null) {
          base[bname] = {};
        }
        for (j = 0, len1 = arr.length; j < len1; j++) {
          bf = arr[j];
          f = bf;
          if (typeof bf !== 'string') {
            f = Object.keys(bf)[0];
            bf = bf[f];
            ref9 = [bf, f], f = ref9[0], bf = ref9[1];
          }
          form.fields.push(f);
          form.bfields[bname][bf] = f;
          form.ffields[f] = [bf, bname];
        }
      }
      form.dbname = (function(_this) {
        return function(f) {
          return _this.form[fname].ffields[f][1];
        };
      })(this);
      form.toBName = (function(_this) {
        return function(f) {
          return _this.form[fname].ffields[f][0];
        };
      })(this);
      form.toFName = (function(_this) {
        return function(b, f) {
          return _this.form[fname].bfields[b][f];
        };
      })(this);
      return this.form[fname] = form;
    };

    return Data;

  })();

  module.exports = Data;

}).call(this);
