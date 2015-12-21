(function() {
  this.check = (function(_this) {
    return function(login, pass, check_box) {
      var login_pattern;
      login_pattern = /^[a-zA-Z](.[a-zA-Z0-9_-]*)$/;
      if (login.length === 0) {
        return {
          err: "empty_login_form"
        };
      }
      if (login.length < 7) {
        return {
          err: "bad_login"
        };
      }
      if (!_this.checkEmail(login)) {
        if (!(login = _this.checkPhone(login))) {
          return {
            err: "bad_login"
          };
        }
      }
      if (pass.length === 0) {
        return {
          err: "empty_password_form"
        };
      }
      if (pass.length < 5) {
        return {
          err: "short_password"
        };
      }
      if (!check_box) {
        return {
          err: "select_agree_checkbox"
        };
      }
      return {
        login: login
      };
    };
  })(this);

  this.checkEmail = (function(_this) {
    return function(login) {
      var re;
      re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i;
      return re.test(login);
    };
  })(this);

  this.checkPhone = (function(_this) {
    return function(login) {
      var p;
      if (!login.match(/^[-\+\d\(\)\s]+$/)) {
        return null;
      }
      p = login.replace(/\D/g, "");
      if (p.length > 11) {
        return null;
      }
      if (p.length === 11) {
        if (p.match(/^[7|8]/)) {
          p = p.substr(1);
        } else {
          return null;
        }
      }
      if (p.length === 7 || p.length === 10) {
        return p;
      }
      return null;
    };
  })(this);

}).call(this);
