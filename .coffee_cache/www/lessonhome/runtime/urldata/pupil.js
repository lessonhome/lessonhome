(function() {
  var boolSet, boolSetR, calendar, i, j, k, l, status,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  calendar = [];

  for (i = k = 1; k <= 7; i = ++k) {
    for (j = l = 1; l <= 3; j = ++l) {
      calendar.push('' + i + j);
    }
  }

  boolSet = (function(_this) {
    return function(obj, list) {
      var len, m, s, v;
      list.sort();
      v = 0;
      i = 1;
      for (m = 0, len = list.length; m < len; m++) {
        s = list[m];
        if (obj != null ? obj[s] : void 0) {
          v += i;
        }
        i *= 2;
      }
      return v;
    };
  })(this);

  boolSetR = (function(_this) {
    return function(obj, list) {
      var len, m, ret, s, v;
      list.sort();
      ret = {};
      v = obj != null ? obj : 0;
      for (m = 0, len = list.length; m < len; m++) {
        s = list[m];
        ret[s] = (v % 2) === 1;
        v = Math.floor(v / 2);
      }
      return ret;
    };
  })(this);

  status = ['student', 'school_teacher', 'high_school_teacher', 'native_speaker'];

  this.D2U = (function() {
    function D2U() {
      this.$gender = bind(this.$gender, this);
      this.$experience = bind(this.$experience, this);
      this.$status = bind(this.$status, this);
      this.$price_right = bind(this.$price_right, this);
      this.$price_left = bind(this.$price_left, this);
      this.$duration_right = bind(this.$duration_right, this);
      this.$duration_left = bind(this.$duration_left, this);
      this.$calendar = bind(this.$calendar, this);
      this.$subject_comment = bind(this.$subject_comment, this);
      this.$subject = bind(this.$subject, this);
      this.$email = bind(this.$email, this);
      this.$phone_comment = bind(this.$phone_comment, this);
      this.$phone = bind(this.$phone, this);
      this.$name = bind(this.$name, this);
    }

    D2U.prototype.$name = function(obj) {
      return {
        type: 'string',
        "default": '',
        value: obj != null ? obj.name : void 0,
        cookie: true
      };
    };

    D2U.prototype.$phone = function(obj) {
      return {
        type: 'string',
        "default": '',
        value: obj != null ? obj.phone : void 0,
        cookie: true
      };
    };

    D2U.prototype.$phone_comment = function(obj) {
      return {
        type: 'string',
        "default": '',
        value: obj != null ? obj.phone_comment : void 0,
        cookie: true
      };
    };

    D2U.prototype.$email = function(obj) {
      return {
        type: 'string',
        "default": '',
        value: obj != null ? obj.email : void 0,
        cookie: true
      };
    };

    D2U.prototype.$subject = function(obj) {
      return {
        type: 'string',
        "default": '',
        value: obj != null ? obj.subject : void 0,
        cookie: true
      };
    };

    D2U.prototype.$subject_comment = function(obj) {
      return {
        type: 'string',
        "default": '',
        value: obj != null ? obj.subject_comment : void 0,
        cookie: true
      };
    };

    D2U.prototype.$calendar = function(obj) {
      return {
        type: 'int',
        "default": 0,
        value: boolSet(obj != null ? obj.calendar : void 0, calendar),
        cookie: true
      };
    };

    D2U.prototype.$duration_left = function(obj) {
      var ref;
      return {
        type: 'int',
        "default": 30,
        value: obj != null ? (ref = obj.duration) != null ? ref.left : void 0 : void 0,
        cookie: true
      };
    };

    D2U.prototype.$duration_right = function(obj) {
      var ref;
      return {
        type: 'int',
        "default": 240,
        value: obj != null ? (ref = obj.duration) != null ? ref.right : void 0 : void 0,
        cookie: true
      };
    };

    D2U.prototype.$price_left = function(obj) {
      var ref;
      return {
        type: 'int',
        "default": 400,
        value: obj != null ? (ref = obj.price) != null ? ref.left : void 0 : void 0,
        cookie: true
      };
    };

    D2U.prototype.$price_right = function(obj) {
      var ref;
      return {
        type: 'int',
        "default": 5000,
        value: obj != null ? (ref = obj.price) != null ? ref.right : void 0 : void 0,
        cookie: true
      };
    };

    D2U.prototype.$status = function(obj) {
      return {
        type: 'int',
        "default": 0,
        value: boolSet(obj != null ? obj.status : void 0, status),
        cookie: true
      };
    };

    D2U.prototype.$experience = function(obj) {
      return {
        type: 'string',
        "default": 'неважно',
        value: obj != null ? obj.experience : void 0,
        cookie: true
      };
    };

    D2U.prototype.$gender = function(obj) {
      return {
        type: 'string',
        "default": 'неважно',
        value: obj != null ? obj.gender : void 0,
        cookie: true
      };
    };

    return D2U;

  })();

  this.U2D = (function() {
    function U2D() {
      this.$gender = bind(this.$gender, this);
      this.$experience = bind(this.$experience, this);
      this.$status = bind(this.$status, this);
      this.$price = bind(this.$price, this);
      this.$duration = bind(this.$duration, this);
      this.$calendar = bind(this.$calendar, this);
      this.$subject_comment = bind(this.$subject_comment, this);
      this.$subject = bind(this.$subject, this);
      this.$email = bind(this.$email, this);
      this.$phone_comment = bind(this.$phone_comment, this);
      this.$phone = bind(this.$phone, this);
      this.$name = bind(this.$name, this);
    }

    U2D.prototype.$name = function(obj) {
      return obj != null ? obj.name : void 0;
    };

    U2D.prototype.$phone = function(obj) {
      return obj != null ? obj.phone : void 0;
    };

    U2D.prototype.$phone_comment = function(obj) {
      return obj != null ? obj.phone_comment : void 0;
    };

    U2D.prototype.$email = function(obj) {
      return obj != null ? obj.email : void 0;
    };

    U2D.prototype.$subject = function(obj) {
      return obj != null ? obj.subject : void 0;
    };

    U2D.prototype.$subject_comment = function(obj) {
      return obj != null ? obj.subject_comment : void 0;
    };

    U2D.prototype.$calendar = function(obj) {
      return boolSetR(obj != null ? obj.calendar : void 0, calendar);
    };

    U2D.prototype.$duration = function(obj) {
      return {
        left: obj != null ? obj.duration_left : void 0,
        right: obj != null ? obj.duration_right : void 0
      };
    };

    U2D.prototype.$price = function(obj) {
      return {
        left: obj != null ? obj.price_left : void 0,
        right: obj != null ? obj.price_right : void 0
      };
    };

    U2D.prototype.$status = function(obj) {
      return boolSetR(obj != null ? obj.status : void 0, status);
    };

    U2D.prototype.$experience = function(obj) {
      return obj != null ? obj.experience : void 0;
    };

    U2D.prototype.$gender = function(obj) {
      return obj != null ? obj.gender : void 0;
    };

    return U2D;

  })();

}).call(this);
