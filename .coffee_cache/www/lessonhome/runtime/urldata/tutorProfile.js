(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.D2U = (function() {
    function D2U() {
      this.$subject = bind(this.$subject, this);
      this.$inset = bind(this.$inset, this);
      this.$index = bind(this.$index, this);
    }

    D2U.prototype.$index = function(obj) {
      return {
        type: 'int',
        "default": 0,
        value: obj != null ? obj.index : void 0
      };
    };

    D2U.prototype.$inset = function(obj) {
      return {
        type: 'int',
        "default": 0,
        value: obj != null ? obj.inset : void 0
      };
    };

    D2U.prototype.$subject = function(obj) {
      return {
        type: 'string',
        "default": '',
        value: obj != null ? obj.subject : void 0
      };
    };

    return D2U;

  })();

  this.U2D = (function() {
    function U2D() {
      this.$subject = bind(this.$subject, this);
      this.$inset = bind(this.$inset, this);
      this.$index = bind(this.$index, this);
    }

    U2D.prototype.$index = function(obj) {
      return obj != null ? obj.index : void 0;
    };

    U2D.prototype.$inset = function(obj) {
      return obj != null ? obj.inset : void 0;
    };

    U2D.prototype.$subject = function(obj) {
      return obj != null ? obj.subject : void 0;
    };

    return U2D;

  })();

}).call(this);
