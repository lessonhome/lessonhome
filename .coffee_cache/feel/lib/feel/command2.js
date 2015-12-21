(function() {
  var Feel,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Feel = require("./feel");

  module.exports = (function() {
    function exports() {
      this.run = bind(this.run, this);
      this.init = bind(this.init, this);
      Wrap(this);
    }

    exports.prototype.init = function() {};

    exports.prototype.run = function() {
      this.feel = new Feel();
      return this.feel.init();
    };

    return exports;

  })();

}).call(this);
