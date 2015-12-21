(function() {
  var Service, ServiceWrapper,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  ServiceWrapper = require('./serviceWrapper');

  global.SLAVESERVICEID = 0;

  Service = (function() {
    function Service(conf) {
      var Class;
      this.conf = conf;
      this.get = bind(this.get, this);
      this.run = bind(this.run, this);
      this.init = bind(this.init, this);
      this.name = this.conf.name;
      this.id = SLAVESERVICEID++;
      Wrap(this);
      this.path = process.cwd() + "/feel/lib/feel/" + this.conf.bin;
      this.ee = new EE;
      this.log(this.name);
      Class = require(this.path);
      this.service = new Class();
      Wrap(this.service);
      this.wrapper = new ServiceWrapper(this.service);
      this.wrapper.__serviceName = this.name;
      this.wrapper.__serviceId = this.id;
    }

    Service.prototype.init = function*() {
      var args, ref, ref1;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      if (((ref = this.conf) != null ? ref.args : void 0) != null) {
        if (args == null) {
          args = this.conf.args;
        }
      }
      (yield (ref1 = this.service).init.apply(ref1, args));
      return this.wrapper;
    };

    Service.prototype.run = function*() {
      var args, base;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      (yield (typeof (base = this.service).run === "function" ? base.run.apply(base, args) : void 0));
    };

    Service.prototype.get = function() {
      return this.wrapper;
    };

    return Service;

  })();

  module.exports = Service;

}).call(this);
