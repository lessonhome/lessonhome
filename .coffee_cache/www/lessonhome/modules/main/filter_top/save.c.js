(function() {
  this.handler = (function(_this) {
    return function*($, data) {
      var arr, base, base1, db, lastBid, pupil;
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
      if (lastBid.subjects == null) {
        lastBid.subjects = {};
      }
      if ((base = lastBid.subjects)[0] == null) {
        base[0] = {};
      }
      if (data.subject != null) {
        lastBid.subjects[0].subject = data.subject;
      }
      if (data.tutor_status != null) {
        if ((base1 = lastBid.subjects[0]).requirements_for_tutor == null) {
          base1.requirements_for_tutor = {};
        }
        lastBid.subjects[0].requirements_for_tutor.status = data.tutor_status;
      }
      if (data.place != null) {
        lastBid.subjects[0].place = data.place;
      }
      if (data.lesson_price != null) {
        lastBid.subjects[0].lesson_price = data.lesson_price;
      }
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: pupil
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
