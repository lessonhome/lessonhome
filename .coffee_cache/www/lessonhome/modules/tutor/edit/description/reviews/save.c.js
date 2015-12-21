(function() {
  this.handler = (function(_this) {
    return function*($, data) {
      var db, errs, p, ref, ref1;
      if (!$.user.admin) {
        return;
      }
      db = (yield $.db.get('persons'));
      if ((data != null ? data.reviews : void 0) == null) {
        p = (yield _invoke(db.find({
          account: $.user.id
        }, {
          reviews: 1
        }), 'toArray'));
        return (ref = p != null ? (ref1 = p[0]) != null ? ref1.reviews : void 0 : void 0) != null ? ref : [];
      }
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          reviews: data.reviews
        }
      }, {
        upsert: true
      }));
      return {
        status: 'success'
      };
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
      db = (yield $.db.get('persons'));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          work: data.work
        }
      }, {
        upsert: true
      }));
      db = (yield $.db.get('tutor'));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          experience: data.experience,
          extra: [
            {
              type: 'text',
              text: data.extra_info
            }
          ]
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
