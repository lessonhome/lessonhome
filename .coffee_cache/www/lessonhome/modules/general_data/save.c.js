(function() {
  var check, status;

  check = require("./check");

  status = {
    'Студент': 'student',
    'Преподаватель школы': 'school_teacher',
    'Преподаватель ВУЗа': 'university_teacher',
    'Частный преподаватель': 'private_teacher',
    'Носитель языка': 'native_speaker'
  };

  this.handler = (function(_this) {
    return function*($, data) {
      var birthday, db, errs, month, ref;
      console.log(data);
      errs = check.check(data);
      if (!$.user.tutor) {
        return {
          status: "failed",
          errs: ["access_failed"]
        };
      }
      if (errs.length) {
        return {
          status: 'failed',
          errs: errs
        };
      }
      month = (yield _this.convertMonthToNumber(data.month));
      birthday = new Date(data.year, month, data.day);
      console.log(birthday, data.year, month, data.day);
      db = (yield $.db.get('persons'));
      console.log(data.status);
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          first_name: data.first_name,
          middle_name: data.middle_name,
          last_name: data.last_name,
          sex: data.sex,
          birthday: birthday
        }
      }, {
        upsert: true
      }));
      db = (yield $.db.get('tutor'));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          status: (ref = status[data != null ? data.status : void 0]) != null ? ref : "other"
        }
      }, {
        upsert: true
      }));
      (yield $.status('tutor_prereg_1', true));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

  this.convertMonthToNumber = (function(_this) {
    return function(month_str) {
      switch (month_str) {
        case 'январь':
          return 0;
        case 'февраль':
          return 1;
        case 'март':
          return 2;
        case 'апрель':
          return 3;
        case 'май':
          return 4;
        case 'июнь':
          return 5;
        case 'июль':
          return 6;
        case 'август':
          return 7;
        case 'сентябрь':
          return 8;
        case 'октябрь':
          return 9;
        case 'ноябрь':
          return 10;
        case 'декабрь':
          return 11;
      }
    };
  })(this);

}).call(this);
