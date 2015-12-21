(function() {
  this.atLeastAll = function(func) {
    var result;
    result = {
      correct: false,
      message: 'error'
    };
    return {
      some: function(data) {
        if (func(data) === true) {
          result.correct = true;
        }
        return true;
      },
      wait: function(message) {
        if (message != null) {
          result.message = message;
        }
        return function() {
          return result;
        };
      }
    };
  };

  this.isTrue = function(data) {
    if (data === true) {
      return true;
    } else {
      return false;
    }
  };

  this.isSelected = function(data) {
    if (data.selected === true) {
      return true;
    } else {
      return false;
    }
  };

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

  this.stud = this.atLeastAll(this.isTrue);

  this.place = this.atLeastAll(this.isSelected);

  this.pr = this.atLeastAll(this.isFill);

  this.required = function(data) {
    if (!data) {
      return 'empty_field';
    } else {
      return true;
    }
  };

  this.tag = function(data) {
    if (data.length > 285) {
      return 'long_tag';
    } else {
      return true;
    }
  };

  this.comments = function(data) {
    if (data.length > 30200) {
      return 'long_comments';
    } else {
      return true;
    }
  };

  this.price = function(data) {
    if (data > 99999) {
      return 'so_expensive';
    } else {
      return true;
    }
  };

  this.group_count = function(data) {
    if (data === '') {
      return 'select_group';
    } else {
      return true;
    }
  };

  this.isNormalTags = (function(_this) {
    return function(data) {
      var err, i, len, tag;
      if (data.length == null) {
        return 'not_tags';
      }
      if (typeof data === 'object') {
        if (data.length > 50) {
          return 'to_many_tags';
        }
        for (i = 0, len = data.length; i < len; i++) {
          tag = data[i];
          if (typeof tag !== 'string') {
            return 'not_tags';
          }
          err = _this.tag(tag);
          if (err !== true) {
            return err;
          }
        }
      } else if (typeof data === 'string') {
        return _this.tag(data);
      }
      return true;
    };
  })(this);

  this.time_prices = {
    one_hour: [this.pr.some, this.isInt, this.price],
    two_hour: [this.pr.some, this.isInt, this.price],
    tree_hour: [this.pr.some, this.isInt, this.price],
    prices: [this.pr.wait("not_fill_price")]
  };

  this.group = {
    price: [this.isInt, this.price],
    groups: [this.isString, this.group_count]
  };

  this.rules = {
    name: [this.required, this.isString],
    pre_school: [this.stud.some],
    junior_school: [this.stud.some],
    medium_school: [this.stud.some],
    high_school: [this.stud.some],
    student: [this.stud.some],
    adult: [this.stud.some],
    students: [this.stud.wait('not_select_stud')],
    course: [this.isNormalTags],
    place_tutor: [this.place.some, this.isSelected, this.time_prices],
    place_pupil: [this.place.some, this.isSelected, this.time_prices],
    place_remote: [this.place.some, this.isSelected, this.time_prices],
    group_learning: [this.isSelected, this.group],
    places: [this.place.wait('not_select_place')],
    comments: [this.isString, this.comments]
  };

  this.check_data = (function(_this) {
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
            _errors = _this.check_data(data[key], rule);
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

  this.check = (function(_this) {
    return function(data) {
      var error, errors, i, key, len, name, names, ref, sub_name, subject;
      names = [];
      errors = {
        correct: true,
        empty: "empty_subjects"
      };
      ref = data.subjects_val;
      for (key in ref) {
        subject = ref[key];
        if (errors['empty'] != null) {
          delete errors['empty'];
        }
        error = _this.check_data(subject);
        if (subject.name !== '') {
          sub_name = subject.name.toLowerCase();
          if (names.length === 0) {
            names.push(sub_name);
          } else {
            for (i = 0, len = names.length; i < len; i++) {
              name = names[i];
              if (name === sub_name) {
                if (error.correct) {
                  error.correct = false;
                }
                error.name = "match_name";
                break;
              } else {
                names.push(sub_name);
              }
            }
          }
        }
        if (!error.correct) {
          errors[key] = error;
          if (errors.correct) {
            errors.correct = false;
          }
        }
      }
      if (errors["empty"] != null) {
        errors["correct"] = false;
      }
      return errors;
    };
  })(this);

}).call(this);
