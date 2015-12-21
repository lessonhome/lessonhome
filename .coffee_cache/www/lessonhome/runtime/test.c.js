(function() {
  var TestW,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  TestW = (function() {
    function TestW() {
      this.run = bind(this.run, this);
      this.init = bind(this.init, this);
      $W(this);
      console.log('ololokok'.red);
    }

    TestW.prototype.init = function() {
      return console.log('ololokok'.red);
    };

    TestW.prototype.run = function() {};

    return TestW;

  })();

  module.exports = new TestW;

}).call(this);
