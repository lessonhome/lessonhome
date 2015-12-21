(function() {
  this.handler = function*($, data) {
    var err, error, ref;
    if (data != null ? (ref = data.password) != null ? typeof ref.match === "function" ? ref.match(/\%/) : void 0 : void 0 : void 0) {
      data.password = unescape(data.password);
    } else {
      data.password = _LZString.decompressFromBase64(data.password);
    }
    data.type = 'tutor';
    try {
      (yield $.register.newType($.user, $.session, data));
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
    (yield $.form.flush('*', $.req, $.res));
    this.delayRegisterMail($.user.id).done();
    return {
      status: 'success'
    };
  };

  this.delayRegisterMail = function*(id) {
    var accounts, accountsDb, db, mail, name, p, persons, personsDb, ref, ref1, ref2, ref3;
    (yield Q.delay(1000 * 60 * 10));
    db = (yield Main.service('db'));
    mail = (yield Main.service('mail'));
    personsDb = (yield db.get('persons'));
    accountsDb = (yield db.get('accounts'));
    persons = (yield _invoke(personsDb.find({
      account: id
    }), 'toArray'));
    accounts = (yield _invoke(accountsDb.find({
      id: id
    }, {
      login: 1
    }), 'toArray'));
    p = (ref = persons != null ? persons[0] : void 0) != null ? ref : {};
    name = ((ref1 = p != null ? p.last_name : void 0) != null ? ref1 : '') + " " + ((ref2 = p != null ? p.first_name : void 0) != null ? ref2 : '') + " " + ((ref3 = p != null ? p.middle_name : void 0) != null ? ref3 : '');
    name = name.replace(/^\s+/, '');
    name = name.replace(/\s+$/, '');
    if (name) {
      name = ', ' + name;
    }
    if (!accounts[0].login.match('@')) {
      return;
    }
    return (yield mail.send('register.html', accounts[0].login, 'Спасибо за регистрацию', {
      name: name,
      login: accounts[0].login
    }));
  };

}).call(this);
