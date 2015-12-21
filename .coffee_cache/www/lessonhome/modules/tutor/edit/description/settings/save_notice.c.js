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
          phone_call: {
            description: data.callback_comment
          },
          settings: {
            new_orders: data.new_orders,
            get_notifications: data.get_notifications,
            call_operator_possibility: data.call_operator_possibility
          }
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
