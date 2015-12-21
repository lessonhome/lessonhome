(function() {
  var Form,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Form = (function() {
    function Form() {
      this.flush = bind(this.flush, this);
      this.loadForm = bind(this.loadForm, this);
      this.get = bind(this.get, this);
      this.init = bind(this.init, this);
      Wrap(this);
      this.form = {};
    }

    Form.prototype.init = function*() {
      var f, formnames, i, len;
      this.formnames = [];
      formnames = (yield _readdir("www/lessonhome/runtime/forms"));
      for (i = 0, len = formnames.length; i < len; i++) {
        f = formnames[i];
        if (!f.match(/\./)) {
          this.formnames.push(f);
        }
      }
      this.service = (yield Main.service('data'));
      return this.register = (yield Main.service('register'));
    };

    Form.prototype.get = function*(fname, req, res, fields) {
      var find;
      if (!this.form[fname]) {
        (yield this.loadForm(fname));
      }
      find = (yield this.form[fname].find.get(req, res));
      return this.service.get(fname, find, fields);
    };

    Form.prototype.loadForm = function*(fname) {
      var data, f, files, form, i, len;
      data = (yield _readdir("www/lessonhome/runtime/forms/" + fname));
      form = {};
      files = {};
      for (i = 0, len = data.length; i < len; i++) {
        f = data[i];
        files[f] = true;
      }
      if (files['find.coffee']) {
        form.find = require(process.cwd() + ("/www/lessonhome/runtime/forms/" + fname + "/find"));
      } else {
        form.find = require(process.cwd() + "/www/lessonhome/runtime/forms/find");
      }
      form.find = Wrap(new form.find);
      return this.form[fname] = form;
    };

    Form.prototype.flush = function*(data, req, res) {
      var d, fn, i, len, qs;
      (yield this.register.reload(req.user.id));
      if (data === '*') {
        data = this.formnames;
      }
      if ((typeof data === 'string') || (!(data != null ? data.length : void 0) > 0)) {
        data = [data];
      }
      qs = [];
      fn = (function(_this) {
        return function(d) {
          return qs.push(Q.async(function*() {
            var fl;
            if (typeof d === 'string') {
              if (!_this.form[d]) {
                (yield _this.loadForm(d));
              }
              fl = (yield _this.form[d].find.get(req, res));
              return _this.service.flush(fl, d);
            }
            return _this.service.flush(d);
          })());
        };
      })(this);
      for (i = 0, len = data.length; i < len; i++) {
        d = data[i];
        fn(d);
      }
      return (yield Q.all(qs));
    };

    return Form;

  })();

  module.exports = Form;

}).call(this);
