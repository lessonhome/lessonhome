(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.D2U = (function() {
    function D2U() {
      this.$redirect = bind(this.$redirect, this);
    }

    D2U.prototype.$redirect = function(obj) {
      return {
        type: 'string',
        "default": '',
        value: obj != null ? obj.redirect : void 0
      };
    };

    return D2U;

  })();

  this.U2D = (function() {
    function U2D() {
      this.$redirect = bind(this.$redirect, this);
    }

    U2D.prototype.$redirect = function(obj) {
      return obj != null ? obj.redirect : void 0;
    };

    return U2D;

  })();

}).call(this);
