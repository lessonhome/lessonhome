(function() {
  var _numstr, boolSet, boolSetR, c, experience, gender, group_lessons, i, j, k, len, len1, numstr, place, pupil_status, ref, ref1, sort, tutor_status, tutor_status_text,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  tutor_status_text = {
    student: 'Cтудент',
    school_teacher: 'Преподаватель школы',
    university_teacher: 'Преподаватель ВУЗа',
    private_teacher: 'Частный преподаватель',
    native_speaker: 'Носитель языка'
  };

  group_lessons = ['не важно', '2-4 ученика', 'до 8 учеников', 'от 10 учеников'];

  pupil_status = ['не важно', 'дошкольники', 'начальная школа', 'средняя школа', 'старшая школа', 'студенты', 'взрослые'];

  sort = ['rating', 'price', 'experience', 'way_time', '-price', '-experience', '-rating', '-way_time', 'register', '-register', 'access', '-access'];

  gender = ['', 'male', 'female', 'mf'];

  tutor_status = 'student,school_teacher,university_teacher,private_teacher,native_speaker'.split(',');

  place = 'pupil,tutor,remote'.split(',');

  experience = 'little_experience,big_experience,bigger_experience'.split(',');

  numstr = {};

  _numstr = {};

  ref = 'opqmschjtui';
  for (i = j = 0, len = ref.length; j < len; i = ++j) {
    c = ref[i];
    _numstr[c] = i;
  }

  _numstr['i'] = '.';

  ref1 = 'opqmschjtui';
  for (i = k = 0, len1 = ref1.length; k < len1; i = ++k) {
    c = ref1[i];
    numstr[i] = c;
  }

  numstr['.'] = numstr[10];

  boolSet = (function(_this) {
    return function(obj, list) {
      var l, len2, s, v;
      list.sort();
      v = 0;
      i = 1;
      for (l = 0, len2 = list.length; l < len2; l++) {
        s = list[l];
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
      var l, len2, ret, s, v;
      list.sort();
      ret = {};
      v = obj != null ? obj : 0;
      for (l = 0, len2 = list.length; l < len2; l++) {
        s = list[l];
        ret[s] = (v % 2) === 1;
        v = Math.floor(v / 2);
      }
      return ret;
    };
  })(this);

  this.D2U = (function() {
    function D2U() {
      this.$showBy = bind(this.$showBy, this);
      this.$sort = bind(this.$sort, this);
      this.$course = bind(this.$course, this);
      this.$pupil_status = bind(this.$pupil_status, this);
      this.$group_lessons = bind(this.$group_lessons, this);
      this.$experience = bind(this.$experience, this);
      this.$time_spend_way = bind(this.$time_spend_way, this);
      this.$subject = bind(this.$subject, this);
      this.$place_attach = bind(this.$place_attach, this);
      this.$placeAreaTutor = bind(this.$placeAreaTutor, this);
      this.$placeAreaPupil = bind(this.$placeAreaPupil, this);
      this.$place = bind(this.$place, this);
      this.$tutor_status = bind(this.$tutor_status, this);
      this.$with_verification = bind(this.$with_verification, this);
      this.$with_photo = bind(this.$with_photo, this);
      this.$with_reviews = bind(this.$with_reviews, this);
      this.$gender = bind(this.$gender, this);
      this.$priceRight = bind(this.$priceRight, this);
      this.$priceLeft = bind(this.$priceLeft, this);
      this.$linked = bind(this.$linked, this);
      this.$test = bind(this.$test, this);
    }

    D2U.prototype.$test = function(obj) {
      return {
        type: 'int',
        value: obj != null ? obj.test : void 0,
        "default": 0
      };
    };

    D2U.prototype.$linked = function(obj) {
      var l, len2, ref2, ref3, ref4, str, str2;
      str = (ref2 = (ref3 = Object.keys((ref4 = obj != null ? obj.linked : void 0) != null ? ref4 : {})) != null ? typeof ref3.join === "function" ? ref3.join('.') : void 0 : void 0) != null ? ref2 : '';
      str2 = '';
      for (i = l = 0, len2 = str.length; l < len2; i = ++l) {
        c = str[i];
        str2 += numstr[c];
      }
      str = str2;
      return {
        type: 'string',
        value: str,
        "default": '',
        cookie: true
      };
    };

    D2U.prototype.$priceLeft = function(obj) {
      var ref2;
      return {
        type: 'int',
        value: obj != null ? (ref2 = obj.price) != null ? ref2.left : void 0 : void 0,
        "default": 500,
        filter: true
      };
    };

    D2U.prototype.$priceRight = function(obj) {
      var ref2;
      return {
        type: 'int',
        value: obj != null ? (ref2 = obj.price) != null ? ref2.right : void 0 : void 0,
        "default": 3500,
        filter: true
      };
    };

    D2U.prototype.$gender = function(obj) {
      i = gender.indexOf(obj != null ? obj.gender : void 0);
      if (!(i >= 0)) {
        i = void 0;
      }
      return {
        type: 'int',
        value: i,
        "default": 0,
        filter: true
      };
    };

    D2U.prototype.$with_reviews = function(obj) {
      return {
        type: 'bool',
        value: obj != null ? obj.with_reviews : void 0,
        "default": false,
        filter: true
      };
    };

    D2U.prototype.$with_photo = function(obj) {
      return {
        type: 'bool',
        value: obj != null ? obj.with_photo : void 0,
        "default": false,
        filter: true
      };
    };

    D2U.prototype.$with_verification = function(obj) {
      return {
        type: 'bool',
        value: obj != null ? obj.with_verification : void 0,
        "default": false,
        filter: true
      };
    };

    D2U.prototype.$tutor_status = function(obj) {
      return {
        type: 'int',
        value: boolSet(obj != null ? obj.tutor_status : void 0, tutor_status),
        "default": 0,
        filter: true
      };
    };

    D2U.prototype.$place = function(obj) {
      return {
        type: 'int',
        value: boolSet(obj != null ? obj.place : void 0, place),
        "default": 0,
        filter: true
      };
    };

    D2U.prototype.$placeAreaPupil = function(obj) {
      var ref2;
      return {
        type: 'string[]',
        value: obj != null ? (ref2 = obj.place) != null ? ref2.area_pupil : void 0 : void 0,
        "default": '',
        filter: true
      };
    };

    D2U.prototype.$placeAreaTutor = function(obj) {
      var ref2;
      return {
        type: 'string[]',
        value: obj != null ? (ref2 = obj.place) != null ? ref2.area_tutor : void 0 : void 0,
        "default": '',
        filter: true
      };
    };

    D2U.prototype.$place_attach = function(obj) {
      return {
        type: 'int',
        value: boolSet(obj != null ? obj.place_attach : void 0, place),
        "default": 0,
        cookie: true
      };
    };

    D2U.prototype.$subject = function(obj) {
      return {
        type: 'string[]',
        value: obj != null ? obj.subject : void 0,
        "default": '',
        filter: true
      };
    };

    D2U.prototype.$time_spend_way = function(obj) {
      return {
        type: 'int',
        value: obj != null ? obj.time_spend_way : void 0,
        "default": 120,
        filter: true
      };
    };

    D2U.prototype.$experience = function(obj) {
      return {
        type: 'int',
        value: boolSet(obj != null ? obj.experience : void 0, experience),
        "default": 0,
        filter: true
      };
    };

    D2U.prototype.$group_lessons = function(obj) {
      var v;
      v = group_lessons.indexOf(obj != null ? obj.group_lessons : void 0);
      if (!(v >= 0)) {
        v = 0;
      }
      return {
        type: 'int',
        value: v,
        "default": 0,
        filter: true
      };
    };

    D2U.prototype.$pupil_status = function(obj) {
      var v;
      v = pupil_status.indexOf(obj != null ? obj.pupil_status : void 0);
      if (!(v >= 0)) {
        v = 0;
      }
      return {
        type: 'int',
        value: v,
        "default": 0,
        filter: true
      };
    };

    D2U.prototype.$course = function(obj) {
      return {
        type: 'string[]',
        value: obj != null ? obj.course : void 0,
        "default": '',
        filter: true
      };
    };

    D2U.prototype.$sort = function(obj) {
      var v;
      v = sort.indexOf(obj != null ? obj.sort : void 0);
      if (!(v >= 0)) {
        v = 0;
      }
      return {
        type: 'int',
        value: v,
        "default": 0,
        filter: true,
        cookie: false
      };
    };

    D2U.prototype.$showBy = function(obj) {
      return {
        type: 'bool',
        value: (obj != null ? obj.showBy : void 0) === 'list',
        "default": true,
        cookie: false
      };
    };

    return D2U;

  })();

  this.U2D = (function() {
    function U2D() {
      this.$course = bind(this.$course, this);
      this.$showBy = bind(this.$showBy, this);
      this.$sort = bind(this.$sort, this);
      this.$pupil_status = bind(this.$pupil_status, this);
      this.$group_lessons = bind(this.$group_lessons, this);
      this.$experience = bind(this.$experience, this);
      this.$time_spend_way = bind(this.$time_spend_way, this);
      this.$subject = bind(this.$subject, this);
      this.$place_attach = bind(this.$place_attach, this);
      this.$place = bind(this.$place, this);
      this.$tutor_status_text = bind(this.$tutor_status_text, this);
      this.$tutor_status = bind(this.$tutor_status, this);
      this.$with_verification = bind(this.$with_verification, this);
      this.$with_photo = bind(this.$with_photo, this);
      this.$with_reviews = bind(this.$with_reviews, this);
      this.$gender = bind(this.$gender, this);
      this.$price = bind(this.$price, this);
      this.$linked = bind(this.$linked, this);
      this.$test = bind(this.$test, this);
    }

    U2D.prototype.$test = function(obj) {
      return obj != null ? obj.test : void 0;
    };

    U2D.prototype.$linked = function(obj) {
      var a, arr, l, len2, len3, m, ref2, str, str2;
      str = (ref2 = obj != null ? obj.linked : void 0) != null ? ref2 : '';
      str2 = '';
      for (i = l = 0, len2 = str.length; l < len2; i = ++l) {
        c = str[i];
        str2 += _numstr[c];
      }
      str = str2;
      arr = {};
      str = str.split('.');
      for (m = 0, len3 = str.length; m < len3; m++) {
        a = str[m];
        if ((+a) > 0) {
          arr[+a] = true;
        }
      }
      return arr;
    };

    U2D.prototype.$price = function(obj) {
      return {
        left: obj != null ? obj.priceLeft : void 0,
        right: obj != null ? obj.priceRight : void 0
      };
    };

    U2D.prototype.$gender = function(obj) {
      var ref2;
      return gender[(ref2 = obj != null ? obj.gender : void 0) != null ? ref2 : 0];
    };

    U2D.prototype.$with_reviews = function(obj) {
      return obj != null ? obj.with_reviews : void 0;
    };

    U2D.prototype.$with_photo = function(obj) {
      return obj != null ? obj.with_photo : void 0;
    };

    U2D.prototype.$with_verification = function(obj) {
      return obj != null ? obj.with_verification : void 0;
    };

    U2D.prototype.$tutor_status = function(obj) {
      return boolSetR(obj != null ? obj.tutor_status : void 0, tutor_status);
    };

    U2D.prototype.$tutor_status_text = function(obj) {
      var arr, arr2, key, ret, val;
      arr = boolSetR(obj != null ? obj.tutor_status : void 0, tutor_status);
      arr2 = [];
      for (key in arr) {
        val = arr[key];
        if (val) {
          arr2.push(tutor_status_text[key]);
        }
      }
      if (arr2.length <= 0) {
        return 'Статус репетитора';
      }
      arr2.sort((function(_this) {
        return function(a, b) {
          return a.length > b.length;
        };
      })(this));
      ret = arr2.join(', ');
      if (ret.length > 20) {
        ret = ret.substr(0, 20) + "...";
      }
      return ret;
    };

    U2D.prototype.$place = function(obj) {
      var ret;
      ret = boolSetR(obj != null ? obj.place : void 0, place);
      ret.area_pupil = obj != null ? obj.placeAreaPupil : void 0;
      ret.area_tutor = obj != null ? obj.placeAreaTutor : void 0;
      return ret;
    };

    U2D.prototype.$place_attach = function(obj) {
      return boolSetR(obj != null ? obj.place_attach : void 0, place);
    };

    U2D.prototype.$subject = function(obj) {
      return obj != null ? obj.subject : void 0;
    };

    U2D.prototype.$time_spend_way = function(obj) {
      return obj != null ? obj.time_spend_way : void 0;
    };

    U2D.prototype.$experience = function(obj) {
      return boolSetR(obj != null ? obj.experience : void 0, experience);
    };

    U2D.prototype.$group_lessons = function(obj) {
      var ref2;
      return group_lessons[(ref2 = obj != null ? obj.group_lessons : void 0) != null ? ref2 : 0];
    };

    U2D.prototype.$pupil_status = function(obj) {
      var ref2;
      return pupil_status[(ref2 = obj != null ? obj.pupil_status : void 0) != null ? ref2 : 0];
    };

    U2D.prototype.$sort = function(obj) {
      var ref2;
      return sort[(ref2 = obj != null ? obj.sort : void 0) != null ? ref2 : 0];
    };

    U2D.prototype.$showBy = function(obj) {
      if ((obj != null ? obj.showBy : void 0) === true) {
        return 'list';
      } else {
        return 'grid';
      }
    };

    U2D.prototype.$course = function(obj) {
      return obj != null ? obj.course : void 0;
    };

    return U2D;

  })();

}).call(this);
