(function() {
  var ServiceWrapper, blackList,
    slice = [].slice;

  blackList = require('../process/blackList');

  ServiceWrapper = (function() {
    function ServiceWrapper(__service) {
      var _emit, ee, key, ref, val;
      this.__service = __service;
      Wrap(this);
      ee = new EE;
      _emit = this.__service.emit;
      this.__service.emit = (function(_this) {
        return function() {
          var args;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          ee.emit.apply(ee, args);
          return _emit.apply(_this.__service, args);
        };
      })(this);
      ref = this.__service;
      for (key in ref) {
        val = ref[key];
        if (blackList(key)) {
          continue;
        }
        if (typeof val === 'function') {
          (function(_this) {
            return (function(key) {
              return _this[key] = function() {
                var ref1;
                return (ref1 = _this.__service)[key].apply(ref1, arguments);
              };
            });
          })(this)(key);
        } else {
          (function(_this) {
            return (function(key) {
              _this[key] = val;
              return Object.defineProperty(_this, key, {
                get: function() {
                  return _this.__service[key];
                },
                set: function(val) {
                  return _this.__service[key] = val;
                }
              });
            });
          })(this)(key);
        }
      }
      this.on = (function(_this) {
        return function() {
          var args;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return ee.on.apply(ee, args);
        };
      })(this);
      this.once = (function(_this) {
        return function() {
          var args;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return ee.once.apply(ee, args);
        };
      })(this);
      this.emit = (function(_this) {
        return function() {
          var args, ref1;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return (ref1 = _this.__service).emit.apply(ref1, args);
        };
      })(this);
    }

    return ServiceWrapper;

  })();

  module.exports = ServiceWrapper;

}).call(this);
