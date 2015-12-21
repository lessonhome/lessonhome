(function() {
  var FileUpload, _convert, _express, _identify, _resize, _upload, bodyParser, im,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    slice = [].slice;

  _upload = require('jquery-file-upload-middleware');

  _express = require('express');

  bodyParser = require('body-parser');

  im = require('imagemagick');

  _convert = Q.denode(im.convert);

  _resize = Q.denode(im.resize);

  _identify = Q.denode(im.identify);

  FileUpload = (function() {
    function FileUpload(site) {
      this.site = site;
      this.parseImage = bind(this.parseImage, this);
      this.uploaded = bind(this.uploaded, this);
      this.done = bind(this.done, this);
      this.onError = bind(this.onError, this);
      this.onDelete = bind(this.onDelete, this);
      this.onEnd = bind(this.onEnd, this);
      this.onAbort = bind(this.onAbort, this);
      this.onBegin = bind(this.onBegin, this);
      this.next = bind(this.next, this);
      this.handler = bind(this.handler, this);
      this.res404 = bind(this.res404, this);
      this.init = bind(this.init, this);
      this.dir = "www/" + this.site.name + "/static/user_data";
      Wrap(this);
    }

    FileUpload.prototype.init = function() {
      this.app = _express();
      _upload.configure({
        tmpDir: ".cache/",
        uploadDir: this.dir + "/temp",
        uploadUrl: '/upload/image',
        maxPostSize: 1024 * 1024 * 200,
        minFileSize: 1,
        maxFileSize: 1024 * 1024 * 200,
        acceptFileTypes: /(gif|jpe?g|png|pdf|doc|docx|bmp)/i,
        imageArgs: ['-auto-orient'],
        imageTypes: /\.(gif|jpe?g|png|bmp)$/i,
        accessControl: {
          allowOrigin: '*',
          allowMethods: 'OPTIONS, HEAD, GET, POST, PUT'
        }
      });
      _upload.on('begin', this.onBegin);
      _upload.on('abort', this.onAbort);
      _upload.on('end', this.onEnd);
      _upload.on('delete', this.onDelete);
      _upload.on('error', this.onError);
      this.app.use(bodyParser.json());
      this.app.get('/upload/image', function(req, res) {
        return res.redirect('/');
      });
      this.app.put('/upload/image', function(req, res) {
        return res.redirect('/');
      });
      this.app["delete"]('/upload/image', function(req, res) {
        return res.redirect('/');
      });
      return this.app.use('/upload/image', (function(_this) {
        return function(req, res, next) {
          return Q.spawn(function*() {
            var ref;
            if (!(req != null ? (ref = req.user) != null ? ref.tutor : void 0 : void 0)) {
              return _this.res404(req, res);
            }
            (yield _mkdirp((_this.dir + "/temp/") + req.user.id + '/image'));
            return _upload.fileHandler({
              uploadDir: (_this.dir + "/temp/") + req.user.id + '/image'
            })(req, res, next);
          });
        };
      })(this));
    };

    FileUpload.prototype.res404 = function(req, res) {
      res.statusCode = 404;
      return res.end();
    };

    FileUpload.prototype.handler = function(req, res) {
      return this.app.handle(req, res, this.done);
    };

    FileUpload.prototype.next = function() {
      var args;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    };

    FileUpload.prototype.onBegin = function(info, req, res) {
      return this.log(info);
    };

    FileUpload.prototype.onAbort = function(info, req, res) {
      return this.log(info);
    };

    FileUpload.prototype.onEnd = function(info, req, res) {
      return this.log(info);
    };

    FileUpload.prototype.onDelete = function(info, req, res) {
      return this.log(info);
    };

    FileUpload.prototype.onError = function(e, req, res) {
      return this.error(e);
    };

    FileUpload.prototype.done = function() {
      return this.log();
    };

    FileUpload.prototype.uploaded = function*(req, res) {
      var arr, avatar, db, el, exist, f, field, files, hash, hash_news, i, j, k, key, l, len, len1, len2, len3, len4, m, o, old, params, person, personsDb, qs, ref, ref1, ref2, ref3, ref4, ref5, ref6, set, uploaded, uploadedDb, url, user_upload;
      if (!((ref = req.user) != null ? ref.tutor : void 0)) {
        return;
      }
      db = (yield Main.service('db'));
      personsDb = (yield db.get('persons'));
      uploadedDb = (yield db.get('uploaded'));
      qs = require('querystring');
      url = require('url');
      if (req.originalUrl != null) {
        params = qs.parse(url.parse(req.originalUrl).query);
      } else {
        params = {};
      }
      (yield _mkdirp((this.dir + "/temp/") + req.user.id + "/image"));
      files = (yield _readdir((this.dir + "/temp/") + req.user.id + "/image"));
      if (files.length) {
        arr = [];
        qs = [];
        (yield _mkdirp(this.dir + "/images"));
        for (i = 0, len = files.length; i < len; i++) {
          f = files[i];
          hash = ((yield md5file((this.dir + "/temp/") + req.user.id + '/image/' + f))).substr(0, 10);
          console.log(hash);
          o = {
            hash: hash,
            original: hash + ".jpg",
            high: hash + "h.jpg",
            low: hash + "l.jpg",
            name: f,
            tdir: (this.dir + "/temp/") + req.user.id + '/image/',
            ndir: this.dir + "/images/"
          };
          arr.push(o);
          qs.push(this.parseImage(o));
        }
        (yield Q.all(qs));
        uploaded = [];
        hash_news = [];
        person = (yield _invoke(personsDb.find({
          account: req != null ? (ref1 = req.user) != null ? ref1.id : void 0 : void 0
        }), 'toArray'));
        person = (ref2 = person[0]) != null ? ref2 : {};
        user_upload = (ref3 = person.uploaded) != null ? ref3 : {};
        for (j = 0, len1 = arr.length; j < len1; j++) {
          o = arr[j];
          uploaded.push({
            hash: o.hash,
            account: req.user.id,
            type: 'image',
            name: o.name,
            dir: o.ndir,
            width: o.owidth,
            height: o.oheight,
            url: Feel["static"].F(this.site.name, "user_data/images/" + o.original)
          }, {
            hash: o.hash + 'low',
            account: req.user.id,
            type: 'image',
            name: o.name,
            dir: o.ndir,
            width: o.lwidth,
            height: o.lheight,
            url: Feel["static"].F(this.site.name, "user_data/images/" + o.low)
          }, {
            hash: o.hash + 'high',
            account: req.user.id,
            type: 'image',
            name: o.name,
            dir: o.ndir,
            width: o.hwidth,
            height: o.hheight,
            url: Feel["static"].F(this.site.name, "user_data/images/" + o.high)
          });
          hash_news.push(o.hash);
          user_upload[o.hash] = {
            type: 'image',
            original: o.hash,
            low: o.hash + 'low',
            high: o.hash + 'high',
            original_url: Feel["static"].F(this.site.name, "user_data/images/" + o.original),
            low_url: Feel["static"].F(this.site.name, "user_data/images/" + o.low),
            high_url: Feel["static"].F(this.site.name, "user_data/images/" + o.high)
          };
        }
        if (uploaded.length) {
          (yield _invoke(uploadedDb, 'insert', uploaded));
          (yield _invoke(personsDb, 'update', {
            account: req.user.id
          }, {
            $set: {
              uploaded: user_upload
            }
          }, {
            upsert: true
          }));
          set = null;
          field = null;
          old = null;
          switch ('true') {
            case params.avatar:
              set = {
                avatar: field = []
              };
              old = (ref4 = person.avatar) != null ? ref4 : [];
              break;
            case params.documents:
              set = {
                documents: field = []
              };
              old = (ref5 = person.documents) != null ? ref5 : [];
              break;
            default:
              set = {
                photos: field = []
              };
              old = (ref6 = person.photos) != null ? ref6 : [];
          }
          exist = {};
          for (k = 0, len2 = hash_news.length; k < len2; k++) {
            key = hash_news[k];
            exist[key] = true;
          }
          for (l = 0, len3 = old.length; l < len3; l++) {
            key = old[l];
            if (!exist[key]) {
              field.push(key);
            }
          }
          for (m = 0, len4 = hash_news.length; m < len4; m++) {
            key = hash_news[m];
            field.push(key);
          }
          exist = null;
          (yield _invoke(personsDb, 'update', {
            account: req.user.id
          }, {
            $set: set
          }, {
            upsert: true
          }));
        }
      }
      (yield this.site.form.flush(['person'], req, res));
      res.setHeader('content-type', 'application/json');
      avatar = (yield _invoke(personsDb.find({
        account: req.user.id
      }, {
        avatar: 1
      }), 'toArray'));
      avatar = avatar[0].avatar;
      if ((avatar != null) && avatar.length) {
        avatar = avatar[avatar.length - 1];
        el = (yield _invoke(uploadedDb.find({
          hash: avatar + 'high'
        }), 'toArray'));
        el = el[0];
        return res.end(JSON.stringify({
          url: el.url,
          width: el.width,
          height: el.height,
          uploaded: uploaded
        }));
      } else {
        return res.end(JSON.stringify({
          uploaded: uploaded
        }));
      }
    };

    FileUpload.prototype.parseImage = function*(o) {
      var qs, ref, sh, sl, so;
      qs = [];
      qs.push(_resize({
        srcPath: o.tdir + o.name,
        dstPath: o.ndir + o.high,
        width: 720,
        quality: 0.8
      }));
      qs.push(_resize({
        srcPath: o.tdir + o.name,
        dstPath: o.ndir + o.low,
        width: 200,
        quality: 0.8
      }));
      (yield Q.all(qs));
      qs = [];
      qs.push(_identify(o.ndir + o.low));
      qs.push(_identify(o.ndir + o.high));
      (yield _fs_copy(o.tdir + o.name, o.ndir + o.original));
      (yield _fs_remove(o.tdir + o.name));
      qs.push(_identify(o.ndir + o.original));
      ref = (yield Q.all(qs)), sl = ref[0], sh = ref[1], so = ref[2];
      o.owidth = so.width;
      o.oheight = so.height;
      o.hwidth = sh.width;
      o.hheight = sh.height;
      o.lwidth = sl.width;
      return o.lheight = sl.height;
    };

    return FileUpload;

  })();

  module.exports = FileUpload;


  /*
    uploaded :
      {
        hash: 'hashxxx'
        name : 'asfasf'
        dir : 'asfas/asfasf/asf'
        account : 'asd'
        type: 'image'
        width: 1920
        height: 1200
        url: 'afaf/asfasf/asfasf/aasf.jpg'
        low : {
          width: 200
          height: 125
          url: 'afaf/asfasf/asfasf/aasflow.jpg'
        }
        high; {
          width: 720
          height: 450
          url: 'afaf/asfasf/asfasf/aasfhigh.jpg'
        }
      }
  
      {
        hash : 'hashxxx'
        account : 'asd'
        type : 'image'
        path  : ''
      }
      {
        hash : 'hashxxxlow'
        account : 'asd'
        type : 'image'
        path  : ''
      }
    persons
      {
        avatar : 'hashxxx'
        photos : ['hashxxx','hashxxx2']
        uploaded : {
          'hashxxx' : {
            type : 'image'
            original : 'hashxxx'
            low : 'hashxxxlow'
            high : 'hashxxxhigh'
            original_url : '/file/hashxxx/hashxxx.jpg'
          }
        }
      }
   */

}).call(this);
