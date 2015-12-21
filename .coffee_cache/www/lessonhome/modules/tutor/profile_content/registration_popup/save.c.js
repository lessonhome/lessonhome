(function() {
  this.handler = (function(_this) {
    return function*($, progress) {
      var db;
      if (!$.user.tutor) {
        return;
      }
      db = (yield $.db.get('tutor'));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          registration_progress: ++progress
        }
      }, {
        upsert: true
      }));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };

      /*
      if not exist then exist then exist and = 1
      if 1<= preogress < 4 then inc
       */
    };
  })(this);

}).call(this);
