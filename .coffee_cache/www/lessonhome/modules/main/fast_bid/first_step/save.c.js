(function() {
  var check;

  check = require("./check");

  this.handler = (function(_this) {
    return function*($, data) {
      var arr, base, base1, db, errs, lastBid, pupil;
      errs = check.check(data);
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
          first_name: data.name,
          email: [data.email]
        }
      }, {
        upsert: true
      }));
      db = (yield $.db.get('pupil'));
      arr = (yield _invoke(db.find({
        account: $.user.id
      }), 'toArray'));
      pupil = arr != null ? arr[0] : void 0;
      if (pupil == null) {
        pupil = {};
      }
      if (pupil.bids == null) {
        pupil.bids = [];
      }
      lastBid = pupil.bids[pupil.bids.length - 1];
      if ((lastBid != null ? lastBid.complited : void 0) !== false) {
        lastBid = {
          complited: false
        };
        pupil.bids.push(lastBid);
      }
      if (lastBid.phone_call == null) {
        lastBid.phone_call = {};
      }
      if ((base = lastBid.phone_call).phones == null) {
        base.phones = [data.phone];
      }
      lastBid.phone_call.phones[0] = data.phone;
      lastBid.phone_call.description = data.call_time;
      if (lastBid.subjects == null) {
        lastBid.subjects = {};
      }
      if ((base1 = lastBid.subjects)[0] == null) {
        base1[0] = {};
      }
      lastBid.subjects[0].subject = data.subject;
      lastBid.subjects[0].comments = data.comments;
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: pupil
      }, {
        upsert: true
      }));
      (yield $.status('fast_bid', 2));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
