(function() {
  var boolSet, boolSetR;

  boolSet = (function(_this) {
    return function(obj, list) {
      var i, j, len, s, v;
      list.sort();
      v = 0;
      i = 1;
      for (j = 0, len = list.length; j < len; j++) {
        s = list[j];
        if (obj != null ? obj[s] : void 0) {
          v += i;
        }
        i *= 2;
      }
      return v;
    };
  })(this);

  boolSetR = (function(_this) {
    return function(obj, list) {
      var j, len, ret, s, v;
      list.sort();
      ret = {};
      v = obj != null ? obj : 0;
      for (j = 0, len = list.length; j < len; j++) {
        s = list[j];
        ret[s] = (v % 2) === 1;
        v = Math.floor(v / 2);
      }
      return ret;
    };
  })(this);

  this.D2U = (function() {
    function D2U() {}

    return D2U;

  })();

  this.U2D = (function() {
    function U2D() {}

    return U2D;

  })();

}).call(this);
