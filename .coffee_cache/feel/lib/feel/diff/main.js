(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.main = (function() {
    function main() {
      this.match = bind(this.match, this);
      this.metroPrepare = bind(this.metroPrepare, this);
      this.metroCmp = bind(this.metroCmp, this);
      this.prepare = bind(this.prepare, this);
      if (this.js == null) {
        this.js = {};
      }
      this.js.diff_match_patch = require('./diff_match_patch').diff_match_patch;
      this.js.toEn = require('./rusLat').toEn;
    }

    main.prototype.prepare = function(w) {
      return this.js.toEn(w.replace(/[^\s\w\@\-а-яА-ЯёЁ]/gim, ' ').replace(/\s+/g, ' ').replace(/^\s+/g, '').replace(/\s+$/g, '')).toLowerCase();
    };

    main.prototype.metroCmp = function(str1, str2) {
      return this.match(this.metroPrepare(str1), this.metroPrepare(str2));
    };

    main.prototype.metroPrepare = function(str) {
      str = str.replace(/^[^\.]*\./, '');
      str = str.replace(/\s/gmi, '');
      str = str.replace(/ё/gmi, 'е');
      str = this.prepare(str);
      str = str.replace('ploshchad', '');
      str = str.replace('prospekt', '');
      str = str.replace('bulvar', '');
      str = str.replace('ulica', '');
      return str;
    };

    main.prototype.match = function(text, word, from, to, count) {
      var _t, dmp, dmp1, dmp2, i, j, m, m2, ntext, nword, ref, th;
      if (from == null) {
        from = 0;
      }
      if (to == null) {
        to = 0.45;
      }
      if (count == null) {
        count = 30;
      }
      ntext = this.js.toEn(text);
      nword = this.js.toEn(word);
      if (ntext.length < nword.length) {
        _t = ntext;
        ntext = nword;
        nword = _t;
      }
      if (nword.length === 0) {
        return 0;
      }

      /*
      unless d?
        d = 0
        l = nword.length
        d = 1 if l > 1
        d = 2 if l > 3
        d = 3 if l > 6
        d = 4 if l > 8
        d = 5 if l > 11
       */
      dmp = new this.js.diff_match_patch();
      dmp.Match_Distance = 100;
      for (i = j = 0, ref = count; 0 <= ref ? j <= ref : j >= ref; i = 0 <= ref ? ++j : --j) {
        th = from + (to - from) * i / count;
        dmp.Match_Threshold = th;
        m = dmp.match_bitap_(ntext, nword, 0);
        if (m >= 0) {
          break;
        }
      }
      if (m < 0) {
        th = -1;
      }
      return th;
      dmp1 = new this.js.diff_match_patch();
      dmp1.Match_Distance = d1;
      dmp1.Match_Threshold = t1;
      m = dmp1.match_main(ntext, nword, 0);
      console.log('m', m, ntext, nword, ntext.substring(m, m + nword.length));
      if (!(m < 0)) {
        dmp2 = new this.js.diff_match_patch();
        dmp2.Match_Distance = d2;
        dmp2.Match_Threshold = t2;
        m2 = dmp1.match_main(ntext, nword, m);
        console.log('m2', m2, ntext, nword, ntext.substring(m2, m2 + nword.length));
        if (!(m2 < 0)) {
          return true;
        }
      }
      return false;
    };

    return main;

  })();

  module.exports = new this.main;

}).call(this);
