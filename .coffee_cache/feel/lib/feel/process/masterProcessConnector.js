(function() {
  var MasterProcessConnector, blackList,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  global.MASTERPROCESSCONNECTORID = 0;

  blackList = require('./blackList');


  /*
   * conf:
   *   type: 'masterProcessManager'
   *
   */

  MasterProcessConnector = (function() {
    function MasterProcessConnector(conf, process) {
      this.conf = conf;
      this.process = process;
      this.connect = bind(this.connect, this);
      this.qEmit = bind(this.qEmit, this);
      this.qOn = bind(this.qOn, this);
      this.qVarSet = bind(this.qVarSet, this);
      this.qVarGet = bind(this.qVarGet, this);
      this.qFunction = bind(this.qFunction, this);
      this.data = bind(this.data, this);
      this.init = bind(this.init, this);
      this.id = global.MASTERPROCESSCONNECTORID++;
      this.dataArray = {
        functions: [],
        vars: [],
        id: this.id
      };
      this.isOn = {};
      Wrap(this);
    }

    MasterProcessConnector.prototype.init = function*() {
      var key, ref, results, val;
      switch (this.conf.type) {
        case 'masterProcessManager':
          this.target = Main.processManager;
          break;
        case 'masterServiceManager':
          this.target = Main.serviceManager;
          break;
        case 'serviceNearest':
          this.target = (yield Main.serviceManager.get(this.conf.name));
          break;
        default:
          throw new Error('bad description of processConnector');
      }
      ref = this.target;
      results = [];
      for (key in ref) {
        val = ref[key];
        if (blackList(key)) {
          continue;
        }
        if (typeof val === 'function') {
          results.push(this.dataArray.functions.push(key));
        } else {
          results.push(this.dataArray.vars.push(key));
        }
      }
      return results;
    };

    MasterProcessConnector.prototype.data = function() {
      return this.dataArray;
    };

    MasterProcessConnector.prototype.qFunction = function() {
      var args, name, ref;
      name = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      return (ref = this.target)[name].apply(ref, args);
    };

    MasterProcessConnector.prototype.qVarGet = function(name) {
      return this.target[name];
    };

    MasterProcessConnector.prototype.qVarSet = function(name, val) {
      return this.target[name] = val;
    };

    MasterProcessConnector.prototype.qOn = function(action) {
      if (this.isOn[action]) {
        return;
      }
      this.isOn[action] = true;
      return this.target.on(action, (function(_this) {
        return function() {
          var args, ref;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return (ref = _this.process).send.apply(ref, ["connectorEmit:" + _this.id + ":" + action].concat(slice.call(args)));
        };
      })(this));
    };

    MasterProcessConnector.prototype.qEmit = function() {
      var action, data, ref;
      action = arguments[0], data = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      return (ref = this.target).emit.apply(ref, [action].concat(slice.call(data)));
    };

    MasterProcessConnector.prototype.connect = function() {};

    return MasterProcessConnector;

  })();

  module.exports = MasterProcessConnector;

}).call(this);
