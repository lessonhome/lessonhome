(function() {
  var Tutors, _filter, _reload, tutors,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _filter = require('./filter.c');

  _reload = require('./reload.c');

  Tutors = (function() {
    function Tutors() {
      this.reload = bind(this.reload, this);
      this.filter = bind(this.filter, this);
      this.refilterRedis = bind(this.refilterRedis, this);
      this.writeFilters = bind(this.writeFilters, this);
      this.init = bind(this.init, this);
      $W(this);
      this.timereload = 0;
      this.inited = 0;
    }

    Tutors.prototype.init = function*() {
      var e, error, key, ref, ref1, val;
      return;
      if (this.inited === 1) {
        return _waitFor(this, 'inited');
      }
      if (this.inited > 1) {
        return;
      }
      this.redis = (yield Main.service('redis'));
      this.redis = (yield this.redis.get());
      this.inited = 1;
      this.urldata = (yield Main.service('urldata'));
      this.dbtutor = (yield this.$db.get('tutor'));
      this.dbpersons = (yield this.$db.get('persons'));
      this.dbaccounts = (yield this.$db.get('accounts'));
      this.dbuploaded = (yield this.$db.get('uploaded'));
      try {
        this.persons = JSON.parse((yield _invoke(this.redis, 'get', 'persons')));
        ref1 = (ref = this.persons) != null ? ref : {};
        for (key in ref1) {
          val = ref1[key];
          if (this.index == null) {
            this.index = {};
          }
          this.index[val.index] = val;
        }
        this.filters = JSON.parse((yield _invoke(this.redis, 'get', 'filters')));
      } catch (error) {
        e = error;
        console.error(e);
      } finally {
        if (!((this.persons != null) && (this.index != null) && (this.filters != null))) {
          if (this.persons == null) {
            this.persons = {};
          }
          if (this.index == null) {
            this.index = {};
          }
          if (this.filters == null) {
            this.filters = {};
          }
          (yield this.reload());
          this.inited = 2;
          this.emit('inited');
        } else {
          this.inited = 2;
          this.emit('inited');
          Q.spawn((function(_this) {
            return function*() {
              return (yield _this.reload());
            };
          })(this));
        }
      }
      setInterval((function(_this) {
        return function() {
          return Q.spawn(function*() {
            return (yield _this.reload());
          });
        };
      })(this), 15 * 60 * 1000);
      return setInterval((function(_this) {
        return function() {
          return Q.spawn(function*() {
            return (yield _this.writeFilters());
          });
        };
      })(this), 2 * 60 * 1000);
    };

    Tutors.prototype.writeFilters = function*() {
      if (!this.filterChange) {
        return;
      }
      this.filterChange = false;
      return (yield _invoke(this.redis, 'set', 'filters', JSON.stringify(this.filters)));
    };

    Tutors.prototype.refilterRedis = function*() {
      var f, filters, i, j, l, len, len1, nt_, o, t_, time;
      if (this.refiltering) {
        return;
      }
      this.refiltering = true;
      time = this.refilterTime = new Date().getTime();
      filters = (function() {
        var ref, ref1, ref2, results;
        ref1 = (ref = this.filters) != null ? ref : {};
        results = [];
        for (f in ref1) {
          o = ref1[f];
          results.push([f, (ref2 = o.num) != null ? ref2 : 0]);
        }
        return results;
      }).call(this);
      filters = filters.sort(function(a, b) {
        return b[1] - a[1];
      });
      for (i = j = 0, len = filters.length; j < len; i = ++j) {
        f = filters[i];
        f = f[0];
        o = this.filters[f];
        if (!o.redis) {
          continue;
        }
        if (!((o.num > 1) || (i < 50))) {
          break;
        }
        if (!((o.num > 2) || (i < 120))) {
          break;
        }
        if ((o != null ? o.data : void 0) == null) {
          continue;
        }
        t_ = new Date().getTime();
        (yield this.filter({
          hash: f,
          data: o.data
        }));
        nt_ = new Date().getTime();
        console.log('refilter', i + "/" + filters.length, nt_ - t_, o.num);
        if (time < this.refilterTime) {
          return this.refiltering = false;
        }
        (yield Q.delay(nt_ - t_));
      }
      filters = filters.slice(i);
      for (i = l = 0, len1 = filters.length; l < len1; i = ++l) {
        f = filters[i];
        f = f[0];
        delete this.filters[f];
      }
      return this.refiltering = false;
    };

    Tutors.prototype.handler = function*($, arg) {
      var count, ex, exists, f, filter, from, i, inds, j, k, l, len, len1, len2, m, p, preps, ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7, ret;
      filter = arg.filter, preps = arg.preps, from = arg.from, count = arg.count, exists = arg.exists;
      return;
      if (this.inited !== 2) {
        (yield this.init());
      }
      ret = {};
      ret.preps = {};
      if (preps != null) {
        for (j = 0, len = preps.length; j < len; j++) {
          p = preps[j];
          ret.preps[p] = this.index[p];
        }
      }
      if (filter != null) {
        ex = {};
        for (l = 0, len1 = exists.length; l < len1; l++) {
          k = exists[l];
          ex[k] = true;
        }
        ret.filters = {};
        f = ret.filters[filter.hash] = {};
        if (((ref = this.filters) != null ? (ref1 = ref[filter.hash]) != null ? ref1.indexes : void 0 : void 0) == null) {
          (yield this.filter(filter, true));
        } else {
          if ((ref2 = this.filters) != null) {
            if ((ref3 = ref2[filter.hash]) != null) {
              ref3.num++;
            }
          }
        }
        f.indexes = (ref4 = (ref5 = this.filters) != null ? (ref6 = ref5[filter.hash]) != null ? ref6.indexes : void 0 : void 0) != null ? ref4 : [];
        if (count == null) {
          count = 10;
        }
        if (from != null) {
          inds = f != null ? (ref7 = f.indexes) != null ? typeof ref7.slice === "function" ? ref7.slice(from, from + count) : void 0 : void 0 : void 0;
          for (m = 0, len2 = inds.length; m < len2; m++) {
            i = inds[m];
            if (!ex[i]) {
              ret.preps[i] = this.index[i];
            }
          }
        }
      }
      return ret;
    };

    Tutors.prototype.filter = function*(filter, inc) {
      var f, ref;
      if (inc == null) {
        inc = false;
      }
      f = (ref = this.filters[filter.hash]) != null ? ref : {};
      f.data = filter.data;
      if (f.num == null) {
        f.num = 0;
      }
      if (inc) {
        f.num++;
      }
      delete f.redis;
      f.indexes = (yield _filter.filter(this.persons, filter.data));
      this.filters[filter.hash] = f;
      this.filterChange = true;
      return f;
    };

    Tutors.prototype.reload = function() {
      return _reload.apply(this);
    };

    return Tutors;

  })();

  tutors = new Tutors;

  module.exports = tutors;

}).call(this);
