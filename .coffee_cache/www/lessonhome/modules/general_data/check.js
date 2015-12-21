(function() {
  this.check = (function(_this) {
    return function(f) {
      var errs, ref, ref1, ref2;
      errs = [];
      if ((0 < (ref = f.first_name.length) && ref < 2)) {
        errs.push("short_first_name");
      }
      if ((0 < (ref1 = f.last_name.length) && ref1 < 2)) {
        errs.push("short_last_name");
      }
      if ((0 < (ref2 = f.middle_name.length) && ref2 < 3)) {
        errs.push("short_middle_name");
      }
      if (f.first_name.length === 0) {
        errs.push("empty_first_name");
      }
      if (f.status.length === 0) {
        errs.push("empty_status");
      }
      if (!f.sex) {
        errs.push("unselect_sex");
      }
      if (f.day * 1 < 1 && f.day * 1 > 32) {
        errs.push("bad_day");
      }
      if (f.year * 1 < 1930 && f.day * 1 > 1997) {
        errs.push("bad_year");
      }
      return errs;
    };
  })(this);

}).call(this);
