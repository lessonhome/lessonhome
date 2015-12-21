(function() {
  var Jobs, _kue,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _kue = require('kue');

  Jobs = (function() {
    function Jobs() {
      this.solve = bind(this.solve, this);
      this.solve2 = bind(this.solve2, this);
      this.onprocess = bind(this.onprocess, this);
      this.listen = bind(this.listen, this);
      this.listen2 = bind(this.listen2, this);
      this.onMessage = bind(this.onMessage, this);
      this.onSubscribe = bind(this.onSubscribe, this);
      this.redisConnect = bind(this.redisConnect, this);
      this.connect = bind(this.connect, this);
      this.init = bind(this.init, this);
      $W(this);
      this.listening = {};
    }

    Jobs.prototype.init = function*() {
      return (yield this.connect());
    };

    Jobs.prototype.connect = function*() {
      if (this.queue != null) {
        return;
      }
      this.queue = _kue.createQueue();
      this.solves = {};
      this.queue.on('error', function(err) {
        return console.error(err);
      });
      (yield this.redisConnect());

      /*
      @queue.active (err,ids)->
        ids.forEach (id)->
          _kue.Job.get id, (err,job)-> job.inactive() unless err
       */
      _kue.Job.rangeByState('complite', 0, 10000000, 'asc', function(err, jobs) {
        return jobs.forEach(function(job) {
          return job.remove();
        });
      });
      return _kue.Job.rangeByState('failed', 0, 10000000, 'asc', function(err, jobs) {
        return jobs.forEach(function(job) {
          return job.remove();
        });
      });
    };

    Jobs.prototype.redisConnect = function*() {
      this.redis = (yield Main.service('redis'));
      this.redisP = (yield this.redis.get());
      this.redisS = (yield this.redis.get());
      this.redisS.on('subscribe', (function(_this) {
        return function() {
          return _this.onSubscribe.apply(_this, arguments);
        };
      })(this));
      return this.redisS.on('message', (function(_this) {
        return function() {
          return _this.onMessage.apply(_this, arguments);
        };
      })(this));
    };

    Jobs.prototype.onSubscribe = function(name) {
      return Q.spawn((function(_this) {
        return function() {

          /*
          yield _invoke @redisP,'lpush','jobs:email:',JSON.stringify {
            name : 'jobs:email:'
            id : 'qweop'
            data : {to:'tema.dudko'}
          }
          @redisP.publish "jobs:email:",""
           */
        };
      })(this));
    };

    Jobs.prototype.onMessage = function(channel, m) {
      return Q.spawn((function(_this) {
        return function*() {
          if (m && _this.solves[channel]) {
            _this.solves[channel](JSON.parse(m));
            return;
          }
          while (true) {
            m = (yield _invoke(_this.redisP, 'rpop', channel));
            if (!m) {
              return;
            }
            (function(m) {
              return Q.spawn(function*() {
                var err, error, hash, name, obj, ref, ret, temp;
                obj = JSON.parse(m);
                ref = obj.name.split(':'), temp = ref[0], name = ref[1], hash = ref[2];
                try {
                  ret = (yield _this.listening[name].hash[hash](obj.data));
                  return _this.redisP.publish(obj.id, JSON.stringify({
                    data: ret
                  }));
                } catch (error) {
                  err = error;
                  console.error(err);
                  return _this.redisP.publish(obj.id, JSON.stringify({
                    err: err
                  }));
                }
              });
            })(m);
            (yield Q.delay(0));
          }
        };
      })(this));
    };

    Jobs.prototype.listen2 = function*(name, hash, foo) {
      var name2;
      if (hash == null) {
        hash = '';
      }
      (yield this.connect());
      if (!foo) {
        foo = hash;
        hash = '';
      }
      name2 = name + ':' + hash;
      if (this.listening[name] == null) {
        this.listening[name] = {
          hash: {}
        };
      }
      if (this.listening[name].hash[hash] !== foo) {
        if (!this.listening[name].hash[hash]) {
          this.queue.process(name2, 2, (function(_this) {
            return function(job, done) {
              _this.onprocess.call(_this, job, done);
            };
          })(this));
        }
        return this.listening[name].hash[hash] = foo;
      }
    };

    Jobs.prototype.listen = function*(name, hash, foo) {
      var name2;
      if (hash == null) {
        hash = '';
      }
      (yield this.connect());
      if (!foo) {
        foo = hash;
        hash = '';
      }
      name2 = name + ':' + hash;
      if (this.listening[name] == null) {
        this.listening[name] = {
          hash: {}
        };
      }
      if (this.listening[name].hash[hash] !== foo) {
        if (!this.listening[name].hash[hash]) {
          (yield _invoke(this.redisS, 'subscribe', 'jobs:' + name2));
        }
        this.listening[name].hash[hash] = foo;
        return (yield this.onMessage('jobs:' + name2));
      }
    };

    Jobs.prototype.onprocess = function(job, done) {
      return Q.spawn((function(_this) {
        return function*() {
          var hash, name, ref, ret;
          ref = job.type.split(':'), name = ref[0], hash = ref[1];
          ret = (yield _this.listening[name].hash[hash](job.data));
          done(null, ret);
        };
      })(this));
    };

    Jobs.prototype.solve2 = function*(name, data, priority) {
      var d, hash, job, name2;
      (yield this.connect());
      d = Q.defer();
      hash = data.hash || '';
      name2 = name + ':' + hash;
      job = this.queue.create(name2, data);
      job = job.ttl(1000000);
      job = job.attempts(3).backoff(true).removeOnComplete(true);
      if (priority) {
        job = job.priority(priority);
      }
      job = job.on('complete', (function(_this) {
        return function(res) {
          return d.resolve(res);
        };
      })(this));
      job = job.on('failed', (function(_this) {
        return function(err) {
          return d.reject(err);
        };
      })(this));
      job = job.save();
      return d.promise;
    };

    Jobs.prototype.solve = function*(name, hash, data) {
      var d, id, name2;
      if (hash == null) {
        hash = "";
      }
      (yield this.connect());
      if (!data) {
        data = hash;
        hash = "";
      }
      d = Q.defer();
      hash = data.hash || '';
      name2 = name + ':' + hash;
      id = _randomHash();
      this.solves[id] = (function(_this) {
        return function(obj) {
          if (obj.err) {
            d.reject(obj.err);
          } else {
            d.resolve(obj.data);
            delete _this.solves[id];
          }
          return _this.redisS.unsubscribe(id);
        };
      })(this);
      (yield _invoke(this.redisS, 'subscribe', id));
      (yield _invoke(this.redisP, 'lpush', "jobs:" + name2, JSON.stringify({
        id: id,
        name: "jobs:" + name2,
        data: data
      })));
      this.redisP.publish("jobs:" + name2, '');

      /*
      job = @queue.create name2,data
      job = job.ttl 1000000
      job = job.attempts(3).backoff( true ).removeOnComplete(true)
      job = job.priority(priority) if priority
      job = job.on 'complete',(res)=>
        d.resolve res
      job = job.on 'failed',(err)=>
        d.reject err
      job = job.save()
       */
      return d.promise;
    };

    return Jobs;

  })();

  module.exports = Jobs;

}).call(this);
