(function() {
  this.handler = function*($, data) {
    var err, error, obj, ref;
    if (data != null ? (ref = data.password) != null ? typeof ref.match === "function" ? ref.match(/\%/) : void 0 : void 0 : void 0) {
      data.password = unescape(data.password);
    } else {
      data.password = _LZString.decompressFromBase64(data.password);
    }
    try {
      obj = (yield $.register.login($.user, $.session, data));
      $.cookie.set('session');
      $.cookie.set('session', obj.session.hash);
    } catch (error) {
      err = error;
      if (err.err == null) {
        err.err = 'internal_error';
      }
      return {
        status: 'failed',
        err: err.err
      };
    }
    (yield $.updateUser(obj.session.hash));
    (yield $.status('tutor', true));
    (yield $.form.flush('*', $.req, $.res));
    if ($.user.admin) {
      $.cookie.set('adminHash', (yield $.register.getAdminHash()));
      (yield $.register.bindAdmin(obj.session.hash));
    }
    return {
      status: 'success',
      session: obj.session.hash
    };
  };

}).call(this);
