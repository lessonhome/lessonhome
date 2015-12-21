(function() {
  var Service, SlaveProcessConnect, SlaveServiceManager, util,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  util = require('util');

  SlaveProcessConnect = require('../process/slaveProcessConnect');

  Service = require('./service');

  SlaveServiceManager = (function() {
    function SlaveServiceManager() {
      this.connectServiceToMaster = bind(this.connectServiceToMaster, this);
      this.start = bind(this.start, this);
      this.masterNearest = bind(this.masterNearest, this);
      this.choose = bind(this.choose, this);
      this.waitForService = bind(this.waitForService, this);
      this.getById = bind(this.getById, this);
      this.nearest = bind(this.nearest, this);
      this.run = bind(this.run, this);
      this.init = bind(this.init, this);
      Wrap(this);
      this.services = {
        self: {},
        master: {},
        others: {}
      };
      this.waitFor = {};
      this.serviceById = {};
    }

    SlaveServiceManager.prototype.init = function*() {
      var conf, i, len, name, ref, ref1, results, serv;
      this.master = new SlaveProcessConnect('masterServiceManager');
      (yield this.master.__init());
      this.config = (yield this.master.config);
      ref = this.config;
      for (name in ref) {
        conf = ref[name];
        if (conf.autostart && !conf.single) {
          this.waitFor[name] = true;
        }
      }
      ref1 = Main.conf.services;
      results = [];
      for (i = 0, len = ref1.length; i < len; i++) {
        serv = ref1[i];
        results.push(this.waitFor[serv] = true);
      }
      return results;
    };

    SlaveServiceManager.prototype.run = function*() {
      var conf, name, qs, ref;
      qs = [];
      ref = this.config;
      for (name in ref) {
        conf = ref[name];
        if (conf.autostart && !conf.single) {
          qs.push(this.start(name));
        }
      }
      return (yield Q.all(qs));
    };

    SlaveServiceManager.prototype.nearest = function(name) {
      var ref, ref1, ref2;
      if (((ref = this.services.self[name]) != null ? ref[0] : void 0) != null) {
        return this.choose(this.services.self[name]);
      }
      if (((ref1 = this.services.master[name]) != null ? ref1[0] : void 0) != null) {
        return this.choose(this.services.master[name]);
      }
      if (((ref2 = this.services.others[name]) != null ? ref2[0] : void 0) != null) {
        return this.choose(this.services.others[name]);
      }
      if (this.waitFor[name]) {
        return this.waitForService(name);
      }
      return this.masterNearest(name);
    };

    SlaveServiceManager.prototype.getById = function*(id) {
      if (this.serviceById[id] != null) {
        return this.serviceById[id];
      }
      return (yield _waitFor(this, "connectedId:" + id));
    };

    SlaveServiceManager.prototype.waitForService = function*(name) {
      var defer, waited;
      defer = Q.defer();
      waited = false;
      return (yield _waitFor(this, 'connected:' + name));
    };

    SlaveServiceManager.prototype.choose = function(array) {
      if (!(util.isArray(array) && array.length)) {
        throw new Error('cant choose service bad array');
      }
      return array[Math.floor(Math.random() * array.length)];
    };

    SlaveServiceManager.prototype.masterNearest = function*(name) {
      var base, service;
      this.waitFor[name] = true;
      service = new SlaveProcessConnect({
        type: 'serviceNearest',
        name: name
      });
      (yield service.__init());
      this.emit('connected:' + name, service);
      if ((base = this.services.master)[name] == null) {
        base[name] = [];
      }
      this.services.master[name].push(service);
      return service;
    };

    SlaveServiceManager.prototype.start = function*(name) {
      var base, conf, qs, service, wrapper;
      this.waitFor[name] = true;
      conf = this.config[name];
      service = new Service(conf);
      wrapper = (yield service.get());
      qs = [];
      if (!(conf.autostart && !conf.single)) {
        qs.push(this.connectServiceToMaster(service));
      }
      (yield service.init());
      this.serviceById[service.id] = wrapper;
      if ((base = this.services.self)[name] == null) {
        base[name] = [];
      }
      this.services.self[name].push(wrapper);
      this.emit('connectedId:' + service.id, wrapper);
      this.emit('connected:' + name, wrapper);
      qs.push(service.run());
      (yield Q.all(qs));
      return wrapper;
    };

    SlaveServiceManager.prototype.connectServiceToMaster = function*(service) {
      return (yield this.master.connectService(Main.processId, service.id));
    };

    return SlaveServiceManager;

  })();

  module.exports = SlaveServiceManager;

}).call(this);
