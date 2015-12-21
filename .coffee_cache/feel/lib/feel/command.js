(function() {
  var Lib, _cluster, error, log,
    slice = [].slice,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  console.log();

  Lib = new (require('./lib'))();

  _cluster = require('cluster');

  log = (function(_this) {
    return function(msg) {
      return console.log.apply(console, ["main_process".blue + (":" + process.pid).grey].concat(slice.call(arguments)));
    };
  })(this);

  error = (function(_this) {
    return function(msg) {
      console.error("********************************************************".red);
      console.error.apply(console, ["ERROR".red + ":main_process:".blue + ("" + process.pid).grey].concat(slice.call(arguments)));
      return console.error("********************************************************".red);
    };
  })(this);

  process.on('uncaughtException', (function(_this) {
    return function(e) {
      error("uncaughtException".red, e.stack);
      return process.exit(1);
    };
  })(this));

  process.on('exit', (function(_this) {
    return function(code) {
      var id, ref, worker;
      ref = _cluster.workers;
      for (id in ref) {
        worker = ref[id];
        worker.kill();
      }
      return log("exit with code".yellow + (" " + code).red);
    };
  })(this));

  process.on('SIGINT', (function(_this) {
    return function() {
      log("SIGINT".red);
      return process.exit(0);
    };
  })(this));

  process.on('SIGTERM', (function(_this) {
    return function() {
      log("SIGTERM".red);
      return process.exit(0);
    };
  })(this));

  module.exports = (function() {
    function exports() {
      this.run = bind(this.run, this);
      this.onerror = bind(this.onerror, this);
      this.init = bind(this.init, this);
      Wrap(this);
      this.domain = require('domain');
      this.context = this.domain.create();
      this.context.on('error', this.onerror);
    }

    exports.prototype.init = function*() {
      var Main_;
      (yield Lib.init());
      Main_ = require("./main");
      this.main = new Main_();
      global.Main = this.main;
      return (yield this.main.init());
    };

    exports.prototype.onerror = function(err) {
      try {
        error('main domain handle'.yellow, Exception(err));
        return process.exit(1);
      } catch (undefined) {}
    };

    exports.prototype.run = function() {
      return log("run()".blue);
    };

    return exports;

  })();

}).call(this);
