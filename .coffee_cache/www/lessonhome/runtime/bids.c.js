(function() {
  var Bids, bids,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Bids = (function() {
    function Bids() {
      this.reload = bind(this.reload, this);
      this.handler = bind(this.handler, this);
      this.init = bind(this.init, this);
      Wrap(this);
    }

    Bids.prototype.init = function*() {
      if (this.inited === 1) {
        return _waitFor(this, 'inited');
      }
      if (this.inited > 1) {
        return;
      }
      this.inited = 1;
      this.bidsDb = (yield this.$db.get('bids'));
      (yield this.reload());
      this.inited = 2;
      this.emit('inited');
      return setInterval((function(_this) {
        return function() {
          return _this.reload().done();
        };
      })(this), 1000 * 30);
    };

    Bids.prototype.handler = function*($) {
      if (this.inited !== 2) {
        return (yield this.init());
      }
    };

    Bids.prototype.reload = function*() {
      var bids, ref;
      bids = _invoke(this.bidsDb.find({}), 'toArray');
      return ref = (yield Q.all([bids])), bids = ref[0], ref;
    };

    return Bids;

  })();

  bids = new Bids;

  module.exports = bids;

}).call(this);
