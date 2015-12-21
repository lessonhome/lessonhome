(function() {
  var _course, _price, _sex, _status, _subjects, aToI, aToS, bToO, iToA, oToB, sToA,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _subjects = Feel["const"]('filter').subjects;

  _course = Feel["const"]('filter').course;

  _price = Feel["const"]('filter').price;

  _status = Feel["const"]('filter').status;

  _sex = Feel["const"]('filter').sex;

  aToS = function(obj, arr) {
    var a, i, j, k, key, len, len1, o, s, val;
    if (obj == null) {
      obj = {};
    }
    if (arr == null) {
      arr = {};
    }
    if (arr.length) {
      for (j = 0, len = arr.length; j < len; j++) {
        a = arr[j];
        arr[a] = true;
      }
    }
    s = '';
    i = 0;
    for (key in obj) {
      o = obj[key];
      for (k = 0, len1 = o.length; k < len1; k++) {
        val = o[k];
        if (arr[val]) {
          delete arr[val];
          if (s) {
            s += ',';
          }
          s += i;
        }
        i++;
      }
    }
    return s;
  };

  sToA = function(obj, str) {
    var arr, i, j, k, key, len, len1, o, s, str2, val;
    if (obj == null) {
      obj = {};
    }
    if (str == null) {
      str = '';
    }
    str = str || '';
    str = str.split(',');
    str2 = {};
    for (j = 0, len = str.length; j < len; j++) {
      s = str[j];
      str2[s] = true;
    }
    arr = [];
    i = 0;
    for (key in obj) {
      o = obj[key];
      for (k = 0, len1 = o.length; k < len1; k++) {
        val = o[k];
        if (str2[i]) {
          arr.push(val);
        }
        i++;
      }
    }
    return arr;
  };

  oToB = function(all, selected) {
    var i, it, j, len, ret;
    if (all == null) {
      all = [];
    }
    if (selected == null) {
      selected = {};
    }
    ret = 0;
    i = 1;
    for (j = 0, len = all.length; j < len; j++) {
      it = all[j];
      if (selected[it]) {
        ret += i;
      }
      i *= 2;
    }
    return ret;
  };

  bToO = function(all, bool) {
    var c, i, selected;
    if (all == null) {
      all = [];
    }
    if (bool == null) {
      bool = 0;
    }
    selected = {};
    i = 0;
    while (bool) {
      c = bool % 2;
      bool = Math.floor(bool / 2);
      selected[all[i]] = c === 1;
      i++;
    }
    return selected;
  };

  aToI = (function(_this) {
    return function(all, selected) {
      if (all == null) {
        all = [];
      }
      return all.indexOf(selected);
    };
  })(this);

  iToA = (function(_this) {
    return function(all, i) {
      if (all == null) {
        all = [];
      }
      if (i == null) {
        i = 0;
      }
      return all[i];
    };
  })(this);

  this.D2U = (function() {
    function D2U() {
      this.$sex = bind(this.$sex, this);
      this.$status = bind(this.$status, this);
      this.$price = bind(this.$price, this);
      this.$course = bind(this.$course, this);
      this.$subjects = bind(this.$subjects, this);
    }

    D2U.prototype.$subjects = function(obj) {
      return {
        type: 'string',
        value: aToS(_subjects, obj != null ? obj.subjects : void 0),
        "default": '',
        tutorsFilter: true
      };
    };

    D2U.prototype.$course = function(obj) {
      return {
        type: 'string',
        value: aToS({
          obj: _course
        }, obj != null ? obj.course : void 0),
        "default": '',
        tutorsFitler: true
      };
    };

    D2U.prototype.$price = function(obj) {
      return {
        type: 'int',
        value: oToB(_price, obj != null ? obj.price : void 0),
        "default": 0,
        tutorsFilter: true
      };
    };

    D2U.prototype.$status = function(obj) {
      return {
        type: 'int',
        value: oToB(_status, obj != null ? obj.status : void 0),
        "default": 0,
        tutorsFilter: true
      };
    };

    D2U.prototype.$sex = function(obj) {
      return {
        type: 'int',
        value: aToI(_sex, obj != null ? obj.sex : void 0),
        "default": 0,
        tutorsFilter: true
      };
    };

    return D2U;

  })();

  this.U2D = (function() {
    function U2D() {
      this.$sex = bind(this.$sex, this);
      this.$status = bind(this.$status, this);
      this.$price = bind(this.$price, this);
      this.$course = bind(this.$course, this);
      this.$subjects = bind(this.$subjects, this);
    }

    U2D.prototype.$subjects = function(obj) {
      return sToA(_subjects, obj != null ? obj.subjects : void 0);
    };

    U2D.prototype.$course = function(obj) {
      return sToA({
        obj: _course
      }, obj != null ? obj.course : void 0);
    };

    U2D.prototype.$price = function(obj) {
      return bToO(_price, obj != null ? obj.price : void 0);
    };

    U2D.prototype.$status = function(obj) {
      return bToO(_status, obj != null ? obj.status : void 0);
    };

    U2D.prototype.$sex = function(obj) {
      return iToA(_sex, obj != null ? obj.sex : void 0);
    };

    return U2D;

  })();

}).call(this);
