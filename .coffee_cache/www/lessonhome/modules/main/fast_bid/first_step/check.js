(function() {
  this.check = (function(_this) {
    return function(f) {
      var errs, ref;
      errs = [];
      if ((0 < (ref = f.phone.length) && ref < 10)) {
        errs.push("short_phone");
      }
      if (f.phone.length === 0) {
        errs.push("empty_phone");
      }
      return errs;
    };
  })(this);

}).call(this);
