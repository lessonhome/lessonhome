(function() {
  var Redis, _Redis, _Redlock,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _Redis = require('redis');

  _Redlock = require('redlock');

  Redis = (function() {
    function Redis() {
      this.getLock = bind(this.getLock, this);
      this.get = bind(this.get, this);
      this.connect = bind(this.connect, this);
      this.close = bind(this.close, this);
      this.init = bind(this.init, this);
      $W(this);
    }

    Redis.prototype.init = function() {};

    Redis.prototype.close = function() {};

    Redis.prototype.connect = function() {
      return this.redlock != null ? this.redlock : this.redlock = new _Redlock([this.redis], {
        driftFactor: 0.01,
        retryCount: 3,
        retryDelay: 200
      });
    };

    Redis.prototype.get = function() {
      return _Redis.createClient();
    };

    Redis.prototype.getLock = function() {
      this.connect();
      return this.redlock;
    };

    return Redis;

  })();

  module.exports = Redis;

}).call(this);
