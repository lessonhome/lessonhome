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
      var base, base1, dataToSet, db, errs, i, key, price_range, ref, ref1, ref2, ref3, ref4, subject, subjects_db, tags, val;
      errs = check.check(data);
      if (!$.user.tutor) {
        return {
          status: "failed",
          errs: ["access_failed"]
        };
      }
      if (errs != null ? errs.length : void 0) {
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
        price_range = [];
        price_range.push(subject.price_from);
        price_range.push(subject.price_till);
        subjects_db[i].price = {};
        subjects_db[i].price.range = price_range;
        subjects_db[i].price.duration = {
          left: +(subject != null ? (ref2 = subject.duration) != null ? ref2.left : void 0 : void 0),
          right: +(subject != null ? (ref3 = subject.duration) != null ? ref3.right : void 0 : void 0)
        };
        if ((base1 = subjects_db[i]).place == null) {
          base1.place = [];
        }
        if (subject.place_tutor) {
          subjects_db[i].place.push("tutor");
        }
        if (subject.place_pupil) {
          subjects_db[i].place.push("pupil");
        }
        if (subject.place_remote) {
          subjects_db[i].place.push("remote");
        }
        if (subject.place_cafe) {
          subjects_db[i].place.push("other");
        }
        subjects_db[i].groups = [
          {
            description: subject.group_learning
          }
        ];
        ref4 = subjects_db[i].tags;
        for (key in ref4) {
          val = ref4[key];
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
      console.log(dataToSet);
      (yield $.status('tutor_prereg_3', true));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
