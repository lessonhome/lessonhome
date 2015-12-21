(function() {
  var arr, check;

  arr = ["country", "city"];

  check = require("./check");

  this.handler = (function(_this) {
    return function*($, data, quiet) {
      var boo, db, el, errs, i, len, update;
      console.log(data);
      errs = [];
      if (!$.user.tutor) {
        return {
          status: 'failed',
          errs: []
        };
      }
      if (errs.length) {
        return {
          status: 'failed',
          errs: errs
        };
      }
      update = {};
      boo = false;
      for (i = 0, len = arr.length; i < len; i++) {
        el = arr[i];
        if ((data != null ? data[el] : void 0) != null) {
          update["location." + el] = data[el];
          boo = true;
        }
      }
      db = (yield $.db.get('persons'));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: update
      }, {
        upsert: true
      }));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          phone: [data.mobile_phone, data.extra_phone],
          email: [data.post],
          social_networks: {
            skype: [data.skype]
          }
        }
      }, {
        upsert: true
      }));
      if (!quiet) {
        (yield $.status('tutor_prereg_2', true));
      }
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
