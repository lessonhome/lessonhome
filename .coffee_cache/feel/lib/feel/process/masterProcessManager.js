
/*
 * MasterProcessManager
 * управляет запуском необходимых потоков и межпоточным взаимодействием
 */

(function() {
  var MasterProcess, MasterProcessConnector, MasterProcessManager, _fs, _readdir,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  _fs = require('fs');

  _readdir = Q.denode(_fs.readdir);

  MasterProcess = require('./masterProcess');

  MasterProcessConnector = require('./masterProcessConnector');

  MasterProcessManager = (function() {
    function MasterProcessManager() {
      this.q_connectorEmit = bind(this.q_connectorEmit, this);
      this.q_connectorOn = bind(this.q_connectorOn, this);
      this.q_connectorVarSet = bind(this.q_connectorVarSet, this);
      this.q_connectorVarGet = bind(this.q_connectorVarGet, this);
      this.q_connectorFunction = bind(this.q_connectorFunction, this);
      this.q_connect = bind(this.q_connect, this);
      this.q_nearest = bind(this.q_nearest, this);
      this.setQuery = bind(this.setQuery, this);
      this.runProcess = bind(this.runProcess, this);
      this.getProcess = bind(this.getProcess, this);
      this.run = bind(this.run, this);
      this.init = bind(this.init, this);
      Wrap(this);
      this.config = {};
      this.process = {};
      this.processById = {};
      this.connectors = {};
      this.query = new EE;
    }

    MasterProcessManager.prototype.init = function*() {
      var base, base1, base2, configs, i, len, m, name, results;
      this.log();
      (yield this.setQuery());
      configs = (yield _readdir('feel/lib/feel/process/config'));
      results = [];
      for (i = 0, len = configs.length; i < len; i++) {
        name = configs[i];
        if (!(m = name.match(/^(\w+)\.coffee$/))) {
          continue;
        }
        this.config[m[1]] = require("./config/" + name);
        this.config[m[1]].name = m[1];
        if ((base = this.config[m[1]]).services == null) {
          base.services = [];
        }
        if ((base1 = this.config[m[1]]).single == null) {
          base1.single = false;
        }
        results.push((base2 = this.config[m[1]]).autostart != null ? base2.autostart : base2.autostart = false);
      }
      return results;
    };

    MasterProcessManager.prototype.run = function() {
      var conf, name, qs, ref;
      this.log();
      qs = [];
      ref = this.config;
      for (name in ref) {
        conf = ref[name];
        if (conf.autostart) {
          qs.push(this.runProcess(conf));
        }
      }
      return Q.all(qs);
    };

    MasterProcessManager.prototype.getProcess = function(id) {
      return this.processById[id];
    };

    MasterProcessManager.prototype.runProcess = function(conf, args) {
      var base, conf2, i, key, len, name1, s, val;
      if (args == null) {
        args = {};
      }
      if (typeof conf === 'string') {
        conf = this.config[conf];
      }
      conf2 = {};
      for (key in conf) {
        val = conf[key];
        conf2[key] = val;
      }
      if (_util.isArray(args)) {
        if (conf2.services == null) {
          conf2.services = [];
        }
        for (i = 0, len = args.length; i < len; i++) {
          s = args[i];
          conf2.services.push(s);
        }
        args = {};
      }
      for (key in args) {
        val = args[key];
        conf2[key] = val;
      }
      this.log(conf2.name);
      if ((base = this.process)[name1 = conf2.name] == null) {
        base[name1] = [];
      }
      if ((this.process[conf2.name].length > 0) && conf2.single) {
        return;
      }
      s = new MasterProcess(conf2, this);
      this.process[conf2.name].push(s);
      this.processById[s.id] = s;
      return s.init();
    };

    MasterProcessManager.prototype.setQuery = function() {
      this.query.__emit = this.query.emit;
      return this.query.emit = (function(_this) {
        return function() {
          var args, id, name;
          name = arguments[0], id = arguments[1], args = 3 <= arguments.length ? slice.call(arguments, 2) : [];
          if (_this["q_" + name] == null) {
            return _this.query.__emit(name + ":" + id, ExceptionJson(new Error('unknown query ' + name + ' to master process')));
          } else {
            return _this["q_" + name].apply(_this, args).then(function(data) {
              return _this.query.__emit(name + ":" + id, null, data);
            })["catch"](function(err) {
              return _this.query.__emit(name + ":" + id, ExceptionJson(err));
            });
          }
        };
      })(this);
    };

    MasterProcessManager.prototype.q_nearest = function() {
      var args;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    };

    MasterProcessManager.prototype.q_connect = function*(conf) {
      var connector;
      connector = new MasterProcessConnector(conf, (yield this.getProcess(conf.processId)));
      (yield connector.init());
      this.connectors[connector.id] = connector;
      return connector.data();
    };

    MasterProcessManager.prototype.q_connectorFunction = function() {
      var args, id, name, ref;
      id = arguments[0], name = arguments[1], args = 3 <= arguments.length ? slice.call(arguments, 2) : [];
      return (ref = this.connectors[id]).qFunction.apply(ref, [name].concat(slice.call(args)));
    };

    MasterProcessManager.prototype.q_connectorVarGet = function(id, name) {
      return this.connectors[id].qVarGet(name);
    };

    MasterProcessManager.prototype.q_connectorVarSet = function(id, name, val) {
      return this.connectors[id].qVarSet(name, val);
    };

    MasterProcessManager.prototype.q_connectorOn = function(id, action) {
      return this.connectors[id].qOn(action);
    };

    MasterProcessManager.prototype.q_connectorEmit = function() {
      var action, data, id, ref;
      id = arguments[0], action = arguments[1], data = 3 <= arguments.length ? slice.call(arguments, 2) : [];
      return (ref = this.connectors[id]).qEmit.apply(ref, [action].concat(slice.call(data)));
    };

    return MasterProcessManager;

  })();

  module.exports = MasterProcessManager;

}).call(this);
