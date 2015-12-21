(function() {
  this.handler = (function(_this) {
    return function*($, data) {
      var db;
      if (!$.user.admin) {
        return;
      }
      db = (yield $.db.get('persons'));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          comment: data
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
