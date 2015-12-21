(function() {
  var check;

  check = require("./check");

  this.handler = (function(_this) {
    return function*($, data) {
      var db, educ, el, errors, i, len, ref, ref1, ref2, result;
      if (!$.user.tutor) {
        return;
      }
      db = (yield $.db.get('persons'));
      if ((data != null ? data.length : void 0) == null) {
        return (ref = (ref1 = (yield _invoke(db.find({
          account: $.user.id
        }, {
          education: 1
        }), 'toArray'))) != null ? (ref2 = ref1[0]) != null ? ref2.education : void 0 : void 0) != null ? ref : [];
      }
      errors = check.check(data);
      if (errors.correct === false) {
        return {
          status: 'failed',
          errs: errors
        };
      }
      result = [];
      for (i = 0, len = data.length; i < len; i++) {
        el = data[i];
        educ = {};
        educ['name'] = el['name'];
        educ['faculty'] = el['faculty'];
        educ['country'] = el['country'];
        educ['city'] = el['city'];
        educ['chair'] = el['chair'];
        educ['qualification'] = el['qualification'];
        educ['comment'] = el['comment'];
        educ['period'] = {};
        educ['period']['start'] = el['period']['start'];
        educ['period']['end'] = el['period']['end'];
        result.push(educ);
      }
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          education: result
        }
      }, {
        upsert: true
      }));
      (yield $.status('tutor_prereg_5', true));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
