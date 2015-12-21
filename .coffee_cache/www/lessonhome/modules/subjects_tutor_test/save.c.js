(function() {
  var check, typetoteach;

  check = require("./check");

  typetoteach = {
    "school:0": 'pre_school',
    'school:1': 'junior_school',
    'school:2': 'medium_school',
    'school:3': 'high_school',
    'student': 'student',
    'adult': 'adult'
  };

  this.handler = (function(_this) {
    return function*($, data) {
      var base, base1, dataToSet, db, errs, i, j, key, len, place, ref, ref1, ref2, ref3, ref4, ref5, ref6, subject, subjects_db, tags, val;
      errs = check.check(data);
      if (!$.user.tutor) {
        return {
          status: "failed",
          errs: ["access_failed"]
        };
      }
      if (!errs.correct) {
        return {
          status: 'failed',
          errs: errs
        };
      }
      subjects_db = {};
      tags = {};
      ref = data.subjects_val;
      for (i in ref) {
        subject = ref[i];
        if (subject == null) {
          subject = {};
        }
        subjects_db[i] = {};
        subjects_db[i].name = subject != null ? subject.name : void 0;
        subjects_db[i].description = subject.comments;
        if (typeof subject.course === 'string') {
          subject.course = {
            0: subject.course
          };
        }
        if (!((subject != null ? subject.course : void 0) || (typeof subject.course === 'object'))) {
          subject.course = {};
        }
        if ((base = subjects_db[i]).tags == null) {
          base.tags = {};
        }
        ref1 = subject.course;
        for (key in ref1) {
          val = ref1[key];
          subjects_db[i].tags[val] = 1.0;
        }
        subjects_db[i].course = subject.course;
        for (key in typetoteach) {
          val = typetoteach[key];
          subjects_db[i].tags[key] = subject[val] ? true : false;
        }
        subjects_db[i].tags[subject.name] = true;
        if ((base1 = subjects_db[i]).place == null) {
          base1.place = [];
        }
        if (subject.place_tutor.selected) {
          subjects_db[i].place.push("tutor");
        }
        if (subject.place_pupil.selected) {
          subjects_db[i].place.push("pupil");
        }
        if (subject.place_remote.selected) {
          subjects_db[i].place.push("remote");
        }
        subjects_db[i].place_prices = {};
        ref2 = subjects_db[i].place;
        for (j = 0, len = ref2.length; j < len; j++) {
          place = ref2[j];
          subjects_db[i].place_prices[place] = [(ref3 = subject['place_' + place]) != null ? ref3.one_hour : void 0, (ref4 = subject['place_' + place]) != null ? ref4.two_hour : void 0, (ref5 = subject['place_' + place]) != null ? ref5.tree_hour : void 0];
        }
        if (subject.group_learning.selected && subject.group_learning.groups !== '') {
          subjects_db[i].groups = [
            {
              description: subject.group_learning.groups,
              price: subject.group_learning.price
            }
          ];
        }
        ref6 = subjects_db[i].tags;
        for (key in ref6) {
          val = ref6[key];
          tags[key] = val;
        }
      }
      db = (yield $.db.get('tutor'));
      dataToSet = {};
      for (key in tags) {
        val = tags[key];
        if (key) {
          dataToSet['tags.' + key] = val;
        }
      }
      dataToSet.subjects = subjects_db;
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: dataToSet
      }, {
        upsert: true
      }));
      (yield $.status('tutor_prereg_3', true));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
