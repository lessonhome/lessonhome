(function() {
  this.handler = (function(_this) {
    return function*($) {
      var arr, db, lastBid, pupil;
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
      lastBid.complited = true;
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: pupil
      }, {
        upsert: true
      }));
      (yield $.status('fast_bid', 5));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
