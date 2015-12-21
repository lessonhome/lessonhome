
/*
 * MasterProcessFork
 * класс поддерживающий один форк потока, не поддерживает реконнект
 */

(function() {
  var MasterProcessFork,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    slice = [].slice;

  MasterProcessFork = (function(superClass) {
    extend(MasterProcessFork, superClass);

    function MasterProcessFork(conf1) {
      this.conf = conf1;
      this.stop = bind(this.stop, this);
      this.message = bind(this.message, this);
      this.receiveOnce = bind(this.receiveOnce, this);
      this.receive = bind(this.receive, this);
      this.send = bind(this.send, this);
      this.init = bind(this.init, this);
      Wrap(this);
      this.ee = new EE;
    }

    MasterProcessFork.prototype.init = function() {
      var _cluster, conf;
      _cluster = require('cluster');
      _cluster.setupMaster({
        exec: this.conf.exec
      });
      conf = {
        "FORK": JSON.stringify(this.conf)
      };
      this.worker = _cluster.fork(conf);
      this.worker.on('exit', (function(_this) {
        return function(code) {
          if (code) {
            return _this.emit('restart', code);
          }
          return _this.emit('exit');
        };
      })(this));
      this.worker.on('message', (function(_this) {
        return function(msg) {
          return _this.message(msg).done();
        };
      })(this));
      return this.pid = this.worker.process.pid;
    };

    MasterProcessFork.prototype.send = function() {
      var args, msg;
      msg = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
      return this.worker.send({
        msg: msg,
        args: args
      });
    };

    MasterProcessFork.prototype.receive = function() {
      var args, ref;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      return (ref = this.ee).on.apply(ref, args);
    };

    MasterProcessFork.prototype.receiveOnce = function() {
      var args, ref;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      return (ref = this.ee).once.apply(ref, args);
    };

    MasterProcessFork.prototype.message = function(arg) {
      var args, msg, ref;
      msg = arg.msg, args = arg.args;
      if (msg == null) {
        throw new Error('undefined msg received');
      }
      if (args == null) {
        args = [];
      }
      switch (msg) {
        case 'ready':
          return this.emit.apply(this, ['ready'].concat(slice.call(args)));
        case 'run':
          return this.emit.apply(this, ['run'].concat(slice.call(args)));
        case 'die':
          this.log(this.conf.name + ":" + this.conf.processId + " - die");
          return this.emit.apply(this, ['restart'].concat(slice.call(args)));
        case 'exit':
          this.log(this.conf.name + ":" + this.conf.processId + " - exit");
          return this.emit.apply(this, ['exit'].concat(slice.call(args)));
        default:
          return (ref = this.ee).emit.apply(ref, [msg].concat(slice.call(args)));
      }
    };

    MasterProcessFork.prototype.stop = function() {
      try {
        return this.worker.kill();
      } catch (undefined) {}
    };

    return MasterProcessFork;

  })(EE);

  module.exports = MasterProcessFork;

}).call(this);
