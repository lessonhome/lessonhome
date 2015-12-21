(function() {
  var Main, MasterProcessManager, MasterServiceManager,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  MasterProcessManager = require('./process/masterProcessManager');

  MasterServiceManager = require('./service/masterServiceManager');

  Main = (function() {
    function Main() {
      this.init = bind(this.init, this);
      this.name = 'Master';
      this.startTime = new Date();
      setInterval((function(_this) {
        return function() {
          var hour, min, sec, t;
          t = new Date() - _this.startTime;
          sec = 1000;
          min = sec * 60;
          hour = min * 60;
          return console.log(("started time " + (Math.floor(t / hour)) + ":" + (Math.floor((t / min) % 60)) + ":" + (Math.floor((t / sec) % 60))).grey);
        };
      })(this), 30000);
      Wrap(this);
    }

    Main.prototype.init = function*() {
      var base, base1;
      this.log();
      this.serviceManager = new MasterServiceManager();
      this.processManager = new MasterProcessManager();
      (yield this.serviceManager.init());
      (yield this.processManager.init());
      (yield (typeof (base = this.serviceManager).run === "function" ? base.run() : void 0));
      (yield (typeof (base1 = this.processManager).run === "function" ? base1.run() : void 0));
      return this.log('OK');
    };

    return Main;

  })();

  module.exports = Main;

}).call(this);
