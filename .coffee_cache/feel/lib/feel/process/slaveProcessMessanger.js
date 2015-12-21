(function() {
  var SlaveProcessConnector, SlaveProcessMessanger,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  global.SLAVEPROCESSMESSANGERID = 0;

  SlaveProcessConnector = require('./slaveProcessConnector');

  SlaveProcessMessanger = (function() {
    function SlaveProcessMessanger() {
      this.q_connectorEmit = bind(this.q_connectorEmit, this);
      this.q_connectorOn = bind(this.q_connectorOn, this);
      this.q_connectorVarSet = bind(this.q_connectorVarSet, this);
      this.q_connectorVarGet = bind(this.q_connectorVarGet, this);
      this.q_connectorFunction = bind(this.q_connectorFunction, this);
      this.q_connect = bind(this.q_connect, this);
      this.onQuery = bind(this.onQuery, this);
      this.setQuery = bind(this.setQuery, this);
      this.query = bind(this.query, this);
      this.onMessage = bind(this.onMessage, this);
      this.receive = bind(this.receive, this);
      this.send = bind(this.send, this);
      this.init = bind(this.init, this);
      Wrap(this);
      this.ee = new EE;
      this.queryEE = new EE;
      this.receive('query', this.onQuery);
      this.connectors = {};
    }

    SlaveProcessMessanger.prototype.init = function*() {
      process.on('message', this.onMessage);
      return (yield this.setQuery());
    };

    SlaveProcessMessanger.prototype.send = function() {
      var args, msg;
      msg = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      return process.send({
        msg: msg,
        args: args
      });
    };

    SlaveProcessMessanger.prototype.receive = function() {
      var ref;
      return (ref = this.ee).on.apply(ref, arguments);
    };

    SlaveProcessMessanger.prototype.onMessage = function(arg) {
      var args, msg, ref;
      msg = arg.msg, args = arg.args;
      return (ref = this.ee).emit.apply(ref, [msg].concat(slice.call(args)));
    };

    SlaveProcessMessanger.prototype.query = function() {
      var args, defer, id;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      id = global.SLAVEPROCESSMESSANGERID++;
      defer = Q.defer();
      this.ee.once('query:' + id, (function(_this) {
        return function(err, data) {
          if (err != null) {
            return defer.reject(ExceptionUnJson(err));
          }
          return defer.resolve(data);
        };
      })(this));
      this.send.apply(this, ['query', id].concat(slice.call(args)));
      return defer.promise;
    };

    SlaveProcessMessanger.prototype.setQuery = function() {
      this.queryEE.__emit = this.queryEE.emit;
      return this.queryEE.emit = (function(_this) {
        return function() {
          var args, id, name;
          name = arguments[0], id = arguments[1], args = 3 <= arguments.length ? slice.call(arguments, 2) : [];
          if (_this["q_" + name] == null) {
            return _this.queryEE.__emit(name + ":" + id, ExceptionJson(new Error('unknown query ' + name + ' to master process')));
          } else {
            return _this["q_" + name].apply(_this, args).then(function(data) {
              return _this.queryEE.__emit(name + ":" + id, null, data);
            })["catch"](function(err) {
              return _this.queryEE.__emit(name + ":" + id, ExceptionJson(err));
            });
          }
        };
      })(this);
    };

    SlaveProcessMessanger.prototype.onQuery = function() {
      var args, id, name, nid, ref;
      id = arguments[0], name = arguments[1], args = 3 <= arguments.length ? slice.call(arguments, 2) : [];
      nid = "master:" + id;
      this.queryEE.once(name + ":" + nid, (function(_this) {
        return function(err, data) {
          return _this.send("query:" + id, err, data);
        };
      })(this));
      return (ref = this.queryEE).emit.apply(ref, [name, nid].concat(slice.call(args)));
    };

    SlaveProcessMessanger.prototype.q_connect = function*(conf) {
      var connector;
      connector = new SlaveProcessConnector(conf);
      (yield connector.init());
      this.connectors[connector.id] = connector;
      return connector.data();
    };

    SlaveProcessMessanger.prototype.q_connectorFunction = function() {
      var args, id, name, ref;
      id = arguments[0], name = arguments[1], args = 3 <= arguments.length ? slice.call(arguments, 2) : [];
      return (ref = this.connectors[id]).qFunction.apply(ref, [name].concat(slice.call(args)));
    };

    SlaveProcessMessanger.prototype.q_connectorVarGet = function(id, name) {
      return this.connectors[id].qVarGet(name);
    };

    SlaveProcessMessanger.prototype.q_connectorVarSet = function(id, name, val) {
      return this.connectors[id].qVarSet(name, val);
    };

    SlaveProcessMessanger.prototype.q_connectorOn = function(id, action) {
      return this.connectors[id].qOn(action);
    };

    SlaveProcessMessanger.prototype.q_connectorEmit = function() {
      var action, data, id, ref;
      id = arguments[0], action = arguments[1], data = 3 <= arguments.length ? slice.call(arguments, 2) : [];
      return (ref = this.connectors[id]).qEmit.apply(ref, [action].concat(slice.call(data)));
    };

    return SlaveProcessMessanger;

  })();

  module.exports = SlaveProcessMessanger;

}).call(this);
