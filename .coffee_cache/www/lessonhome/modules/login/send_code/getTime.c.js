(function() {
  this.handler = function*($, data) {
    var account, accountDb, err, error, errs, ref;
    try {
      accountDb = (yield $.db.get('accounts'));
      account = (yield _invoke(accountDb.find({
        id: $.user.id
      }, {
        'smsToken.next': 1
      }), 'toArray'));
      account = account[0];
      if (account == null) {
        throw 'not_account';
      }
      if (((ref = account.smsToken) != null ? ref.next : void 0) == null) {
        throw 'not_send';
      }
      return {
        status: 'success',
        time: account.smsToken.next - Date.now()
      };
    } catch (error) {
      errs = error;
      err = {
        status: 'failed'
      };
      if (typeof errs === 'string') {
        err['err'] = errs;
      } else {
        err['err'] = 'internal_error';
        console.log("ERROR: " + errs.stack);
      }
      return err;
    }
  };

}).call(this);
