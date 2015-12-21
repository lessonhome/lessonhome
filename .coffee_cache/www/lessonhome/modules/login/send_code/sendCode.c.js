(function() {
  var max_count_attempt, token_period_life;

  max_count_attempt = 3;

  token_period_life = 24;

  this.handler = function*($, data) {
    var account, accountDb, authToken, err, error, errs, ref, time, url_service, utoken;
    try {
      if (!((data.code != null) && data.code)) {
        throw 'empty_code';
      }
      accountDb = (yield $.db.get('accounts'));
      account = (yield _invoke(accountDb.find({
        id: $.user.id
      }, {
        'smsToken.life': 1,
        'smsToken.token': 1,
        'smsToken.att_count': 1,
        changePasswordForId: 1
      }), 'toArray'));
      if (!((((ref = account[0]) != null ? ref.smsToken : void 0) != null) && (account[0].changePasswordForId != null))) {
        throw 'not_exist';
      }
      if (account[0].smsToken.life < Date.now()) {
        throw 'timeout';
      }
      if ((account[0].smsToken.att_count != null) && account[0].smsToken.att_count >= max_count_attempt) {
        throw 'max_attempt';
      }
      if (_hash(data.code) !== account[0].smsToken.token) {
        (yield _invoke(accountDb, 'update', {
          id: $.user.id
        }, {
          $inc: {
            'smsToken.att_count': 1
          }
        }));
        (yield $.form.flush('*', $.req, $.res));
        throw 'wrong_code';
      }
      time = new Date;
      authToken = {
        token: _randomHash(10),
        valid: time.setHours(time.getHours() + token_period_life)
      };
      (yield _invoke(accountDb, 'update', {
        id: account[0].changePasswordForId
      }, {
        $set: {
          authToken: authToken
        }
      }));
      url_service = (yield Main.service('urldata'));
      utoken = (yield url_service.d2u('authToken', {
        token: authToken.token
      }));
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success',
        token: utoken
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
