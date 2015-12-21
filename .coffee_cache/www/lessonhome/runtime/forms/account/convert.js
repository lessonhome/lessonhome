(function() {
  this.F2V = (function() {
    function F2V() {}

    F2V.prototype.$activeTutor = function(data) {
      var ref;
      if (data != null ? (ref = data.type) != null ? ref.tutor : void 0 : void 0) {
        return 'active';
      }
    };

    F2V.prototype.$registered = function(data) {
      var ref, ref1;
      if ((data != null ? (ref = data.type) != null ? ref.tutor : void 0 : void 0) || (data != null ? (ref1 = data.type) != null ? ref1.pupil : void 0 : void 0)) {
        return true;
      } else {
        return false;
      }
    };

    F2V.prototype.$registration_progress = function(data) {
      var s;
      s = data != null ? data.status : void 0;
      if (s != null ? s.tutor_prereg_4 : void 0) {
        return 5;
      }
      if (s != null ? s.tutor_prereg_3 : void 0) {
        return 4;
      }
      if (s != null ? s.tutor_prereg_2 : void 0) {
        return 3;
      }
      if (s != null ? s.tutor_prereg_1 : void 0) {
        return 2;
      }
      return 1;
    };

    F2V.prototype.$fast_bid_progress = function(data) {
      var ref;
      if (data != null ? (ref = data.status) != null ? ref.fast_bid : void 0 : void 0) {
        return data.status.fast_bid;
      } else {
        return 1;
      }
    };

    return F2V;

  })();

}).call(this);
