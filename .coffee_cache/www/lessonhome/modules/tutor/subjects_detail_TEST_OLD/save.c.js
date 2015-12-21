(function() {
  var check;

  check = require("./check");

  this.handler = (function(_this) {
    return function*($, data) {
      var db, errs, i, j, key, len, len1, place, price_range, ref, ref1, tags, val;
      console.log(data);
      errs = check.check(data);
      if (!$.user.tutor) {
        return {
          status: "failed",
          errs: ["access_failed"]
        };
      }
      if (errs.length) {
        return {
          status: 'failed',
          errs: errs
        };
      }
      tags = [];
      tags.push(data.course);
      ref = data.categories_of_students;
      for (key = i = 0, len = ref.length; i < len; key = ++i) {
        val = ref[key];
        console.log('AAron');
        console.log(val);
        if (val) {
          switch (key) {
            case 0:
              tags.push("school:0");
              break;
            case 1:
              tags.push("school:1");
              break;
            case 2:
              tags.push("school:2");
              break;
            case 3:
              tags.push("school:3");
              break;
            case 4:
              tags.push("student");
              break;
            case 5:
              tags.push("adult");
          }
        }
      }
      price_range = [];
      price_range.push(data.price_from);
      price_range.push(data.price_till);
      place = [];
      ref1 = data.place;
      for (key = j = 0, len1 = ref1.length; j < len1; key = ++j) {
        val = ref1[key];
        if (val) {
          switch (key) {
            case 0:
              place.push("tutor");
              break;
            case 1:
              place.push("pupil");
              break;
            case 2:
              place.push("remote");
              break;
            case 3:
              place.push("other");
          }
        }
      }
      db = (yield $.db.get('tutor'));
      (yield _invoke(db, 'update', {
        account: $.user.id
      }, {
        $set: {
          subjects: {
            name: data.subject_tag,
            description: data.comments,
            tags: tags,
            price: [
              {
                range: price_range,
                duration: data.duration
              }
            ],
            place: place,
            groups: [
              {
                description: data.group_learning
              }
            ]
          }
        }
      }, {
        upsert: true
      }));
      (yield $.form.flush(['tutor'], $.req, $.res));
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
