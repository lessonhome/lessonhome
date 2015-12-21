
/*
 * MasterProcess
 * класс который обеспечивает непрерывное общение с потоком
 * и его запуск/перезапуск в случае падения
 * работает только в мастер потоке
 * Public:
 * start()   - запускает поток, если не запущен, так же гарантирует его работоспособность, 
 *           в случае успеха
 * stop()    - останавливает поток
 * restart() - перезагружает поток (stop()&start()) 
 * send/receive() - аналог on,emit для обмена сообщениями с потоком
 */

(function() {
  var MasterProcess, MasterProcessFork, util,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty,
    slice = [].slice;

  util = require('util');

  MasterProcessFork = require('./masterProcessFork');

  global.MASTERPROCESSUNIQID = 0;

  MasterProcess = (function(superClass) {
    extend(MasterProcess, superClass);

    function MasterProcess(conf, manager) {
      this.conf = conf;
      this.manager = manager;
      this.fExit = bind(this.fExit, this);
      this.fRestart = bind(this.fRestart, this);
      this.fRun = bind(this.fRun, this);
      this.fReady = bind(this.fReady, this);
      this.bindForkEvents = bind(this.bindForkEvents, this);
      this.onQuery = bind(this.onQuery, this);
      this.wait = bind(this.wait, this);
      this.query = bind(this.query, this);
      this.send = bind(this.send, this);
      this.receiveOnce = bind(this.receiveOnce, this);
      this.receive = bind(this.receive, this);
      this.restart = bind(this.restart, this);
      this.stop = bind(this.stop, this);
      this.start = bind(this.start, this);
      this.init = bind(this.init, this);
      this.id = global.MASTERPROCESSUNIQID++;
      this.conf.processId = this.id;
      this.name = this.conf.name;
      Wrap(this);
      this.conf.exec = "feel/lib/feel/process/slaveProcessFork.js";
      this.runnig = false;
      this.starting = false;
      this.ee = new EE;
      this.on('running', (function(_this) {
        return function() {
          return _this.running = true;
        };
      })(this));
      this.listeners = {
        ready: this.fReady,
        run: this.fRun,
        restart: this.fRestart,
        exit: this.fExit
      };
      this.receive('query', this.onQuery);
    }

    MasterProcess.prototype.init = function*() {
      (yield this.start(true));
      return this;
    };

    MasterProcess.prototype.start = function*(isFirst) {
      if (isFirst == null) {
        isFirst = false;
      }
      if (this.running || this.starting) {
        return;
      }
      this.starting = true;
      this.fork = new MasterProcessFork(this.conf);
      (yield this.bindForkEvents(isFirst));
      (yield this.fork.init());
      return this.starting = false;
    };

    MasterProcess.prototype.stop = function*() {
      if (!(this.running || this.starting)) {
        return;
      }
      if (this.starting) {
        (yield this.wait());
      }
      this.running = false;
      return (yield this.fork.stop());
    };

    MasterProcess.prototype.restart = function*() {
      (yield this.stop());
      return (yield this.start());
    };

    MasterProcess.prototype.receive = function() {
      var args, ref, ref1;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      (ref = this.ee).on.apply(ref, args);
      return (ref1 = this.fork).receive.apply(ref1, args);
    };

    MasterProcess.prototype.receiveOnce = function() {
      var args, ref, ref1;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      (ref = this.ee).once.apply(ref, args);
      return (ref1 = this.fork).receiveOnce.apply(ref1, args);
    };

    MasterProcess.prototype.send = function*() {
      var args, ref;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      (yield this.wait());
      return (ref = this.fork).send.apply(ref, args);
    };

    MasterProcess.prototype.query = function() {
      var args, defer, id;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      id = 'masterQuery_' + global.MASTERPROCESSUNIQID++;
      defer = Q.defer();
      this.receiveOnce('query:' + id, (function(_this) {
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

    MasterProcess.prototype.wait = function(foo) {
      var defer;
      if (this.running) {
        return typeof foo === "function" ? foo() : void 0;
      }
      defer = Q.defer();
      this.on('running', (function(_this) {
        return function() {
          return defer.resolve(typeof foo === "function" ? foo() : void 0);
        };
      })(this));
      return defer.promise;
    };

    MasterProcess.prototype.onQuery = function() {
      var args, id, name, nid, ref;
      id = arguments[0], name = arguments[1], args = 3 <= arguments.length ? slice.call(arguments, 2) : [];
      nid = this.id + ":" + id;
      this.manager.query.once(name + ":" + nid, (function(_this) {
        return function(err, data) {
          return _this.send("query:" + id, err, data);
        };
      })(this));
      return (ref = this.manager.query).emit.apply(ref, [name, nid].concat(slice.call(args)));
    };

    MasterProcess.prototype.bindForkEvents = function(isFirst) {
      var arr, event, fn, l, listener, msg, ref, ref1, results;
      if (isFirst == null) {
        isFirst = false;
      }
      if (this.listenersNow != null) {
        for (event in this.listeners) {
          this.listenersNow[event] = function() {};
        }
      }
      this.listenersNow = {};
      ref = this.listeners;
      fn = (function(_this) {
        return function(event, ln) {
          ln[event] = function() {
            var args, ref1;
            args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
            return (ref1 = _this.listeners)[event].apply(ref1, args);
          };
          return _this.fork.on(event, function() {
            var args;
            args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
            return ln[event].apply(ln, args);
          });
        };
      })(this);
      for (event in ref) {
        listener = ref[event];
        fn(event, this.listenersNow);
      }
      if (isFirst) {
        return;
      }
      ref1 = this.ee._events;
      results = [];
      for (msg in ref1) {
        arr = ref1[msg];
        if (arr == null) {
          arr = [];
        }
        if (!util.isArray(arr)) {
          arr = [arr];
        }
        results.push((function() {
          var i, len, results1;
          results1 = [];
          for (i = 0, len = arr.length; i < len; i++) {
            l = arr[i];
            results1.push(this.fork.receive(msg, l));
          }
          return results1;
        }).call(this));
      }
      return results;
    };

    MasterProcess.prototype.fReady = function() {
      this.running = true;
      return this.emit('running');
    };

    MasterProcess.prototype.fRun = function() {
      return this.emit('run');
    };

    MasterProcess.prototype.fRestart = function() {
      this.log(this.name + ":" + this.id);
      return this.restart();
    };

    MasterProcess.prototype.fExit = function() {
      this.log(this.name + ":" + this.id);
      return this.restart();
    };

    return MasterProcess;

  })(EE);

  module.exports = MasterProcess;

}).call(this);
