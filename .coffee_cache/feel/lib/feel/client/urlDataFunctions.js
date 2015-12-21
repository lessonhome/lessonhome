(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.UrlDataFunctions = (function() {
    function UrlDataFunctions() {
      this.u2d = bind(this.u2d, this);
      this.d2u = bind(this.d2u, this);
      this.d2o = bind(this.d2o, this);
      this.init = bind(this.init, this);
      $W(this);
    }

    UrlDataFunctions.prototype.init = function(json, forms) {
      this.json = json;
      this.forms = forms;
    };

    UrlDataFunctions.prototype.d2o = function*(fname, data) {
      var def, e, error, field, foo, form, key, m, ref, ref1, ret, s, v;
      form = this.forms[fname];
      if ((form != null ? form.D2U : void 0) == null) {
        throw new Error("bad urlform " + fname);
      }
      ret = [];
      ref = form.D2U;
      for (key in ref) {
        foo = ref[key];
        if (!(m = key.match(/^\$(.*)$/))) {
          continue;
        }
        field = (yield foo(data));
        field.key = m[1];
        field.fname = fname;
        switch (field.type) {
          case 'int':
            field.value = +field.value;
            if (!(field.value || (field.value === 0))) {
              continue;
            }
            field.value = Math.floor(field.value);
            if (field.value === field["default"]) {
              continue;
            }
            break;
          case 'bool':
            field.value = field.value === true;
            def = field["default"];
            def = def === true;
            if (field.value === def) {
              continue;
            }
            field.value = true;
            break;
          case 'string':
            if (!field.value) {
              continue;
            }
            field.value = '' + field.value;
            if (typeof field.value !== 'string') {
              continue;
            }
            if (field.value === field["default"]) {
              continue;
            }
            field.value = encodeURIComponent(field.value);
            break;
          case 'string[]':
            if (!(field.value && (typeof field.value === 'object'))) {
              continue;
            }
            s = '';
            ref1 = field.value;
            for (key in ref1) {
              v = ref1[key];
              if (s) {
                s += '~';
              }
              s += '' + v;
            }
            field.value = encodeURIComponent(s);
            if (field.value === field["default"]) {
              continue;
            }
            break;
          case 'obj':
            if (field.value == null) {
              continue;
            }
            try {
              field.value = encodeURIComponent(JSON.stringify(field.value));
              def = encodeURIComponent(JSON.stringify(field.def));
            } catch (error) {
              e = error;
              continue;
            }
            if (!field.value) {
              continue;
            }
            if (field.value === def) {
              continue;
            }
            break;
          default:
            throw new Error("wrong type in field " + field.key + " in urlform " + fname);
        }
        ret.push(field);
      }
      return ret;
    };

    UrlDataFunctions.prototype.d2u = function*(fname, data) {
      var f, i, key, len, o, obj, ref, ref1, ret, url;
      if (!(fname && ((typeof data === 'object') || (typeof fname === 'object')))) {
        return "";
      }
      if (data) {
        o = {};
        o[fname] = data;
        data = o;
      } else {
        data = fname;
      }
      ret = [];
      for (fname in data) {
        obj = data[fname];
        ret = ret.concat((yield this.d2o(fname, obj)));
      }
      ret.sort(function(a, b) {
        return a.key < b.key;
      });
      url = '';
      for (i = 0, len = ret.length; i < len; i++) {
        f = ret[i];
        if (url) {
          url += '&';
        }
        key = (ref = this.json.forms) != null ? (ref1 = ref[f.fname]) != null ? ref1[f.key] : void 0 : void 0;
        if (!key) {
          throw new Error("bad field " + f.key + ":" + key + " in form " + f.fname);
        }
        url += key;
        if (f.value !== true) {
          url += '=' + f.value;
        }
      }
      return url;
    };

    UrlDataFunctions.prototype.u2d = function*(url) {
      var data, def, e, error, error1, error2, f, ffields, fform, field, fields, fname, foo, form, i, key, len, m, name, o, obj, ref, ref1, ref10, ref11, ref12, ref13, ref14, ref15, ref16, ref17, ref18, ref19, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, type, udata, value;
      if (!(url && (typeof url === 'string'))) {
        url = "";
      }
      url = url.replace(/^.*\?/gmi, '');
      fields = url.split('&');
      udata = {};
      ffields = {};
      for (i = 0, len = fields.length; i < len; i++) {
        f = fields[i];
        f = f.split('=');
        field = (ref = this.json.shorts) != null ? ref[f != null ? f[0] : void 0] : void 0;
        if (!(field != null ? field.field : void 0)) {
          continue;
        }
        if (((ref1 = this.forms) != null ? (ref2 = ref1[field != null ? field.form : void 0]) != null ? (ref3 = ref2.D2U) != null ? ref3['$' + (field != null ? field.field : void 0)] : void 0 : void 0 : void 0) == null) {
          continue;
        }
        value = (ref4 = f[1]) != null ? ref4 : true;
        if (ffields[name = field != null ? field.form : void 0] == null) {
          ffields[name] = {};
        }
        ffields[field != null ? field.form : void 0][field != null ? field.field : void 0] = value;
      }
      for (fname in this.forms) {
        for (key in this.forms[fname].D2U) {
          if (!(m = key.match(/^\$(.*)$/))) {
            continue;
          }
          if (!m[1]) {
            continue;
          }
          field = m[1];
          o = (ref5 = this.json.shorts) != null ? ref5[(ref6 = this.json) != null ? (ref7 = ref6.forms) != null ? (ref8 = ref7[fname]) != null ? ref8[field] : void 0 : void 0 : void 0] : void 0;
          if (o["default"] == null) {
            continue;
          }
          if ((ffields != null ? (ref9 = ffields[fname]) != null ? ref9[field] : void 0 : void 0) == null) {
            if (ffields[fname] == null) {
              ffields[fname] = {};
            }
            if (o.type === 'bool') {
              ffields[fname][field] = false;
            } else {
              ffields[fname][field] = o["default"];
            }
          }
        }
      }
      for (fname in ffields) {
        fform = ffields[fname];
        for (field in fform) {
          value = fform[field];
          f = [(ref10 = this.json) != null ? (ref11 = ref10.forms) != null ? (ref12 = ref11[fname]) != null ? ref12[field] : void 0 : void 0 : void 0, value];
          field = (ref13 = this.json.shorts) != null ? ref13[f != null ? f[0] : void 0] : void 0;
          if (!(field != null ? field.field : void 0)) {
            continue;
          }
          type = (ref14 = field.type) != null ? ref14 : 'string';
          form = field.form;
          def = field["default"];
          field = field.field;
          if (((ref15 = this.forms) != null ? (ref16 = ref15[form]) != null ? (ref17 = ref16.D2U) != null ? ref17['$' + field] : void 0 : void 0 : void 0) == null) {
            continue;
          }
          value = (ref18 = f[1]) != null ? ref18 : true;
          switch (type) {
            case 'int':
              value = +value;
              if (!(value === 0 || value)) {
                value = def;
              }
              break;
            case 'string':
              try {
                value = decodeURIComponent(value);
                value = '' + value;
              } catch (error) {
                e = error;
                value = def;
              }
              if (typeof value !== 'string') {
                value = def;
              }
              if (typeof value !== 'string') {
                value = '';
              }
              break;
            case 'string[]':
              try {
                value = decodeURIComponent(value);
                value = value.split('~');
                if ((value != null ? value[0] : void 0) === '') {
                  value.shift();
                }
              } catch (error1) {
                e = error1;
                value = [];
              }
              if (!(value && typeof value === 'object')) {
                value = def;
              }
              if (typeof value !== 'object') {
                value = [];
              }
              break;
            case 'obj':
              try {
                value = JSON.parse(decodeURIComponent(value));
              } catch (error2) {
                e = error2;
                value = def;
              }
              if (typeof value !== 'object') {
                value = def;
              }
              if (typeof value !== 'object') {
                value = void 0;
              }
              break;
            case 'bool':
              value = value === true;
              if (def === true) {
                value = !value;
              }
              break;
            default:
              continue;
          }
          if (udata[form] == null) {
            udata[form] = {};
          }
          udata[form][field] = value;
        }
      }
      data = {};
      for (fname in udata) {
        obj = udata[fname];
        if (data[fname] == null) {
          data[fname] = {};
        }
        ref19 = this.forms[fname].U2D;
        for (key in ref19) {
          foo = ref19[key];
          if (!(m = key.match(/^\$(.*)$/))) {
            continue;
          }
          if (!m[1]) {
            continue;
          }
          data[fname][m[1]] = (yield foo(obj));
        }
      }
      return data;
    };

    return UrlDataFunctions;

  })();

}).call(this);
