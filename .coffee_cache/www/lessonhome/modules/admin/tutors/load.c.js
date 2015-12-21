(function() {
  var Admin,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Admin = (function() {
    function Admin() {
      this.reload = bind(this.reload, this);
      this.handler = bind(this.handler, this);
      this.init = bind(this.init, this);
      $W(this);
    }

    Admin.prototype.init = function*() {
      var e, error;
      this.ltime = 0;
      this.redis = (yield Main.service('redis'));
      this.redis = (yield this.redis.get());
      try {
        this.obj = JSON.parse((yield _invoke(this.redis, 'get', 'adminTutors')));
      } catch (error) {
        e = error;
        this.obj = void 0;
        console.error(e);
      }
      Q.spawn((function(_this) {
        return function*() {
          return (yield _this.reload());
        };
      })(this));
      return setInterval((function(_this) {
        return function() {
          return Q.spawn(function*() {
            return (yield _this.reload());
          });
        };
      })(this), 15 * 60 * 1000);
    };

    Admin.prototype.handler = function*($, data) {
      if (data != null ? data.fast : void 0) {
        if (this.obj) {
          return this.obj;
        }
      }
      if (this.obj && (new Date().getTime() - this.ltime) < 15 * 1000) {
        return this.obj;
      }
      (yield this.reload($, data));
      return this.obj;
    };

    Admin.prototype.reload = function*() {
      var accounts, backcall, bids, bytime, dbAccounts, dbBackcall, dbBids, dbPersons, dbTutor, nosubject, ref;
      ref = (yield Q.all([this.$db.get('backcall'), this.$db.get('persons'), this.$db.get('accounts'), this.$db.get('tutor'), this.$db.get('bids')])), dbBackcall = ref[0], dbPersons = ref[1], dbAccounts = ref[2], dbTutor = ref[3], dbBids = ref[4];
      backcall = null;
      accounts = null;
      bytime = null;
      nosubject = null;
      bids = null;
      (yield Q.all([
        Q.async((function(_this) {
          return function*() {
            var b, bc, i, j, len, len1, obj, ref1, ref2, ref3, ref4, ref5, ref6, results;
            bc = (yield _invoke(dbBackcall.find({
              time: {
                $exists: true
              }
            }).sort({
              time: -1
            }), 'toArray'));
            backcall = [];
            for (i = 0, len = bc.length; i < len; i++) {
              b = bc[i];
              obj = {};
              obj.id = b.account;
              obj.backcall = {
                name: b.name,
                phone: b.phone,
                comment: b.comment,
                type: b.type,
                time: b.time
              };
              obj.account = _invoke(dbAccounts.find({
                id: obj.id
              }), 'toArray');
              obj.person = _invoke(dbPersons.find({
                account: obj.id
              }), 'toArray');
              obj.tutor = _invoke(dbTutor.find({
                account: obj.id
              }), 'toArray');
              backcall.push(obj);
            }
            results = [];
            for (j = 0, len1 = backcall.length; j < len1; j++) {
              obj = backcall[j];
              obj.account = (ref1 = (ref2 = (yield obj.account)) != null ? ref2[0] : void 0) != null ? ref1 : {};
              obj.person = (ref3 = (ref4 = (yield obj.person)) != null ? ref4[0] : void 0) != null ? ref3 : {};
              results.push(obj.tutor = (ref5 = (ref6 = (yield obj.tutor)) != null ? ref6[0] : void 0) != null ? ref5 : {});
            }
            return results;
          };
        })(this))(), Q.async((function(_this) {
          return function*() {
            var a, accs, i, j, key, len, len1, nophotos, p, results, val;
            nophotos = (yield _invoke(dbPersons.find({
              hidden: {
                $ne: true
              },
              'avatar.0': {
                $exists: false
              }
            }, {
              avatar: 1,
              account: 1,
              first_name: 1,
              middle_name: 1,
              last_name: 1,
              email: 1,
              phone: 1
            }), 'toArray'));
            accs = [];
            for (i = 0, len = nophotos.length; i < len; i++) {
              p = nophotos[i];
              accs.push(p.account);
              nophotos[p.account] = p;
            }
            accounts = (yield _invoke(dbAccounts.find({
              id: {
                $in: accs
              }
            }, {
              id: 1,
              login: true,
              index: 1
            }).sort({
              registerTime: -1
            }), 'toArray'));
            results = [];
            for (j = 0, len1 = accounts.length; j < len1; j++) {
              a = accounts[j];
              p = nophotos[a.id];
              results.push((function() {
                var results1;
                results1 = [];
                for (key in p) {
                  val = p[key];
                  results1.push(a[key] = val);
                }
                return results1;
              })());
            }
            return results;
          };
        })(this))(), Q.async((function(_this) {
          return function*() {
            var a, i, j, len, len1, ref1, ref2, results;
            bytime = (yield _invoke(dbAccounts.find({
              login: {
                $exists: true
              }
            }, {
              id: 1,
              accessTime: 1,
              login: 1,
              index: 1
            }).sort({
              accessTime: -1
            }).limit(100), 'toArray'));
            for (i = 0, len = bytime.length; i < len; i++) {
              a = bytime[i];
              a.person = _invoke(dbPersons.find({
                account: a.id
              }), 'toArray');
            }
            results = [];
            for (j = 0, len1 = bytime.length; j < len1; j++) {
              a = bytime[j];
              results.push(a.person = (ref1 = (ref2 = (yield a.person)) != null ? ref2[0] : void 0) != null ? ref1 : {});
            }
            return results;
          };
        })(this))(), Q.async((function(_this) {
          return function*() {
            var a, accs, i, j, len, len1, newaccs;
            accs = (yield _invoke(dbAccounts.find({
              login: {
                $exists: true
              }
            }, {
              id: 1,
              login: 1,
              index: 1
            }).sort({
              registerTime: -1
            }), 'toArray'));
            newaccs = {};
            for (i = 0, len = accs.length; i < len; i++) {
              a = accs[i];
              newaccs[a.id] = a;
            }
            nosubject = (yield _invoke(dbTutor.find({
              'subjects.0.name': {
                $exists: true
              }
            }, {
              account: 1
            }), 'toArray'));
            for (j = 0, len1 = nosubject.length; j < len1; j++) {
              a = nosubject[j];
              delete newaccs[a.account];
            }
            return nosubject = newaccs;
          };
        })(this))(), Q.async((function(_this) {
          return function*() {
            return bids = (yield _invoke(dbBids.find({
              time: {
                $exists: true
              }
            }).sort({
              time: -1
            }), 'toArray'));
          };
        })(this))()
      ]));
      this.obj = {
        backcall: backcall,
        nophotos: accounts,
        time: bytime,
        nosubject: nosubject,
        bids: bids
      };
      Q.spawn((function(_this) {
        return function*() {
          return (yield _invoke(_this.redis, 'set', 'adminTutors', JSON.stringify(_this.obj)));
        };
      })(this));
      this.ltime = new Date().getTime();
      return this.obj;
    };

    return Admin;

  })();

  module.exports = new Admin;

}).call(this);
