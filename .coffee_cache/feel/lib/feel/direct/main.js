(function() {
  var Direct,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Direct = (function() {
    function Direct() {
      this.init = bind(this.init, this);
      this.call = bind(this.call, this);
      $W(this);
    }

    Direct.prototype.call = function*(method, data) {
      var e, error;
      if (data == null) {
        data = {};
      }
      try {
        return (yield Q.ninvoke(this.yd, 'post', 'json/v5/ads/', {
          method: method,
          params: data,
          client_id: '2764ed9d6b6e4b1d8a7441afa5eaec3b',
          client_secret: '7208b7c5f6b94e4fa5e03835cd5a6152'
        }));
      } catch (error) {
        e = error;
        console.error(e);
        return {};
      }
    };

    Direct.prototype.init = function*() {
      this.yd = require('request-json').createClient('https://api.direct.yandex.com/');
      this.yd.headers['Authorization'] = 'Bearer 503e2b7df23442b9ba78765a38943f34';
      return console.log(((yield this.call('GetVersion'))).body);
    };

    return Direct;

  })();

  module.exports = Direct;

}).call(this);
