(function() {
  this.check = (function(_this) {
    return function(f) {
      var active, errs, i, j, len, len1, ref, ref1, val;
      errs = [];
      if (f.duration.length < 1) {
        errs.push("short_duration");
      }
      if (f.duration.length > 3) {
        errs.push("long_duration");
      }
      if (f.duration.length === 0) {
        errs.push("empty_duration");
      }
      if (f.course.length === 0) {
        errs.push("empty_course");
      }
      if (f.group_learning.length === 0) {
        errs.push("empty_group_learning");
      }
      active = false;
      ref = f.categories_of_students;
      for (i = 0, len = ref.length; i < len; i++) {
        val = ref[i];
        console.log('val :');
        console.log(val);
        if (val) {
          active = true;
        }
      }
      if (!active) {
        errs.push("empty_categories_of_students");
      }
      active = false;
      ref1 = f.place;
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        val = ref1[j];
        if (val) {
          active = true;
        }
      }
      if (!active) {
        errs.push("empty_place");
      }
      return errs;
    };
  })(this);

}).call(this);
