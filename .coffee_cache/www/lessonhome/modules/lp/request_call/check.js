(function() {
  this.getPhone = (function(_this) {
    return function(phone) {
      return _this.getText(phone).replace(/^\+7/, '8').replace(/[^\d]/g, '');
    };
  })(this);

  this.getText = (function(_this) {
    return function(text) {
      return text.replace(/^\s+/g, '').replace(/\s+$/g, '');
    };
  })(this);

  this.check = (function(_this) {
    return function(f) {
      var errs, name, phone, ref;
      phone = _this.getPhone(f.tel_number);
      name = _this.getText(f.your_name);
      errs = [];
      if (f.your_name.length === 0 || name.length === 0) {
        errs.push('empty_name');
      }
      if (f.tel_number.length === 0 || phone.length === 0) {
        errs.push('empty_phone');
      }
      if ((f.tel_number.length > 0 && phone.length === 0) || (0 < (ref = phone.length) && ref < 10)) {
        errs.push('wrong_phone');
      }
      return errs;
    };
  })(this);

}).call(this);
