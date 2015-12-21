(function() {
  var DbRead,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  DbRead = (function() {
    function DbRead() {
      this.getObjFromDb = bind(this.getObjFromDb, this);
      this.read = bind(this.read, this);
    }

    DbRead.prototype.read = function*($, fields) {
      var arr, base, bname, data, db, dbname, f, find, fname, i, j, key, len, o, obj, qs, ref, val;
      if (fields == null) {
        fields = $.form.fields;
      }
      this.dbs = {};
      for (j = 0, len = fields.length; j < len; j++) {
        f = fields[j];
        dbname = $.form.dbname(f);
        bname = $.form.toBName(f);
        if ((base = this.dbs)[dbname] == null) {
          base[dbname] = {};
        }
        this.dbs[dbname][bname] = 1;
      }
      find = $.find;
      qs = [];
      ref = this.dbs;
      for (db in ref) {
        arr = ref[db];
        qs.push(this.getObjFromDb($, db, find, arr));
      }
      qs = (yield Q.all(qs));
      obj = {};
      i = 0;
      for (db in this.dbs) {
        obj[db] = qs[i];
        i++;
      }
      data = {};
      for (db in obj) {
        o = obj[db];
        if (db === 'uploaded') {
          data.uploaded = o;
        } else {
          for (key in o) {
            val = o[key];
            fname = $.form.toFName(db, key);
            if (fname) {
              data[fname] = val;
            }
          }
        }
      }
      return data;
    };

    DbRead.prototype.getObjFromDb = function*($, bname, find, fields) {
      var _obj, cursor, db, item, j, len, obj;
      db = (yield $.db.get(bname));
      cursor = db.find(find, fields);
      obj = (yield _invoke(cursor, 'toArray'));
      cursor.close();
      if (obj.length === 1) {
        return obj[0];
      } else {
        _obj = {};
        for (j = 0, len = obj.length; j < len; j++) {
          item = obj[j];
          _obj[item.hash] = item;
        }
        return _obj;
      }
    };

    return DbRead;

  })();

  module.exports = DbRead;

}).call(this);
