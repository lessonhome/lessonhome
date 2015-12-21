(function() {
  var PayMaster,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  PayMaster = (function() {
    function PayMaster() {
      this.pay = bind(this.pay, this);
      this.init = bind(this.init, this);
      $W(this);
    }

    PayMaster.prototype.init = function*() {
      this.jobs = (yield Main.service('jobs'));
      (yield this.jobs.listen('pay', this.pay));
      return (yield this.jobs.solve('pay', {
        amount: 2000
      }));
    };

    PayMaster.prototype.pay = function(data) {
      return console.log(data);
    };

    return PayMaster;

  })();

  module.exports = new PayMaster;

}).call(this);
