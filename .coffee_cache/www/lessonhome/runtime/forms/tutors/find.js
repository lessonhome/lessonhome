(function() {
  var Find,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Find = (function() {
    function Find() {
      this.get = bind(this.get, this);
    }

    Find.prototype.get = function(req, res) {
      return {};
    };

    return Find;

  })();

  module.exports = Find;

}).call(this);
