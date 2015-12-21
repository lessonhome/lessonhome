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
          reason: data.reason,
          slogan: data.slogan,
          about: data.about
        }
      }, {
        upsert: true
      }));
      db = (yield $.db.get('persons'));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          interests: [
            {
              description: data.interests
            }
          ]
        }
      }, {
        upsert: true
      }));
      (yield $.status('tutor_prereg_4', true));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
