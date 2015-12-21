(function() {
  this.handler = function*($, data) {
    var err, error, obj, ref;
    if (data.getLogin) {
      return $.user.login;
    }
    if (data != null ? (ref = data.password) != null ? typeof ref.match === "function" ? ref.match(/\%/) : void 0 : void 0 : void 0) {
      data.password = unescape(data.password);
    } else {
      data.password = _LZString.decompressFromBase64(data.password);
    }
    if (data.login == null) {
      data.login = $.user.login;
    }
    try {
      obj = (yield $.register.loginUpdate($.user, $.session, data, $.user.admin === true));
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
    (yield $.updateUser());
    (yield $.form.flush('*', $.req, $.res));
    return {
      status: 'success',
      session: obj.session.hash
    };
  };

}).call(this);
