(function() {
  this.handler = (function(_this) {
    return function*($, messages, sender) {
      var sms;
      if (!$.user.admin) {
        return;
      }
      sms = (yield Main.service('sms'));
      return (yield sms.send(messages, sender));
    };
  })(this);

}).call(this);
