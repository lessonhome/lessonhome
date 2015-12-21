(function() {
  this.handler = (function(_this) {
    return function*($, data, quiet) {
      var db, errs, ref, ref1, ref2;
      if (quiet == null) {
        quiet = false;
      }
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
      if ((data != null ? data.work : void 0) == null) {
        return (ref = (ref1 = (yield _invoke(db.find({
          account: $.user.id
        }, {
          work: 1
        }), 'toArray'))) != null ? (ref2 = ref1[0]) != null ? ref2.work : void 0 : void 0) != null ? ref : [];
      }
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          work: data.work
        }
      }, {
        upsert: true
      }));
      if (quiet) {
        (yield $.form.flush('*', $.req, $.res));
        return {
          status: 'success'
        };
      }
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
