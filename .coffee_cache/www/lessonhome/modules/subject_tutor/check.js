(function() {
  this.check = (function(_this) {
    return function(data) {
      var active, errs, i, ref, subject;
      errs = [];
      ref = data.subjects_val;
      for (i in ref) {
        subject = ref[i];
        if (subject.duration.length < 1) {
          errs.push({
            "short_duration": i
          });
        }
        if (subject.duration.length > 100) {
          errs.push({
            "long_duration": i
          });
        }
        if (subject.duration.length === 0) {
          errs.push({
            "empty_duration": i
          });
        }
        if (subject.group_learning.length === 0) {
          errs.push({
            "empty_group_learning": i
          });
        }
        active = false;

        /*
        for val in subject.categories_of_students
          console.log 'val :'
          console.log val
          if val
            active = true
        if !active
          errs.push "empty_categories_of_students":i
        active = false
        for val in subject.place
          if val
            active = true
        if !active
          errs.push "empty_place":i
         */
      }
      return errs;
    };
  })(this);

}).call(this);
