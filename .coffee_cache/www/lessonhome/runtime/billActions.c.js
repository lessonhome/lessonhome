(function() {
  this.handler = function*($, data) {
    var bills, billsDb, db, err, error;
    db = (yield Main.service('db'));
    billsDb = (yield db.get('bills'));
    try {
      switch (data.action) {
        case 'pay':
          bills = (yield _invoke(billsDb.find({
            account: $.user.id
          }), 'toArray'));
          if (bills[0].value < data.value) {
            return {
              status: 'failed',
              balance: bills[0].value
            };
          }
          (yield _invoke(billsDb, 'update', {
            account: $.user.id
          }, {
            $inc: {
              value: -1 * data.value
            }
          }, {
            upsert: true
          }));
          break;
        case 'refill':
          (yield _invoke(billsDb, 'update', {
            account: $.user.id
          }, {
            $inc: {
              value: data.value
            }
          }, {
            upsert: true
          }));
      }
      bills = (yield _invoke(billsDb.find({
        account: $.user.id
      }), 'toArray'));
    } catch (error) {
      err = error;
      console.log('err', err);
      if (err.err == null) {
        err.err = 'internal_error';
      }
      return {
        status: 'failed',
        err: err.err
      };
    }
    return {
      status: 'success',
      balance: bills[0].value
    };
  };

}).call(this);
