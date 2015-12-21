(function() {
  var Sms, _rj_c,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  _rj_c = require('request-json').createClient('http://json.gate.iqsms.ru/');

  Sms = (function() {
    function Sms() {
      this.send = bind(this.send, this);
      this.init = bind(this.init, this);
      $W(this);
      this.cid = 0;
    }

    Sms.prototype.init = function() {};

    Sms.prototype.send = function*(messages, sender) {
      var check, data, first, i, j, k, len, len1, len2, m, que, ref, ref1, ref2, ret, t;
      if (sender == null) {
        sender = 'lessonhome';
      }
      for (i = 0, len = messages.length; i < len; i++) {
        m = messages[i];
        m.phone = m.phone.replace(/\D/gmi, '');
        if (m.phone.length === 10) {
          m.phone = '8' + m.phone;
        }
        m.clientId = this.cid++;
        m.sender = sender;
      }
      data = {
        login: 'z1444311727400',
        password: '279215',
        messages: messages
      };
      ret = (yield Q.ninvoke(_rj_c, 'post', 'send/', data));
      t = new Date().getTime();
      if (ret.body == null) {
        throw new Error("Failed sms");
      }
      if (ret.body.status !== 'ok') {
        throw ret.body;
      }
      console.log(ret.body);
      first = ret.body;
      check = {
        login: 'z1444311727400',
        password: '279215',
        messages: []
      };
      ref = ret.body.messages;
      for (j = 0, len1 = ref.length; j < len1; j++) {
        m = ref[j];
        check.messages.push({
          clientId: m.clientId,
          smscId: m.smscId
        });
      }
      (yield Q.delay(100));
      que = true;
      while (que) {
        que = false;
        ret = (yield Q.ninvoke(_rj_c, 'post', 'status/', check));
        if (ret.body == null) {
          throw new Error('Failed sms');
        }
        if (ret.body.status !== 'ok') {
          throw ret.body;
        }
        console.log(ret.body, (new Date().getTime()) - t);
        ref1 = ret.body.messages;
        for (k = 0, len2 = ref1.length; k < len2; k++) {
          m = ref1[k];
          if (m.status === 'queued') {
            que = true;
            (yield Q.delay(500));
            break;
          }
        }
        if ((new Date().getTime() - t) > (1000 * 30)) {
          break;
        }
      }
      return (ref2 = [first, ret != null ? ret.body : void 0]) != null ? ref2 : {};
    };

    return Sms;

  })();

  module.exports = Sms;

}).call(this);
