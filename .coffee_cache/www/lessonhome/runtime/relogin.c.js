(function() {
  this.handler = (function(_this) {
    return function*($, data) {
      var err, error, obj;
      if (!$.user.admin) {
        return;
      }
      try {
        obj = (yield $.register.relogin($.user, $.session, data));
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
      (yield $.updateUser());
      (yield $.status('tutor', true));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success',
        session: obj.session.hash
      };
    };
  })(this);

}).call(this);
