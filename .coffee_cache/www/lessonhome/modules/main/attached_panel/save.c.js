(function() {
  var check, hostname, os, other, phones;

  check = require("./check");

  os = require('os');

  hostname = os.hostname();

  phones = ['79254688208', '79267952303', '79152292244', '79263672997'];

  other = function($, data, second) {
    return Q.async((function(_this) {
      return function*() {
        var i, key, len, messages, p, ref, sms, text, val;
        sms = (yield Main.service('sms'));
        text = '';
        if (data.id > 0) {
          text += 'заявка(сообщение преподу)\n';
        } else if (second) {
          text += 'повторная заявка\n';
        } else {
          text += 'заявка\n';
        }
        text += (data != null ? data.name : void 0) || '';
        if (!(!text || (text.substr(-1) === '\n'))) {
          text += '\n';
        }
        text += data.subject || '';
        if (!(!text || (text.substr(-1) === '\n'))) {
          text += '\n';
        }
        text += data.phone || '';
        if (!(!text || (text.substr(-1) === '\n'))) {
          text += '\n';
        }
        text += data.email || '';
        if (!(!text || (text.substr(-1) === '\n'))) {
          text += '\n';
        }
        if (data.linked != null) {
          ref = data.linked;
          for (key in ref) {
            val = ref[key];
            text += 'https://lessonhome.ru/tutor_profile?x=' + key + "\n";
          }
        }
        if (data.id) {
          text += 'to: https://lessonhome.ru/tutor_profile?x=' + data.id + "\n";
        }
        text += data.comments || '';
        if (!(!text || (text.substr(-1) === '\n'))) {
          text += '\n';
        }
        text += data.comment || '';
        if (!(!text || (text.substr(-1) === '\n'))) {
          text += '\n';
        }
        if ($.user.admin || (hostname !== 'pi0h.org')) {
          return console.log(text);
        }
        messages = [];
        for (i = 0, len = phones.length; i < len; i++) {
          p = phones[i];
          messages.push({
            phone: p,
            text: text
          });
        }
        return console.log((yield sms.send(messages)));
      };
    })(this))();
  };

  this.handler = (function(_this) {
    return function*($, data) {
      var db, errs, saved, second;
      data = check.takeData(data);
      errs = [];
      if (errs['phone'] != null) {
        return {
          status: 'failed',
          errs: errs
        };
      }
      if (errs.correct === false) {
        data = {
          phone: data['phone']
        };
      }
      data.account = $.user.id;
      data['phone'] = data['phone'].replace(/^\+7/, '8');
      data['phone'] = data['phone'].replace(/[^\d]/g, '');
      data['time'] = new Date();
      console.log('save bid');
      db = (yield $.db.get('bids'));
      saved = (yield _invoke(db.find({
        $or: [
          {
            account: $.user.id
          }, {
            phone: data.phone
          }
        ]
      }), 'toArray'));
      if (data.id > 0) {
        (yield _invoke(db, 'insert', data));
      } else {
        (yield _invoke(db, 'update', {
          account: $.user.id
        }, {
          $set: data
        }, {
          upsert: true
        }));
      }
      other.call(_this, $, data, second = (saved[0] != null)).done();
      return {
        status: 'success'
      };
    };
  })(this);

}).call(this);
