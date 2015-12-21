(function() {
  this.handler = (function(_this) {
    return function*($, name, data) {
      var db, find;
      find = {
        id: $.user.id,
        formname: name
      };
      db = (yield $.db.get('pupil-forms'));
      (yield _invoke(db, 'update', find, {
        $set: data
      }, {
        upsert: true
      }));
      return 'ok';
    };
  })(this);

}).call(this);
