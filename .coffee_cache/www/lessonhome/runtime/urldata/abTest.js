(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.D2U = (function() {
    function D2U() {
      this.$main_tutor = bind(this.$main_tutor, this);
    }

    D2U.prototype.$main_tutor = function(obj) {
      return {
        type: 'int',
        "default": 0,
        value: obj != null ? obj.main_tutor : void 0
      };
    };

    return D2U;

  })();

  this.U2D = (function() {
    function U2D() {
      this.$main_tutor = bind(this.$main_tutor, this);
    }

    U2D.prototype.$main_tutor = function(obj) {
      return obj != null ? obj.main_tutor : void 0;
    };

    return U2D;

  })();

}).call(this);
