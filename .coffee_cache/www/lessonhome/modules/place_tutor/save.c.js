(function() {
  var arr;

  arr = ["country", "city", "area", "street", "house", "building", "flat", "metro"];

  this.handler = (function(_this) {
    return function*($, data) {
      var boo, db, el, i, len, update;
      console.log(data);
      if (!$.user.tutor) {
        return {
          status: "failed",
          errs: ["access_failed"]
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
      if (boo) {
        db = (yield $.db.get('persons'));
        (yield _invoke(db, 'update', {
          account: $.user.id
        }, {
          $set: update
        }, {
          upsert: true
        }));
        (yield $.form.flush('*', $.req, $.res));
      }
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
