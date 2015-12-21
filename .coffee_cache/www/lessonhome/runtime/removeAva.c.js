(function() {
  this.handler = (function(_this) {
    return function*($) {
      var accounts, ava, avatars, db, ref, rows;
      db = (yield $.db.get('persons'));
      rows = (yield _invoke(db.find({
        account: $.user.id
      }, {
        ava: 1
      }), 'toArray'));
      accounts = (yield _invoke(db.find({
        account: $.user.id
      }), 'toArray'));
      avatars = accounts[0].avatar;
      console.log('ava'.yellow, rows != null ? (ref = rows[0]) != null ? ref.ava : void 0 : void 0);
      if (avatars != null) {
        ava = avatars.pop();
      }
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          avatar: avatars
        }
      }, {
        upsert: true
      }));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success',
        removed: ava
      };
    };
  })(this);

}).call(this);
