(function() {
  this.handler = (function(_this) {
    return function*($, data) {
      var acc, avatars, personsDb, ref, ref1, ref2, result, uploaded, uploadedDb;
      result = {
        status: 'success'
      };
      personsDb = (yield $.db.get('persons'));
      uploadedDb = (yield $.db.get('uploaded'));
      acc = (yield _invoke(personsDb.find({
        account: $.user.id
      }, {
        avatar: 1
      }), 'toArray'));
      uploaded = (yield _invoke(uploadedDb.find({
        hash: data.id + 'high'
      }), 'toArray'));
      avatars = (ref = acc != null ? (ref1 = acc[0]) != null ? ref1.avatar : void 0 : void 0) != null ? ref : [];
      uploaded = (ref2 = uploaded != null ? uploaded[0] : void 0) != null ? ref2 : {};
      if (avatars.indexOf(data.id) !== -1) {
        avatars.splice(avatars.indexOf(data.id), 1);
      }
      avatars.push(data.id);
      result.newAva = {
        url: uploaded.url,
        height: uploaded.height,
        width: uploaded.width
      };
      (yield _invoke(personsDb, 'update', {
        account: $.user.id
      }, {
        $set: {
          avatar: avatars
        }
      }, {
        upsert: true
      }));
      (yield $.form.flush('*', $.req, $.res));
      return result;
    };
  })(this);

}).call(this);
