(function() {
  var Mail, nodemail,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  nodemail = require('nodemailer');

  Mail = (function() {
    function Mail() {
      this.prepareCss = bind(this.prepareCss, this);
      this.reload = bind(this.reload, this);
      Wrap(this);
      this.templates = {};
      this.attachments = {};
    }

    Mail.prototype.init = function() {
      return this.reload().done();
    };

    Mail.prototype.reload = function*() {
      var failed, file, files, i, len, results;
      files = (yield _readdir(process.cwd() + '/www/lessonhome/mails'));
      results = [];
      for (i = 0, len = files.length; i < len; i++) {
        file = files[i];
        failed = true;
        results.push((yield* (function*() {
          var results1;
          results1 = [];
          while (failed) {
            failed = (yield this.prepareCss(file));
            if (failed) {
              (yield Q.delay(1000));
              results1.push(console.error('mail preloading failed'));
            } else {
              results1.push(void 0);
            }
          }
          return results1;
        }).call(this)));
      }
      return results;
    };

    Mail.prototype.prepareCss = function*(file) {
      var body, data, i, image, images, len, rb, ref, ref1, ref2, url;
      this.attachments[file] = [];
      images = {};
      data = (yield _readFile(process.cwd() + '/www/lessonhome/mails/' + file));
      data = data.toString();
      ref = data.match(/{{.+}}/g);
      for (i = 0, len = ref.length; i < len; i++) {
        image = ref[i];
        image = image.replace(/{|}/g, '');
        if (images[image]) {
          continue;
        }
        images[image] = true;
        this.attachments[file].push({
          filename: image.replace(/(\/.+\/)*/, ''),
          path: process.cwd() + '/www/lessonhome/static' + image,
          cid: image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome'
        });
        data = data.replace(new RegExp('{{' + image + '}}', 'g'), '\'cid:' + image.replace(/(\/.+\/)*/, '').replace(/\..+/, '') + '@lessonhome\'');
      }
      rb = (yield _requestPost({
        url: 'http://premailer.dialect.ca/api/0.1/documents',
        form: {
          html: data
        }
      }));
      if (rb[1] != null) {
        body = rb[1];
      } else {
        body = rb.body;
      }
      if (((body != null ? body[0] : void 0) == null) || (body[0] === '<')) {
        return true;
      }
      url = (ref1 = JSON.parse(body)) != null ? (ref2 = ref1.documents) != null ? ref2.html : void 0 : void 0;
      rb = (yield _request({
        url: url
      }));
      if (rb[1] != null) {
        body = rb[1];
      } else {
        body = rb.body;
      }
      this.templates[file] = body;
      return console.log('mail: '.magenta + file + ' was read from mails to Mail.templates');
    };

    Mail.prototype.prepare = function(data, repls) {
      var key, value;
      for (key in repls) {
        value = repls[key];
        data = data != null ? typeof data.replace === "function" ? data.replace(new RegExp('#{' + key + '}', 'g'), value) : void 0 : void 0;
      }
      return data;
    };

    Mail.prototype.send = function*(template, email, subject, repls) {
      var info, mailOptions, transporter;
      console.log('mail: Sending mail to'.yellow, email);
      transporter = nodemail.createTransport({
        service: 'Gmail',
        auth: {
          user: 'support@lessonhome.ru',
          pass: 'Jlth;bvjcnm'
        }
      });
      mailOptions = {
        from: 'Лессон Хоум <support@lessonhome.ru>',
        to: email,
        subject: subject,
        html: (yield this.prepare(this.templates[template], repls)),
        attachments: this.attachments[template]
      };
      info = (yield _invoke(transporter, 'sendMail', mailOptions));
      return console.log('mail: Mail sent'.yellow, info);
    };

    return Mail;

  })();

  module.exports = Mail;

}).call(this);
