(function() {
  var MasterProcessConnect, MasterServiceManager,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  MasterProcessConnect = require('../process/masterProcessConnect');

  global.MASTERSERVICEMANAGERSERVICEID = 0;

  MasterServiceManager = (function() {
    function MasterServiceManager() {
      this.get = bind(this.get, this);
      this.connectService = bind(this.connectService, this);
      this.runService = bind(this.runService, this);
      this.run = bind(this.run, this);
      this.init = bind(this.init, this);
      Wrap(this);
      this.config = {};
      this.services = {
        byProcess: {},
        byId: {},
        byName: {}
      };
      this.waitFor = {};
    }

    MasterServiceManager.prototype.init = function*() {
      var configs, j, len, m, name, results, service;
      this.log();
      configs = (yield _readdir('feel/lib/feel/service/config'));
      results = [];
      for (j = 0, len = configs.length; j < len; j++) {
        name = configs[j];
        if (!(m = name.match(/^(\w+)\.coffee$/))) {
          continue;
        }
        service = require("./config/" + name);
        name = m[1];
        service.name = name;
        this.config[name] = service;
        if (service.autostart) {
          results.push(this.waitFor[name] = true);
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    MasterServiceManager.prototype.run = function*() {
      var _q, conf, fn, i, j, k, len, name, num, os, qs, ref, ref1, ref2, ref3, serv;
      ref = Main.processManager.config;
      for (name in ref) {
        conf = ref[name];
        if (conf.autostart && (conf.services != null)) {
          ref1 = conf.services;
          for (j = 0, len = ref1.length; j < len; j++) {
            serv = ref1[j];
            this.waitFor[serv] = true;
          }
        }
      }
      this.log();
      qs = [];
      os = require('os');
      ref2 = this.config;
      for (name in ref2) {
        conf = ref2[name];
        if (conf.autostart && conf.single) {
          num = 1;
          if (os.hostname() === 'pi0h.org' && name === "feel" && os.cpus().length > 8) {
            num = os.cpus().length;
          }
          _q = Q();
          if (num !== 1) {
            fn = (function(_this) {
              return function(name, conf) {
                _q = _q.then(function() {
                  return Main.processManager.runProcess({
                    name: 'service-' + name,
                    services: [name]
                  });
                });
                return _q = _q.then(function(p) {
                  return _waitFor(p, 'run', 3 * 60 * 1000);
                });
              };
            })(this);
            for (i = k = 1, ref3 = num; 1 <= ref3 ? k <= ref3 : k >= ref3; i = 1 <= ref3 ? ++k : --k) {
              fn(name, conf);
            }
            qs.push(_q);
          } else {
            qs.push(Main.processManager.runProcess({
              name: 'service-' + name,
              services: [name]
            }));
          }
        }
      }
      return (yield Q.all(qs));
    };

    MasterServiceManager.prototype.runService = function*(name, args) {
      var process;
      process = (yield Main.processManager.runProcess({
        name: 'service-' + name,
        services: [name],
        args: args
      }));
      return (yield _waitFor(process, 'run', 3 * 60 * 1000));
    };

    MasterServiceManager.prototype.connectService = function*(processId, serviceId) {
      var base, base1, masterId, name, process, service, wrapper;
      process = (yield Main.processManager.getProcess(processId));
      service = new MasterProcessConnect({
        type: 'service',
        id: serviceId
      }, process);
      (yield service.__init());
      wrapper = service;
      masterId = MASTERSERVICEMANAGERSERVICEID++;
      name = (yield service.__serviceName);
      if ((base = this.services.byProcess)[processId] == null) {
        base[processId] = {};
      }
      this.services.byProcess[processId][serviceId] = wrapper;
      this.services.byId[masterId] = wrapper;
      if ((base1 = this.services.byName)[name] == null) {
        base1[name] = [];
      }
      this.services.byName[name].push(wrapper);
      return this.emit('connected:' + name, wrapper);
    };

    MasterServiceManager.prototype.get = function*(name) {
      var arr, service;
      arr = this.services.byName[name];
      if (!(_util.isArray(arr) && arr.length)) {
        if (!this.waitFor[name]) {
          throw new Error('no one started service at master with name ' + name);
        }
        return (yield _waitFor(this, 'connected:' + name));
      }
      service = arr[Math.floor(Math.random() * arr.length)];
      return service;
    };

    return MasterServiceManager;

  })();

  module.exports = MasterServiceManager;

}).call(this);
