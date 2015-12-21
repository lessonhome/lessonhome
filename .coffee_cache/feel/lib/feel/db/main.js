(function() {
  var Db,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Db = (function() {
    function Db() {
      this.close = bind(this.close, this);
      this.get = bind(this.get, this);
      this.connect = bind(this.connect, this);
      this.init = bind(this.init, this);
      Wrap(this);
      this.connections = {};
      this.connecting = {};
      this.user = "feel";
      this.password = "Avezila2734&";
    }

    Db.prototype.init = function() {};

    Db.prototype.connect = function(dbname) {
      var base, connecting, defer, url;
      if (this.client == null) {
        this.client = require('mongodb').MongoClient;
      }
      if (this.connections[dbname]) {
        return this.connections[dbname];
      }
      connecting = this.connecting[dbname] != null;
      if ((base = this.connecting)[dbname] == null) {
        base[dbname] = [];
      }
      defer = Q.defer();
      this.connecting[dbname].push(defer);
      if (connecting) {
        return defer.promise;
      }
      url = "mongodb://" + this.user + ":" + this.password + "@127.0.0.1:27081/" + dbname + "?wtimeoutMS=1000";
      this.client.connect(url, {
        uri_decode_auth: true
      }, (function(_this) {
        return function(err, db) {
          var i, j, len, len1, ref, ref1;
          if (err != null) {
            _this.error(err);
            ref = _this.connecting[dbname];
            for (i = 0, len = ref.length; i < len; i++) {
              defer = ref[i];
              defer.reject(err);
            }
          } else {
            _this.log(dbname);
            _this.connections[dbname] = db;
            ref1 = _this.connecting[dbname];
            for (j = 0, len1 = ref1.length; j < len1; j++) {
              defer = ref1[j];
              defer.resolve(db);
            }
          }
          return delete _this.connecting[dbname];
        };
      })(this));
      return defer.promise;
    };

    Db.prototype.get = function*(name) {
      var base, n;
      if (this.feel == null) {
        this.feel = (yield this.connect('feel'));
      }
      n = "_c_" + name;
      if ((base = this.get)[n] == null) {
        base[n] = this.feel.collection(name);
      }
      return this.get[n];
    };

    Db.prototype.close = function() {
      var connect, name, ref, results;
      ref = this.connections;
      results = [];
      for (name in ref) {
        connect = ref[name];
        results.push(connect.close());
      }
      return results;
    };

    return Db;

  })();

  module.exports = Db;

}).call(this);
