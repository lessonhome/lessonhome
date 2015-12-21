(function() {
  var Register, bcrypt,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  bcrypt = require('bcryptjs');

  Register = (function() {
    function Register() {
      this.onError = bind(this.onError, this);
      this.newSession = bind(this.newSession, this);
      this.newAccount = bind(this.newAccount, this);
      this.passwordCompare = bind(this.passwordCompare, this);
      this.passwordCrypt = bind(this.passwordCrypt, this);
      this.loginUpdate = bind(this.loginUpdate, this);
      this.loginExists = bind(this.loginExists, this);
      this.relogin = bind(this.relogin, this);
      this.newPassword = bind(this.newPassword, this);
      this.passwordRestore = bind(this.passwordRestore, this);
      this.passwordUpdate = bind(this.passwordUpdate, this);
      this.login = bind(this.login, this);
      this.newType = bind(this.newType, this);
      this.removeAdminHash = bind(this.removeAdminHash, this);
      this.getAdminHash = bind(this.getAdminHash, this);
      this.bindAdmin = bind(this.bindAdmin, this);
      this.register = bind(this.register, this);
      this.reload = bind(this.reload, this);
      this.delete_tutor = bind(this.delete_tutor, this);
      this.init = bind(this.init, this);
      Wrap(this);
    }

    Register.prototype.init = function*() {
      var _ids, a, acc, arr, arr2, avatar, d, db, i, id, ids, image, j, k, l, len, len1, len10, len2, len3, len4, len5, len6, len7, len8, len9, n, nids, oldAvaAccs, photos, q, r, ref, ref1, ref2, ref3, ref4, ref5, ref6, results, row, s, sess, t, u, uploaded, uploadedImages, v, w, x;
      db = (yield Main.service('db'));
      this.account = (yield db.get('accounts'));
      this.session = (yield db.get('sessions'));
      this.bills = (yield db.get('bills'));
      this.dbpersons = (yield db.get('persons'));
      this.dbpupil = (yield db.get('pupil'));
      this.dbtutor = (yield db.get('tutor'));
      this.dbuploaded = (yield db.get('uploaded'));
      this.mail = (yield Main.service('mail'));
      this.urldata = (yield Main.service('urldata'));
      this.adminHashs = (yield db.get('adminHashs'));
      arr = (yield _invoke(this.adminHashs.find({}), 'toArray'));
      this.adminHashsArr = {};
      for (i = 0, len = arr.length; i < len; i++) {
        r = arr[i];
        this.adminHashsArr[r.hash] = true;
      }
      ids = {};
      _ids = (yield _invoke(this.dbpersons.find({}, {
        account: 1
      }), 'toArray'));
      for (j = 0, len1 = _ids.length; j < len1; j++) {
        row = _ids[j];
        ids[row.account] = true;
      }
      console.log("persons: ".magenta, _ids != null ? _ids.length : void 0);
      _ids = (yield _invoke(this.dbpupil.find({}, {
        account: 1
      }), 'toArray'));
      for (k = 0, len2 = _ids.length; k < len2; k++) {
        row = _ids[k];
        ids[row.account] = true;
      }
      console.log('pupils: '.magenta, _ids != null ? _ids.length : void 0);
      _ids = (yield _invoke(this.dbtutor.find({}, {
        account: 1
      }), 'toArray'));
      for (l = 0, len3 = _ids.length; l < len3; l++) {
        row = _ids[l];
        ids[row.account] = true;
      }
      console.log('tutors: '.magenta, _ids != null ? _ids.length : void 0);
      nids = {};
      d = new Date();
      d.setDate(d.getDate() - 1);
      _ids = (yield _invoke(this.account.find({
        $or: [
          {
            accessTime: {
              $eq: null
            }
          }, {
            id: {
              $nin: Object.keys(ids)
            },
            accessTime: {
              $lt: d
            }
          }
        ]
      }, {
        id: 1
      }), 'toArray'));
      for (n = 0, len4 = _ids.length; n < len4; n++) {
        row = _ids[n];
        nids[row.id] = true;
      }
      nids = Object.keys(nids);
      console.log('illegals: '.magenta, nids.length);
      (yield _invoke(this.account, 'update', {
        account: {
          $exists: true
        }
      }, {
        $unset: {
          account: ""
        }
      }, {
        multi: true
      }));
      (yield _invoke(this.account, 'update', {
        acc: {
          $exists: true
        }
      }, {
        $unset: {
          acc: ""
        }
      }, {
        multi: true
      }));
      (yield _invoke(this.account, 'remove', {
        id: {
          $in: nids
        }
      }));
      (yield _invoke(this.session, 'remove', {
        account: {
          $in: nids
        }
      }));
      (yield _invoke(this.dbpersons, 'remove', {
        account: {
          $in: nids
        }
      }));
      (yield _invoke(this.dbtutor, 'remove', {
        account: {
          $in: nids
        }
      }));
      (yield _invoke(this.dbpupil, 'remove', {
        account: {
          $in: nids
        }
      }));
      d = new Date();
      d.setDate(d.getDate() - 30);
      (yield _invoke(this.session, 'remove', {
        accessTime: {
          $lt: d
        }
      }));
      this.accounts = {};
      this.sessions = {};
      this.logins = {};
      acc = (yield _invoke(this.account.find(), 'toArray'));
      sess = (yield _invoke(this.session.find(), 'toArray'));
      for (q = 0, len5 = acc.length; q < len5; q++) {
        a = acc[q];
        this.accounts[a.id] = a;
        delete a.account;
        delete a.acc;
        if (a.login != null) {
          this.logins[a.login] = a;
        }
      }
      for (t = 0, len6 = sess.length; t < len6; t++) {
        s = sess[t];
        this.sessions[s.hash] = s;
      }
      this.aindex = 0;
      ref = this.accounts;
      for (id in ref) {
        a = ref[id];
        if (((a != null ? a.index : void 0) != null) && (this.aindex < a.index)) {
          this.aindex = a.index;
        }
      }
      d.setDate(d.getDate() - 100000);
      ref1 = this.accounts;
      for (id in ref1) {
        a = ref1[id];
        if ((a != null ? a.index : void 0) == null) {
          a.index = ++this.aindex;
          (yield _invoke(this.account, 'update', {
            id: id
          }, {
            $set: {
              index: a.index
            }
          }));
        }
        if (((ref2 = Object.keys((ref3 = a.sessions) != null ? ref3 : {})) != null ? ref2.length : void 0) > 5) {
          arr = [];
          for (s in a.sessions) {
            arr.push((ref4 = this.sessions[s]) != null ? ref4 : {
              hash: s,
              accessTime: d
            });
          }
          arr.sort((function(_this) {
            return function(a, b) {
              var ref5, ref6;
              return ((ref5 = b.accessTime) != null ? typeof ref5.getTime === "function" ? ref5.getTime() : void 0 : void 0) - ((ref6 = a.accessTime) != null ? typeof ref6.getTime === "function" ? ref6.getTime() : void 0 : void 0);
            };
          })(this));
          arr = arr.splice(5);
          arr2 = [];
          for (u = 0, len7 = arr.length; u < len7; u++) {
            s = arr[u];
            arr2.push(s.hash);
          }
          for (v = 0, len8 = arr2.length; v < len8; v++) {
            s = arr2[v];
            delete a.sessions[s];
            delete this.sessions[s];
          }
          (yield _invoke(this.session, 'remove', {
            hash: {
              $in: arr2
            }
          }));
          (yield _invoke(this.account, 'update', {
            id: id
          }, {
            $set: {
              sessions: a.sessions
            }
          }));
        }
      }
      oldAvaAccs = (yield _invoke(this.dbpersons.find({
        ava: {
          $exists: true
        }
      }, {
        ava: 1,
        account: 1
      }), 'toArray'));

      /*
      "ava" : [
        {
          "hash" : "4dd6d09ea6"
          "oname" : "20131222-090309-pm.jpg"
          "dir" : "www/lessonhome/static/user_data/images/"
          "name" : "4dd6d09ea6"
          "original" : "4dd6d09ea6.jpg"
          "high" : "4dd6d09ea6h.jpg"
          "low" : "4dd6d09ea6l.jpg"
          "owidth" : 2304
          "oheight" : 1536
          "hwidth" : 640
          "hheight" : 427
          "lwidth" : 200
          "lheight" : 133
          "ourl" : "/file/fa31632fe1/user_data/images/4dd6d09ea6.jpg"
          "hurl" : "/file/10282cf13d/user_data/images/4dd6d09ea6h.jpg"
          "lurl" : "/file/ca770bc6a2/user_data/images/4dd6d09ea6l.jpg"
        }
      ]
       */
      uploadedImages = [];
      results = [];
      for (w = 0, len9 = oldAvaAccs.length; w < len9; w++) {
        acc = oldAvaAccs[w];
        avatar = [];
        photos = [];
        uploaded = {};
        ref6 = (ref5 = acc.ava) != null ? ref5 : [];
        for (x = 0, len10 = ref6.length; x < len10; x++) {
          image = ref6[x];
          avatar.push(image.hash);
          photos.push(image.hash);
          uploaded[image.hash] = {
            type: 'image',
            original: image.hash,
            low: image.hash + 'low',
            high: image.hash + 'high',
            original_url: image.ourl,
            low_url: image.lurl,
            high_url: image.hurl
          };
          (yield _invoke(this.dbuploaded, 'update', {
            hash: image.hash
          }, {
            $set: {
              hash: image.hash,
              account: acc.account,
              type: 'image',
              name: image.oname,
              dir: image.dir,
              width: image.owidth,
              height: image.oheight,
              url: image.ourl
            }
          }, {
            upsert: true
          }));
          (yield _invoke(this.dbuploaded, 'update', {
            hash: image.hash + 'low'
          }, {
            $set: {
              hash: image.hash + 'low',
              account: acc.account,
              type: 'image',
              name: image.oname,
              dir: image.dir,
              width: image.lwidth,
              height: image.lheight,
              url: image.lurl
            }
          }, {
            upsert: true
          }));
          (yield _invoke(this.dbuploaded, 'update', {
            hash: image.hash + 'high'
          }, {
            $set: {
              hash: image.hash + 'high',
              account: acc.account,
              type: 'image',
              name: image.oname,
              dir: image.dir,
              width: image.hwidth,
              height: image.hheight,
              url: image.hurl
            }
          }, {
            upsert: true
          }));
        }
        results.push((yield _invoke(this.dbpersons, 'update', {
          account: acc.account
        }, {
          $set: {
            avatar: avatar,
            photos: photos,
            uploaded: uploaded
          },
          $unset: {
            ava: ''
          }
        }, {
          upsert: true
        })));
      }
      return results;
    };

    Register.prototype.delete_tutor = function(id) {
      var session;
      for (session in this.accounts[id].sessions) {
        delete this.sessions[session];
      }
      return delete this.accounts[id];
    };

    Register.prototype.reload = function*(id) {
      var a, acc, i, j, len, len1, results, s, sess, session;
      acc = (yield _invoke(this.account.find({
        id: id
      }), 'toArray'));
      sess = (yield _invoke(this.session.find({
        account: id
      }), 'toArray'));
      for (session in this.accounts[id].sessions) {
        delete this.sessions[session];
      }
      for (i = 0, len = acc.length; i < len; i++) {
        a = acc[i];
        this.accounts[a.id] = a;
        delete a.account;
        delete a.acc;
        if (a.login != null) {
          this.logins[a.login] = a;
        }
      }
      results = [];
      for (j = 0, len1 = sess.length; j < len1; j++) {
        s = sess[j];
        results.push(this.sessions[s.hash] = s);
      }
      return results;
    };

    Register.prototype.register = function*(session, unknown, adminHash) {
      var acc, account, created, idstr, key, m, newAcc, o, ref, ref1, ref2, types, val;
      o = {};
      created = false;
      if (!((session != null) && (((ref = this.sessions[session]) != null ? ref.account : void 0) != null) && (this.accounts[this.sessions[session].account] != null))) {
        session = (yield this.newAccount());
        created = true;
      }
      session = this.sessions[session];
      account = this.accounts[session.account];
      if (typeof unknown === 'string' && (m = unknown.match(/^set(.*)$/))) {
        if (m[1] === session.hash.substr(0, 8)) {
          delete account.unknown;
          acc = {};
          for (key in account) {
            val = account[key];
            acc[key] = val;
          }
          delete acc.account;
          (yield _invoke(this.account, 'update', {
            id: account.id
          }, {
            $set: acc
          }, {
            upsert: true
          }));
          (yield _invoke(this.session, 'update', {
            hash: session.hash
          }, {
            $set: session
          }, {
            upsert: true
          }));
        }
      }
      if (!created && !account.unknown) {
        session.accessTime = new Date();
        account.accessTime = new Date();
        acc = {};
        for (key in account) {
          val = account[key];
          acc[key] = val;
        }
        delete acc.account;
        _invoke(this.account, 'update', {
          id: account.id
        }, {
          $set: acc
        }, {
          upsert: true
        })["catch"](this.onError);
        _invoke(this.session, 'update', {
          hash: session.hash
        }, {
          $set: session
        }, {
          upsert: true
        })["catch"](this.onError);
      }
      types = "";
      ref1 = account.type;
      for (key in ref1) {
        val = ref1[key];
        if (val) {
          if (types) {
            types += ":";
          }
          types += key;
        }
      }
      idstr = 'user'.red + ':'.grey + ('(' + types + ')').yellow;
      if (account.login != null) {
        idstr += ':'.grey + account.login.cyan;
      }
      idstr += ':'.grey + account.id.substr(0, 5).blue;
      idstr += ':'.grey + session.hash.substr(0, 5).blue;
      newAcc = {};
      for (key in account) {
        val = account[key];
        newAcc[key] = val;
      }
      newAcc.type = {};
      ref2 = account.type;
      for (key in ref2) {
        val = ref2[key];
        newAcc.type[key] = val;
      }
      if (adminHash && this.adminHashsArr[adminHash]) {
        newAcc.admin = true;
        newAcc.type.admin = true;
      }
      return {
        session: session.hash,
        account: newAcc
      };
    };

    Register.prototype.bindAdmin = function*(session) {
      if (!this.sessions[session]) {
        return;
      }
      this.sessions[session].admin = true;
      session = this.sessions[session];
      (yield _invoke(this.session, 'update', {
        hash: session.hash
      }, {
        $set: session
      }, {
        upsert: true
      }));
    };

    Register.prototype.getAdminHash = function*() {
      var hash;
      hash = _randomHash(30);
      (yield _invoke(this.adminHashs, 'insert', {
        hash: hash
      }));
      this.adminHashsArr[hash] = true;
      return hash;
    };

    Register.prototype.removeAdminHash = function*(hash) {
      delete this.adminHashsArr[hash];
      (yield _invoke(this.adminHashs, 'remove', {
        hash: hash
      }));
    };

    Register.prototype.newType = function*(user, sessionhash, data) {
      var acc, bill, key, val;
      if (!(((data != null ? data.login : void 0) != null) && ((data != null ? data.password : void 0) != null) && ((data != null ? data.type : void 0) != null))) {
        throw {
          err: 'bad_query'
        };
      }
      if (this.logins[data.login] != null) {
        throw {
          err: 'login_exists'
        };
      }
      if (this.accounts[user.id] == null) {
        throw {
          err: 'bad_session'
        };
      }
      user = this.accounts[user.id];
      if (user.registered) {
        throw {
          err: 'already_logined'
        };
      }
      if (this.sessions[sessionhash] == null) {
        throw {
          err: 'bad_session'
        };
      }
      user = this.accounts[user.id];
      user.registered = true;
      user.login = data.login;
      this.logins[user.login] = user;
      user[data.type] = true;
      user.other = false;
      if (user.type == null) {
        user.type = {};
      }
      user.type[data.type] = true;
      user.type['other'] = false;
      data.password = data.login + data.password;
      user.hash = (yield this.passwordCrypt(_hash(data.password)));
      user.accessTime = new Date();
      acc = {};
      for (key in user) {
        val = user[key];
        acc[key] = val;
      }
      delete acc.account;
      (yield _invoke(this.account, 'update', {
        id: user.id
      }, {
        $set: user
      }, {
        upsert: true
      }));
      bill = {
        account: user.id,
        value: 0
      };
      (yield _invoke(this.bills, 'insert', bill));
      return {
        session: this.sessions[sessionhash],
        user: user
      };
    };

    Register.prototype.login = function*(user, sessionhash, data) {
      var acc, hash, hashs, key, olduser, qs, tryto, val;
      if (!(((data != null ? data.login : void 0) != null) && ((data != null ? data.password : void 0) != null))) {
        throw {
          err: 'bad_query'
        };
      }
      if (this.logins[data.login] == null) {
        throw {
          err: 'login_not_exists'
        };
      }
      if (this.accounts[user.id] == null) {
        throw {
          err: 'bad_session'
        };
      }
      if (this.sessions[sessionhash] == null) {
        throw {
          err: 'bad_session'
        };
      }
      user = this.accounts[user.id];
      if (user.registered) {
        throw {
          err: 'already_logined'
        };
      }
      tryto = this.logins[data.login];
      data.password = data.login + data.password;
      if (!(yield this.passwordCompare(_hash(data.password), tryto.hash))) {
        throw {
          err: 'wrong_password'
        };
      }
      olduser = user;
      hashs = [];
      for (hash in olduser.sessions) {
        hashs.push(hash);
        delete this.sessions[hash];
      }
      qs = [];
      qs.push(_invoke(this.session, 'remove', {
        hash: {
          $in: hashs
        }
      }));
      qs.push(_invoke(this.account, 'remove', {
        id: olduser.id
      }));
      delete this.accounts[olduser.id];
      user = this.accounts[tryto.id];
      user.accessTime = new Date();
      sessionhash = (yield this.newSession(user.id));
      acc = {};
      for (key in user) {
        val = user[key];
        acc[key] = val;
      }
      delete acc.account;
      qs.push(_invoke(this.account, 'update', {
        id: user.id
      }, {
        $set: user
      }, {
        upsert: true
      }));
      (yield Q.all(qs));
      return {
        session: this.sessions[sessionhash],
        user: user
      };
    };

    Register.prototype.passwordUpdate = function*(user, sessionhash, data, admin) {
      var acc, data_password, key, ndata_password, val;
      if (admin == null) {
        admin = false;
      }
      if (!(((data != null ? data.login : void 0) != null) && ((data != null ? data.password : void 0) != null) && ((data != null ? data.newpassword : void 0) != null))) {
        throw {
          err: 'bad_query'
        };
      }
      if (this.logins[data.login] == null) {
        throw {
          err: 'login_not_exists'
        };
      }
      if (this.accounts[user.id] == null) {
        throw {
          err: 'bad_session'
        };
      }
      if (this.sessions[sessionhash] == null) {
        throw {
          err: 'bad_session'
        };
      }
      user = this.accounts[user.id];
      if (!user.registered) {
        throw {
          err: 'not_logined'
        };
      }
      data_password = data.login + data.password;
      if (!(admin || (yield this.passwordCompare(_hash(data_password), user.hash)))) {
        throw {
          err: 'wrong_password'
        };
      }
      ndata_password = data.login + data.newpassword;
      user.hash = (yield this.passwordCrypt(_hash(ndata_password)));
      user.accessTime = new Date();
      acc = {};
      for (key in user) {
        val = user[key];
        acc[key] = val;
      }
      delete acc.account;
      (yield _invoke(this.account, 'update', {
        id: user.id
      }, {
        $set: user
      }, {
        upsert: true
      }));
      return {
        session: this.sessions[sessionhash],
        user: user
      };
    };

    Register.prototype.passwordRestore = function*(data) {
      var acc, db, email, i, key, len, name, p, persons, ref, ref1, ref2, ref3, ref4, ref5, ref6, restorePassword, results, token, user, utoken, val, validDate;
      db = (yield Main.service('db'));
      token = _randomHash(10);
      utoken = (yield this.urldata.d2u('authToken', {
        token: token
      }));
      validDate = new Date();
      validDate.setHours(validDate.getHours() + 24);
      user = this.logins[data.login];
      if (user == null) {
        throw {
          err: 'login_not_exists'
        };
      }
      if (!((ref = data.email) != null ? ref.length : void 0)) {
        throw {
          err: 'email_not_exists'
        };
      }
      restorePassword = {
        token: token,
        valid: validDate
      };
      user.authToken = restorePassword;
      acc = {};
      for (key in user) {
        val = user[key];
        acc[key] = val;
      }
      delete acc.account;
      (yield _invoke(this.account, 'update', {
        id: user.id
      }, {
        $set: user
      }, {
        upsert: true
      }));
      persons = (yield _invoke(this.dbpersons.find({
        account: user.id
      }), 'toArray'));
      p = (ref1 = persons != null ? persons[0] : void 0) != null ? ref1 : {};
      name = ((ref2 = p != null ? p.last_name : void 0) != null ? ref2 : '') + " " + ((ref3 = p != null ? p.first_name : void 0) != null ? ref3 : '') + " " + ((ref4 = p != null ? p.middle_name : void 0) != null ? ref4 : '');
      name = name.replace(/^\s+/, '');
      name = name.replace(/\s+$/, '');
      if (name) {
        name = ', ' + name;
      }
      ref6 = (ref5 = data.email) != null ? ref5 : [];
      results = [];
      for (i = 0, len = ref6.length; i < len; i++) {
        email = ref6[i];
        results.push((yield this.mail.send('restore_password.html', email, 'Восстановление пароля', {
          name: name,
          login: user.login,
          link: 'https://lessonhome.ru/new_password?' + utoken
        })));
      }
      return results;
    };

    Register.prototype.newPassword = function*(user, data) {
      var acc, accounts, accountsDb, db, hash, hashs, key, ndata_password, olduser, passhash, qs, qstring, sessionhash, token, tryto, val;
      db = (yield Main.service('db'));
      accountsDb = (yield db.get('accounts'));
      qstring = data.ref.replace(/.*\?/, '');
      token = (yield this.urldata.u2d(qstring));
      token = token.authToken.token;
      accounts = (yield _invoke(accountsDb.find({
        'authToken.token': token
      }), 'toArray'));
      user = {};
      ndata_password = accounts[0].login + data.password;
      passhash = (yield this.passwordCrypt(_hash(ndata_password)));
      user.hash = passhash;
      (yield _invoke(this.account, 'update', {
        'authToken.token': token
      }, {
        $set: user
      }, {
        upsert: true
      }));
      accounts = (yield _invoke(accountsDb.find({
        'authToken.token': token
      }), 'toArray'));
      this.logins[accounts[0].login] = accounts[0];
      user = this.accounts[user.id];
      tryto = this.logins[accounts[0].login];
      olduser = tryto;
      hashs = [];
      for (hash in olduser.sessions) {
        hashs.push(hash);
        delete this.sessions[hash];
      }
      qs = [];
      qs.push(_invoke(this.session, 'remove', {
        hash: {
          $in: hashs
        }
      }));
      user = this.accounts[tryto.id];
      user.accessTime = new Date();
      user.hash = passhash;
      sessionhash = (yield this.newSession(user.id));
      acc = {};
      for (key in user) {
        val = user[key];
        acc[key] = val;
      }
      delete acc.account;
      qs.push(_invoke(this.account, 'update', {
        id: user.id
      }, {
        $set: user
      }, {
        upsert: true
      }));
      qs.push(_invoke(this.account, 'update', {
        'authToken.token': token
      }, {
        $unset: {
          authToken: ''
        }
      }, {
        upsert: true
      }));
      (yield Q.all(qs));
      return {
        session: this.sessions[sessionhash],
        user: user
      };
    };

    Register.prototype.relogin = function*(user, sessionhash, index) {
      var a, acc, hash, hashs, key, login, olduser, qs, ref, tryto, val;
      if (!user.admin) {
        throw 'err access';
      }
      login = '';
      ref = this.accounts;
      for (key in ref) {
        a = ref[key];
        if (a.index === index) {
          login = a.login;
        }
      }
      if (!login) {
        throw 'not found';
      }
      user = this.accounts[user.id];
      tryto = this.logins[login];
      olduser = user;
      hashs = [];
      for (hash in olduser.sessions) {
        hashs.push(hash);
        delete this.sessions[hash];
      }
      qs = [];
      qs.push(_invoke(this.session, 'remove', {
        hash: {
          $in: hashs
        }
      }));
      user = this.accounts[tryto.id];
      user.accessTime = new Date();
      sessionhash = (yield this.newSession(user.id));
      acc = {};
      for (key in user) {
        val = user[key];
        acc[key] = val;
      }
      delete acc.account;
      qs.push(_invoke(this.account, 'update', {
        id: user.id
      }, {
        $set: user
      }, {
        upsert: true
      }));
      (yield Q.all(qs));
      return {
        session: this.sessions[sessionhash],
        user: user
      };
    };

    Register.prototype.loginExists = function(name) {
      return this.logins[name] != null;
    };

    Register.prototype.loginUpdate = function*(user, sessionhash, data, admin) {
      var acc, data_password, key, ndata_password, val;
      if (admin == null) {
        admin = false;
      }
      if (!(((data != null ? data.login : void 0) != null) && ((data != null ? data.password : void 0) != null) && ((data != null ? data.newlogin : void 0) != null))) {
        throw {
          err: 'bad_query'
        };
      }
      if (this.logins[data.login] == null) {
        throw {
          err: 'login_not_exists'
        };
      }
      if (this.logins[data.newlogin] != null) {
        throw {
          err: 'login_exists'
        };
      }
      if (this.accounts[user.id] == null) {
        throw {
          err: 'bad_session'
        };
      }
      if (this.sessions[sessionhash] == null) {
        throw {
          err: 'bad_session'
        };
      }
      user = this.accounts[user.id];
      if (!user.registered) {
        throw {
          err: 'not_logined'
        };
      }
      data_password = data.login + data.password;
      if (!(admin || (yield this.passwordCompare(_hash(data_password), user.hash)))) {
        throw {
          err: 'wrong_password'
        };
      }
      ndata_password = data.newlogin + data.password;
      user.hash = (yield this.passwordCrypt(_hash(ndata_password)));
      delete this.logins[user.login];
      user.login = data.newlogin;
      this.logins[user.login] = user;
      user.accessTime = new Date();
      acc = {};
      for (key in user) {
        val = user[key];
        acc[key] = val;
      }
      delete acc.account;
      (yield _invoke(this.account, 'update', {
        id: user.id
      }, {
        $set: user
      }, {
        upsert: true
      }));
      return {
        session: this.sessions[sessionhash],
        user: user
      };
    };

    Register.prototype.passwordCrypt = function(pass) {
      return _invoke(bcrypt, 'hash', pass, 10);
    };

    Register.prototype.passwordCompare = function(pass, hash) {
      bcrypt.compare(pass, hash, function(err, res) {
        if (err) {
          throw err;
        } else {

        }
      });
      return _invoke(bcrypt, 'compare', pass, hash);
    };

    Register.prototype.newAccount = function*() {
      var account, e, error, sessionhash;
      try {
        account = {
          id: _randomHash(),
          index: ++this.aindex,
          registerTime: new Date(),
          accessTime: new Date(),
          other: true,
          type: {
            other: true
          },
          sessions: {},
          unknown: 'need'
        };
        this.accounts[account.id] = account;
        sessionhash = (yield this.newSession(account.id));
      } catch (error) {
        e = error;
        if ((account != null ? account.id : void 0) != null) {
          delete this.accounts[account.id];
        }
        if (sessionhash != null) {
          delete this.sessions[sessionhash];
        }
        throw e;
      }
      return sessionhash;
    };

    Register.prototype.newSession = function*(userid) {
      var account, e, error, ref, ref1, ref2, ref3, session;
      account = this.accounts[userid];
      session = {
        hash: _randomHash(),
        account: account.id,
        createTime: new Date(),
        accessTime: new Date()
      };
      try {
        account.sessions[session.hash] = true;
        this.sessions[session.hash] = session;
        if (!account.unknown) {
          (yield _invoke(this.session, 'update', {
            hash: session.hash
          }, {
            $set: session
          }, {
            upsert: true
          }));
        }
      } catch (error) {
        e = error;
        if ((session != null ? session.hash : void 0) != null) {
          delete this.sessions[session.hash];
        }
        if (((session != null ? session.hash : void 0) != null) && (((ref = this.account) != null ? (ref1 = ref.sessions) != null ? ref1[session.hash] : void 0 : void 0) != null)) {
          if ((ref2 = this.account) != null) {
            if ((ref3 = ref2.sessions) != null) {
              delete ref3[session.hash];
            }
          }
        }
        throw e;
      }
      return session.hash;
    };

    Register.prototype.onError = function(e) {
      return this.error(e);
    };

    return Register;

  })();

  module.exports = Register;

}).call(this);
