(function() {
  this.handler = (function(_this) {
    return function*($, direction, index, indata) {
      var account, adb, pdb, ratio, ref, ref1, ref2;
      console.log($.user.admin);
      if (!$.user.admin) {
        return {
          status: 'failed'
        };
      }
      pdb = (yield $.db.get('persons'));
      adb = (yield $.db.get('accounts'));
      account = (ref = (ref1 = (yield _invoke(adb.find({
        index: index
      }, {
        id: 1
      }), 'toArray'))) != null ? (ref2 = ref1[0]) != null ? ref2.id : void 0 : void 0) != null ? ref : 0;
      switch (direction) {
        case 'up':
        case 'down':
          console.log(account);
          if (direction === 'up') {
            ratio = 1.3;
          }
          if (direction === 'down') {
            ratio = 0.76;
          }
          (yield _invoke(pdb, 'update', {
            account: account
          }, {
            $set: {
              ratio: ratio
            }
          }));
          break;
        case 'ratio':
          ratio = indata;
          (yield _invoke(pdb, 'update', {
            account: account
          }, {
            $set: {
              ratio: ratio
            }
          }));
          break;
        case 'landing':
          (yield _invoke(pdb, 'update', {
            account: account
          }, {
            $set: {
              landing: indata
            }
          }));
          break;
        case 'filtration':
          (yield _invoke(pdb, 'update', {
            account: account
          }, {
            $set: {
              filtration: indata
            }
          }));
          break;
        case 'mcomment':
          (yield _invoke(pdb, 'update', {
            account: account
          }, {
            $set: {
              mcomment: indata
            }
          }));
      }
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
