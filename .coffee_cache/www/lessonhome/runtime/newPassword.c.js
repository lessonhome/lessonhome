(function() {
  this.handler = function*($, data) {
    var accounts, accountsDb, db, err, error, obj, qstring, ref, token, urldata;
    data.ref = $.req.headers.referer;
    if (data.check) {
      db = (yield Main.service('db'));
      urldata = (yield Main.service('urldata'));
      accountsDb = (yield db.get('accounts'));
      qstring = data.ref.replace(/.*\?/, '');
      token = (yield urldata.u2d(qstring));
      token = token.authToken.token;
      accounts = (yield _invoke(accountsDb.find({
        'authToken.token': token
      }), 'toArray'));
      if (!((accounts[0] != null) && accounts[0].valid > Date.now())) {
        return;
      }
    }
    if (data != null ? (ref = data.password) != null ? ref.match(/\%/) : void 0 : void 0) {
      data.password = unescape(data.password);
    } else {
      data.password = _LZString.decompressFromBase64(data.password);
    }
    try {
      obj = (yield $.register.newPassword($.user, data));
      if (obj.redirect) {
        return {
          status: 'redirect'
        };
      }
      if ((obj != null ? obj.session : void 0) != null) {
        $.cookie.set('session');
        $.cookie.set('session', obj.session.hash);
      }
    } catch (error) {
      err = error;
      console.log('err', err);
      if (err.err == null) {
        err.err = 'internal_error';
      }
      return {
        status: 'failed',
        err: err.err
      };
    }
    (yield $.updateUser());
    (yield $.status('tutor', true));
    (yield $.form.flush('*', $.req, $.res));
    if ((obj != null ? obj.session : void 0) != null) {
      return {
        status: 'success',
        session: obj.session.hash
      };
    } else {
      return {
        status: 'success'
      };
    }
  };

}).call(this);
