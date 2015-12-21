(function() {
  var check, email_period_life, sms_number_life, sms_period_life, sms_period_refresh, sms_time_life;

  check = require('../modules/register/content/check');

  sms_time_life = 24 * 60;

  sms_period_life = 5;

  sms_number_life = 10;

  sms_period_refresh = 24;

  email_period_life = 24;

  this.handler = function*($, data) {
    var account, accountsDb, authToken, db, desired_account, email, email_service, err, error, errs, i, is_email, j, key, len, len1, name, now, persons, personsDb, phone, ref, ref1, ref10, ref11, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, smsToken, token, url_service, utoken, way;
    if (data == null) {
      data = {};
    }
    try {
      db = (yield Main.service('db'));
      accountsDb = (yield db.get('accounts'));
      account = (yield _invoke(accountsDb.find({
        id: $.user.id
      }, {
        changePasswordForId: 1,
        smsToken: 1,
        authToken: 1
      }), 'toArray'));
      account = account[0];
      if (account == null) {
        throw 'internal_error';
      }
      desired_account = null;
      if (data.login != null) {
        desired_account = (yield _invoke(accountsDb.find({
          login: data.login
        }, {
          id: 1
        }), 'toArray'));
        data.id = (ref = (ref1 = desired_account[0]) != null ? ref1.id : void 0) != null ? ref : null;
      } else {
        if (account.changePasswordForId == null) {
          throw 'login_not_exists';
        }
        desired_account = (yield _invoke(accountsDb.find({
          id: account.changePasswordForId
        }, {
          login: 1
        }), 'toArray'));
        data.id = account.changePasswordForId;
        data.login = (ref2 = (ref3 = desired_account[0]) != null ? ref3.login : void 0) != null ? ref2 : null;
      }
      if (!((data.login != null) && (data.id != null))) {
        throw 'login_not_exists';
      }
      phone = check.checkPhone(data.login);
      is_email = check.checkEmail(data.login);
      if (!(phone || is_email)) {
        throw 'login_not_exists';
      }
      data.phone = [];
      data.email = [];
      if (phone) {
        data.phone.push(phone);
      }
      if (is_email) {
        data.email.push(data.login);
      }
      way = null;
      now = new Date();
      if (phone) {
        way = 'phone';
        smsToken = null;
        if (((ref4 = account.smsToken) != null ? ref4.reborn : void 0) == null) {
          smsToken = {
            count: 0,
            life: (new Date()).setMinutes(now.getMinutes() + sms_time_life),
            reborn: (new Date()).setHours(now.getHours() + sms_period_refresh),
            next: now
          };
        } else {
          smsToken = {};
          ref5 = ['count', 'life', 'reborn', 'next'];
          for (i = 0, len = ref5.length; i < len; i++) {
            key = ref5[i];
            smsToken[key] = account.smsToken[key];
          }
        }
        if (smsToken.reborn < now) {
          smsToken.count = 0;
        }
        if (smsToken.life < now) {
          smsToken.life = (new Date()).setMinutes(now.getMinutes() + sms_time_life);
        }
        if (smsToken.count < sms_number_life) {
          if (smsToken.next <= now) {
            smsToken.next = (new Date()).setMinutes(now.getMinutes() + sms_period_life);
            ++smsToken.count;
            token = _randomHash(3);
            smsToken.token = _hash(token);
            (yield _invoke(accountsDb, 'update', {
              id: $.user.id
            }, {
              $set: {
                smsToken: smsToken,
                changePasswordForId: data.id
              }
            }, {
              upsert: true
            }));
            Q.spawn(function*() {
              var sms_service;
              sms_service = (yield Main.service('sms'));
              return (yield sms_service.send([
                {
                  phone: phone,
                  text: '' + token
                }
              ]));
            });
          } else {
            throw 'send_later';
          }
        } else {
          throw 'limit_attempt';
        }
      } else if (is_email) {
        way = 'email';
        email_service = (yield Main.service('mail'));
        url_service = (yield Main.service('urldata'));
        authToken = {
          token: _randomHash(10),
          valid: (new Date).setHours(now.getHours() + email_period_life)
        };
        utoken = (yield url_service.d2u('authToken', {
          token: authToken.token
        }));
        (yield _invoke(accountsDb, 'update', {
          id: data.id
        }, {
          $set: {
            authToken: authToken
          }
        }, {
          upsert: true
        }));
        personsDb = (yield db.get('persons'));
        persons = (yield _invoke(personsDb.find({
          account: data.id
        }), 'toArray'));
        persons = (ref6 = persons != null ? persons[0] : void 0) != null ? ref6 : {};
        name = ((ref7 = persons != null ? persons.last_name : void 0) != null ? ref7 : '') + " " + ((ref8 = persons != null ? persons.first_name : void 0) != null ? ref8 : '') + " " + ((ref9 = persons != null ? persons.middle_name : void 0) != null ? ref9 : '');
        name = name.replace(/^\s+/, '');
        name = name.replace(/\s+$/, '');
        if (name) {
          name = ', ' + name;
        }
        ref11 = (ref10 = data.email) != null ? ref10 : [];
        for (j = 0, len1 = ref11.length; j < len1; j++) {
          email = ref11[j];
          (yield email_service.send('restore_password.html', email, 'Восстановление пароля', {
            name: name,
            login: email,
            link: 'https://lessonhome.ru/new_password?' + utoken
          }));
        }
      }
      (yield $.form.flush('*', $.req, $.res));
      return {
        status: 'success',
        way: way
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
