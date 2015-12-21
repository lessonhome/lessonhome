(function() {
  this.handler = (function(_this) {
    return function*($, data) {
      var arr, base, db, errs, lastBid, lesson_price, pupil;
      errs = [];
      if (errs.length) {
        return {
          status: 'failed',
          errs: errs
        };
      }
      lesson_price = [];
      lesson_price.push(data.price_slider_bids.left);
      lesson_price.push(data.price_slider_bids.right);
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
      lastBid.status = data.pupil_status;
      if (lastBid.subjects == null) {
        lastBid.subjects = {};
      }
      if ((base = lastBid.subjects)[0] == null) {
        base[0] = {};
      }
      lastBid.subjects[0].course = data.course;
      lastBid.subjects[0].knowledge = data.knowledge_level;
      lastBid.subjects[0].lesson_price = lesson_price;
      lastBid.subjects[0].goal = data.goal;
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: pupil
      }, {
        upsert: true
      }));
      (yield $.status('fast_bid', 3));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
