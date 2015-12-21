(function() {
  this.F2V = (function() {
    function F2V() {}

    F2V.prototype.$phone_call_phones_first = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.phone_call) != null ? (ref1 = ref.phones) != null ? ref1[0] : void 0 : void 0 : void 0;
    };

    F2V.prototype.$subjects_0_subject = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.subjects) != null ? (ref1 = ref[0]) != null ? ref1.subject : void 0 : void 0 : void 0;
    };

    F2V.prototype.$phone_call_description = function(data) {
      var ref;
      return data != null ? (ref = data.phone_call) != null ? ref.description : void 0 : void 0;
    };

    F2V.prototype.$subjects_0_comments = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.subjects) != null ? (ref1 = ref[0]) != null ? ref1.comments : void 0 : void 0 : void 0;
    };

    F2V.prototype.$subjects_0_course = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.subjects) != null ? (ref1 = ref[0]) != null ? ref1.course : void 0 : void 0 : void 0;
    };

    F2V.prototype.$subjects_0_knowledge_level = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.subjects) != null ? (ref1 = ref[0]) != null ? ref1.knowledge : void 0 : void 0 : void 0;
    };

    F2V.prototype.$subjects_0_lesson_price_left = function(data) {
      var ref, ref1, ref2;
      return data != null ? (ref = data.subjects) != null ? (ref1 = ref[0]) != null ? (ref2 = ref1.lesson_price) != null ? ref2[0] : void 0 : void 0 : void 0 : void 0;
    };

    F2V.prototype.$subjects_0_lesson_price_right = function(data) {
      var ref, ref1, ref2;
      return data != null ? (ref = data.subjects) != null ? (ref1 = ref[0]) != null ? (ref2 = ref1.lesson_price) != null ? ref2[1] : void 0 : void 0 : void 0 : void 0;
    };

    F2V.prototype.$subjects_0_goal = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.subjects) != null ? (ref1 = ref[0]) != null ? ref1.goal : void 0 : void 0 : void 0;
    };

    F2V.prototype.$first_subject = function(data) {
      var ref;
      return data != null ? (ref = data.subjects) != null ? ref[0] : void 0 : void 0;
    };

    F2V.prototype.$isPlace = function*(data) {
      var key, ref, ref1, ret, tag, tags;
      ret = {};
      tags = ((ref = ((yield this.$newBid(data))).subjects) != null ? (ref1 = ref[0]) != null ? ref1.place : void 0 : void 0) || [];
      for (key in tags) {
        tag = tags[key];
        ret[tag] = true;
      }
      return ret;
    };

    F2V.prototype.$isStatus = function*(data) {
      var key, ref, ref1, ref2, ret, tag, tags;
      ret = {};
      tags = ((ref = ((yield this.$newBid(data))).subjects) != null ? (ref1 = ref[0]) != null ? (ref2 = ref1.requirements_for_tutor) != null ? ref2.status : void 0 : void 0 : void 0) || [];
      for (key in tags) {
        tag = tags[key];
        ret[tag] = true;
      }
      return ret;
    };

    F2V.prototype.$newBid = function(data) {
      var last, ref, ref1;
      last = data != null ? (ref = data.bids) != null ? ref[(data != null ? (ref1 = data.bids) != null ? ref1.length : void 0 : void 0) - 1] : void 0 : void 0;
      if (last == null) {
        last = {};
      }
      if (last.complited !== false) {
        last = {};
      }
      return last;
    };

    F2V.prototype.$lesson_price = function*(data) {
      var r, ref, ref1, ret;
      r = (ref = ((yield this.$newBid(data))).subjects) != null ? (ref1 = ref[0]) != null ? ref1.lesson_price : void 0 : void 0;
      return ret = {
        left: (r != null ? r[0] : void 0) || 400,
        right: (r != null ? typeof r.pop === "function" ? r.pop() : void 0 : void 0) || 5000
      };
    };

    F2V.prototype.$requirements_for_tutor = function*(data) {
      var r, ref, ref1;
      r = (ref = ((yield this.$newBid(data))).subjects) != null ? (ref1 = ref[0]) != null ? ref1.requirements_for_tutor : void 0 : void 0;
      return r;
    };

    return F2V;

  })();

}).call(this);
