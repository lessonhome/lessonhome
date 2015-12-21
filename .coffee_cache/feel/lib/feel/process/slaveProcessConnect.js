(function() {
  var SlaveProcessConnect, blackList,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  blackList = require('./blackList');

  SlaveProcessConnect = (function() {
    function SlaveProcessConnect(__conf) {
      this.__conf = __conf;
      this.__emit = bind(this.__emit, this);
      this.__on = bind(this.__on, this);
      this.__set = bind(this.__set, this);
      this.__get = bind(this.__get, this);
      this.__function = bind(this.__function, this);
      this.__init = bind(this.__init, this);
      if (typeof this.__conf === 'string') {
        this.__conf = {
          type: this.__conf
        };
      }
      this.__conf.processId = Main.conf.processId;
      Wrap(this);
    }

    SlaveProcessConnect.prototype.__init = function*() {
      var fn, fn1, func, i, j, len, len1, name, ref, ref1;
      this.__data = (yield Main.messanger.query('connect', this.__conf));
      ref = this.__data.functions;
      fn = (function(_this) {
        return function(func) {
          return _this[func] = function() {
            var args;
            args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
            return _this.__function.apply(_this, [func].concat(slice.call(args)));
          };
        };
      })(this);
      for (i = 0, len = ref.length; i < len; i++) {
        func = ref[i];
        if (blackList(func)) {
          continue;
        }
        fn(func);
      }
      ref1 = this.__data.vars;
      fn1 = (function(_this) {
        return function(name) {
          _this[name] = 'UNDEFINED';
          return Object.defineProperty(_this, name, {
            get: function() {
              return _this.__get(name);
            },
            set: function(val) {
              return _this.__set(name, val);
            }
          });
        };
      })(this);
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        name = ref1[j];
        if (blackList(name)) {
          continue;
        }
        fn1(name);
      }
      this.on = this.__on;
      return this.emit = this.__emit;
    };

    SlaveProcessConnect.prototype.__function = function() {
      var args, name, ref;
      name = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      args = _args(args);
      return (ref = Main.messanger).query.apply(ref, ['connectorFunction', this.__data.id, name].concat(slice.call(args)));
    };

    SlaveProcessConnect.prototype.__get = function(name) {
      return Main.messanger.query('connectorVarGet', this.__data.id, name);
    };

    SlaveProcessConnect.prototype.__set = function(name, val) {
      return Main.messanger.query('connectorVarSet', this.__data.id, name, val);
    };

    SlaveProcessConnect.prototype.__on = function*(action, func) {
      (yield Main.messanger.receive("connectorEmit:" + this.__data.id + ":" + action, func));
      return Main.messanger.query('connectorOn', this.__data.id, action);
    };

    SlaveProcessConnect.prototype.__emit = function() {
      var action, data, ref;
      action = arguments[0], data = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      return (ref = Main.messanger).query.apply(ref, ['connectorEmit', this.__data.id, action].concat(slice.call(data)));
    };

    return SlaveProcessConnect;

  })();

  module.exports = SlaveProcessConnect;

}).call(this);
