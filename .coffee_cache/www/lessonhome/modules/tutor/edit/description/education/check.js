(function() {
  this.isFill = function(data) {
    if (data !== '') {
      return true;
    } else {
      return false;
    }
  };

  this.isString = function(data) {
    if (typeof data !== 'string') {
      return 'not_string';
    } else {
      return true;
    }
  };

  this.isInt = function(data) {
    if (data !== '' && isNaN(+data)) {
      return 'not_int';
    } else {
      return true;
    }
  };

  this.required = function(data) {
    if (!data) {
      return 'empty_field';
    } else {
      return true;
    }
  };

  this.period = {
    start: [this.isFill, this.isInt],
    end: [this.isFill, this.isInt]
  };

  this.rules = {
    name: [this.required, this.isString],
    faculty: [this.isFill, this.isString],
    country: [this.isFill, this.isString],
    city: [this.isFill, this.isString],
    chair: [this.isFill, this.isString],
    qualification: [this.isFill, this.isString],
    comment: [this.isFill, this.isString],
    period: [this.period]
  };

  this.check_data = (function(_this) {
    return function(data, rules) {
      var _errors, elem, errors, j, key, len, result, rule, wait;
      if (rules == null) {
        rules = _this.rules;
      }
      errors = {
        correct: true
      };
      wait = {};
      for (key in rules) {
        elem = rules[key];
        for (j = 0, len = elem.length; j < len; j++) {
          rule = elem[j];
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
            _errors = _this.check_data(data[key], rule);
            if (_errors.correct === false) {
              errors[key] = _errors;
              errors.correct = false;
            }
          }
        }
      }
      return errors;
    };
  })(this);

  this.check = (function(_this) {
    return function(data) {
      var error, errors, exist, i, j, len, v;
      exist = {};
      errors = {
        correct: true
      };
      for (i = j = 0, len = data.length; j < len; i = ++j) {
        v = data[i];
        error = _this.check_data(v);
        if (error.correct === false) {
          errors.correct = false;
          errors[i] = error;
        }
      }
      return errors;
    };
  })(this);

}).call(this);
