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
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          check_out_the_areas: data.area_tags
        }
      }, {
        upsert: true
      }));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
