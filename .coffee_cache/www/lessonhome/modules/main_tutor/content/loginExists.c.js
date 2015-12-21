(function() {
  this.handler = (function(_this) {
    return function*($, login) {
      return (yield $.register.loginExists(login));
    };
  })(this);

}).call(this);
