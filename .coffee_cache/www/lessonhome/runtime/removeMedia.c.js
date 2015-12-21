(function() {
  this.handler = (function(_this) {
    return function*($, data) {
      var db, persons, personsDb, photos, ref, ref1, set;
      db = (yield Main.service('db'));
      personsDb = (yield db.get('persons'));
      persons = (yield _invoke(personsDb.find({
        account: $.user.id
      }), 'toArray'));
      persons = persons[0];
      set = null;
      photos = null;
      switch (data.type) {
        case 'documents':
          set = {
            documents: photos = (ref = persons.documents) != null ? ref : []
          };
          break;
        default:
          set = {
            photos: photos = (ref1 = persons.photos) != null ? ref1 : []
          };
      }
      if (photos.indexOf(data.hash) !== -1) {
        photos.splice(photos.indexOf(data.hash), 1);
      }
      (yield _invoke(personsDb, 'update', {
        account: $.user.id
      }, {
        $set: set
      }, {
        upsert: true
      }));
      (yield $.updateUser());
      (yield $.form.flush('*', $.req, $.res));
      console.log('remove media', data);
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
