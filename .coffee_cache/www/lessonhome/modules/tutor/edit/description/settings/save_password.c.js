(function() {
  this.handler = (function(_this) {
    return function*($, data) {
      var db, errs;
      console.log(data);
      errs = [];
      if (!$.user.tutor) {
        return;
      }
      if (errs.length) {
        return {
          status: 'failed',
          errs: errs
        };
      }
      db = (yield $.db.get('tutor'));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
