(function() {
  this.check = (function(_this) {
    return function(f) {
      var errs, p;
      errs = [];
      if (f.mobile_phone.length === 0) {
        errs.push("empty_mobile");
      } else {
        p = f.mobile_phone.replace(/\D/gmi, '');
        if (p.length < 7) {
          errs.push("bad_mobile");
        }
      }
      return errs;
    };
  })(this);

}).call(this);
