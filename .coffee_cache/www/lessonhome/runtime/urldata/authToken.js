(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.D2U = (function() {
    function D2U() {
      this.$token = bind(this.$token, this);
    }

    D2U.prototype.$token = function(obj) {
      return {
        type: 'string',
        "default": '',
        value: obj != null ? obj.token : void 0
      };
    };

    return D2U;

  })();

  this.U2D = (function() {
    function U2D() {
      this.$token = bind(this.$token, this);
    }

    U2D.prototype.$token = function(obj) {
      return obj != null ? obj.token : void 0;
    };

    return U2D;

  })();

}).call(this);
