(function() {
  var check;

  check = require("./check");

  this.handler = (function(_this) {
    return function*($, data) {
      var db, errs;
      errs = check.check(data);
      if (errs.length) {
        return {
          status: 'failed',
          errs: errs
        };
      }
      db = (yield $.db.get('backcall'));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          name: data.your_name,
          phone: data.tel_number,
          comment: data.comments,
          type: data.type,
          account: $.user.id,
          time: new Date()
        }
      }, {
        upsert: true
      }));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
