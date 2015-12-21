(function() {
  this.form = ['name', 'phone', 'linked', 'id', 'comment', 'comments', 'gender', 'experience', 'place', ['calendar', ['11', '12', '13', '21', '22', '23', '31', '32', '33', '41', '42', '43', '51', '52', '53', '61', '62', '63', '71', '72', '73']], ['status', ['high_school_teacher', 'native_speaker', 'school_teacher', 'student']], ['price', ['left', 'right']], ['duration', ['left', 'right']], 'subject', 'email'];

  this.takeData = (function(_this) {
    return function(data, form) {
      var i, key, len, result;
      if (form == null) {
        form = _this.form;
      }
      result = {};
      for (i = 0, len = form.length; i < len; i++) {
        key = form[i];
        if (typeof key === 'string' && (data[key] != null)) {
          result[key] = data[key];
        } else if (typeof key === 'object' && (data[key[0]] != null)) {
          result[key[0]] = _this.takeData(data[key[0]], key[1]);
        }
      }
      return result;
    };
  })(this);

  this.isBool = function(data) {
    if (typeof data !== 'boolean') {
      return "not_bool";
    } else {
      return true;
    }
  };

  this.boolAll = (function(_this) {
    return function(data) {
      var key, value;
      for (key in data) {
        value = data[key];
        if (_this.isBool(value) !== true) {
          return 'wrong_type';
        }
      }
      return true;
    };
  })(this);

  this.isString = function(data) {
    if (typeof data !== 'string') {
      return 'not_string';
    } else {
      return true;
    }
  };

  this.isInt = function(data) {
    if (data !== '' && isNaN(parseInt(data))) {
      return 'not_int';
    } else {
      return true;
    }
  };

  this.required = function(data) {
    if (data === void 0 || data === '') {
      return 'empty_field';
    }
    return true;
  };

  this.correctName = function(data) {
    var reg;
    if (data === '') {
      return true;
    }
    reg = /^[_a-zA-Z0-9а-яА-ЯёЁ ]{1,35}$/;
    if (reg.test(data)) {
      return true;
    } else {
      return 'wrong_name';
    }
  };

  this.isPhone = function(data) {
    var ref;
    if (data === '') {
      return true;
    }
    if ((7 <= (ref = data.replace(/\D/g, '').length) && ref <= 13)) {
      return true;
    }
    return 'wrong_phone';
  };

  this.isEmail = function(data) {
    var reg;
    if (data === '') {
      return true;
    }
    reg = /^\w+@\w+\.\w+$/;
    if (reg.test(data)) {
      return true;
    } else {
      return 'wrong_email';
    }
  };

  this.left_right = {
    left: [this.isInt],
    right: [this.isInt]
  };

  this.rules = {
    gender: [this.isString],
    experience: [this.isString],
    price: [this.left_right],
    duration: [this.left_right],
    subject: [this.isString],
    email: [this.isString, this.isEmail],
    phone: [this.required, this.isString, this.isPhone],
    name: [this.isString, this.correctName],
    status: [this.boolAll],
    linked: [this.boolAll],
    calendar: [this.boolAll],
    place: [this.boolAll]
  };

  this.check = (function(_this) {
    return function(data, rules) {
      var _errors, elem, errors, i, key, len, result, rule, wait;
      if (rules == null) {
        rules = _this.rules;
      }
      errors = {
        correct: true
      };
      wait = {};
      for (key in rules) {
        elem = rules[key];
        for (i = 0, len = elem.length; i < len; i++) {
          rule = elem[i];
          if (typeof rule === 'function') {
            result = rule(data[key]);
            if (result === true) {
              continue;
            }
            if (result === false) {
              break;
            }
            if (typeof result === 'string') {
              errors[key] = result;
              errors.correct = false;
              break;
            }
            if (typeof result === 'object') {
              wait[key] = result;
            }
          }
          if (typeof rule === 'object') {
            _errors = _this.check(data[key], rule);
            if (_errors.correct === false) {
              errors[key] = _errors;
              errors.correct = false;
            }
          }
        }
      }
      for (key in wait) {
        result = wait[key];
        if (result.correct === false) {
          errors.correct = false;
          errors[key] = result.message;
        }
        result.correct = false;
      }
      return errors;
    };
  })(this);

}).call(this);
