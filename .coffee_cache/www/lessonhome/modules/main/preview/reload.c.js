(function() {
  var age;

  age = (function(_this) {
    return function(date1, date2) {
      var days, months, years;
      years = date2.getFullYear() - date1.getFullYear();
      months = years * 12 + date2.getMonth() - date1.getMonth();
      days = date2.getDate() - date1.getDate();
      years -= date2.getMonth() < date1.getMonth();
      months -= date2.getDate() < date1.getDate();
      days += days < 0 ? new Date(date2.getFullYear(), date2.getMonth() - 1, 0).getDate() + 1 : 0;
      return {
        years: years,
        months: months,
        days: days
      };
    };
  })(this);

  this.reload = function*() {
    var Awords, aa, ab, ac, acc, account, account_, ad, ae, af, ava, avatar, awords, cLeft, cRight, d, def, el, f, i, ind, j, k, key, l, lang, len, len1, len10, len11, len12, len13, len14, len2, len3, len4, len5, len6, len7, len8, len9, m, media, n, name, ns, o, obj, p, person, persons, photo, place, plast, prices, q, r, ref, ref1, ref10, ref11, ref12, ref13, ref14, ref15, ref16, ref17, ref18, ref19, ref2, ref20, ref21, ref22, ref23, ref24, ref25, ref26, ref27, ref28, ref29, ref3, ref30, ref31, ref32, ref33, ref34, ref35, ref36, ref37, ref38, ref39, ref4, ref40, ref41, ref42, ref43, ref44, ref45, ref46, ref47, ref48, ref49, ref5, ref50, ref51, ref52, ref53, ref54, ref55, ref56, ref57, ref58, ref59, ref6, ref60, ref61, ref62, ref63, ref64, ref65, ref66, ref67, ref68, ref69, ref7, ref70, ref71, ref72, ref73, ref74, ref75, ref76, ref77, ref78, ref79, ref8, ref80, ref81, ref82, ref83, ref84, ref85, ref86, ref87, ref88, ref89, ref9, rgleft, rgmin, rgs, rgtop, rmax, rmin, s, sbj, sname, ss, ss2, str, t, tag, tutor, u, v, val, w, word, words, x, y, z;
    t = new Date().getTime();
    if (!((t - this.timereload) > (1000 * 10))) {
      return this.persons;
    }
    this.timereload = t;
    account_ = _invoke(this.dbaccounts.find({}), 'toArray');
    tutor = _invoke(this.dbtutor.find({}), 'toArray');
    person = _invoke(this.dbpersons.find({
      hidden: {
        $ne: true
      }
    }), 'toArray');
    ref = [(yield tutor), (yield person), (yield account_)], tutor = ref[0], person = ref[1], account_ = ref[2];
    persons = {};
    for (j = 0, len = tutor.length; j < len; j++) {
      val = tutor[j];
      if (!(val != null ? val.account : void 0)) {
        continue;
      }
      if (persons[name = val.account] == null) {
        persons[name] = {};
      }
      persons[val.account].tutor = val;
    }
    for (m = 0, len1 = person.length; m < len1; m++) {
      val = person[m];
      if (!(val != null ? val.account : void 0)) {
        continue;
      }
      if (persons[val.account] == null) {
        continue;
      }
      persons[val.account].person = val;
    }
    for (n = 0, len2 = account_.length; n < len2; n++) {
      val = account_[n];
      if (!(val != null ? val.id : void 0)) {
        continue;
      }
      if (persons[val.id] == null) {
        continue;
      }
      persons[val.id].account = val;
    }
    for (account in persons) {
      obj = persons[account];
      t = obj.tutor;
      p = obj.person;
      obj.rating = JSON.stringify(obj).length * ((ref1 = obj != null ? (ref2 = obj.person) != null ? ref2.ratio : void 0 : void 0) != null ? ref1 : 1.0);
      obj.nophoto = false;
      if (((ref3 = obj.person) != null ? (ref4 = ref3.avatar) != null ? ref4[0] : void 0 : void 0) == null) {
        obj.rating *= 0.5;
        obj.nophoto = true;
      }
      if (!(((ref5 = (ref6 = (ref7 = obj.tutor) != null ? ref7.about : void 0) != null ? ref6 : "") != null ? ref5.length : void 0) > 10)) {
        obj.rating *= 0.5;
      }
      rmax = Math.max(rmax != null ? rmax : obj.rating, obj.rating);
      rmin = Math.min(rmin != null ? rmin : obj.rating, obj.rating);
      if (((t != null ? (ref8 = t.subjects) != null ? (ref9 = ref8[0]) != null ? ref9.name : void 0 : void 0 : void 0) || (t != null ? (ref10 = t.subjects) != null ? (ref11 = ref10[1]) != null ? ref11.name : void 0 : void 0 : void 0)) && (p != null ? p.first_name : void 0)) {
        continue;
      }
      delete persons[account];
    }
    for (account in persons) {
      o = persons[account];
      t = o != null ? o.tutor : void 0;
      p = o != null ? o.person : void 0;
      obj = {};
      obj.login = o != null ? (ref12 = o.account) != null ? ref12.login : void 0 : void 0;
      obj.index = o.account.index;
      obj.registerTime = (ref13 = (ref14 = o.account.registerTime) != null ? typeof ref14.getTime === "function" ? ref14.getTime() : void 0 : void 0) != null ? ref13 : 0;
      obj.accessTime = (ref15 = (ref16 = o.account.accessTime) != null ? typeof ref16.getTime === "function" ? ref16.getTime() : void 0 : void 0) != null ? ref15 : 0;
      obj.rating = o.rating;
      obj.check_out_the_areas = (ref17 = t != null ? t.check_out_the_areas : void 0) != null ? ref17 : [];
      obj.ratio = (ref18 = p.ratio) != null ? ref18 : 1.0;
      obj.nophoto = o.nophoto;
      obj.account = account;
      obj.landing = (ref19 = p.landing) != null ? ref19 : false;
      obj.mcomment = p.mcomment || '';
      obj.filtration = (ref20 = p.filtration) != null ? ref20 : false;
      obj.phone = p.phone;
      obj.email = p.email;
      obj.name = {};
      obj.name.first = p != null ? p.first_name : void 0;
      obj.slogan = t != null ? t.slogan : void 0;
      obj.interests = p != null ? p.interests : void 0;
      obj.reviews = p != null ? p.reviews : void 0;
      obj.name.last = p != null ? p.last_name : void 0;
      obj.name.middle = p != null ? p.middle_name : void 0;
      obj.work = p != null ? p.work : void 0;
      obj.about = (t != null ? t.about : void 0) || "";
      obj.check_out_the_areas = t != null ? t.check_out_the_areas : void 0;
      obj.subjects = {};
      if (p.birthday) {
        obj.age = (ref21 = age(p.birthday, new Date())) != null ? ref21.years : void 0;
      }
      obj.education = p.education;
      obj.gender = p.sex;
      obj.place = {};
      obj.reason = t != null ? t.reason : void 0;
      obj.left_price = null;
      obj.right_price = null;
      cLeft = function(p, time, exists) {
        if (time == null) {
          time = 60;
        }
        if (exists == null) {
          exists = true;
        }
        if (!(p && (p > 0))) {
          return;
        }
        if (obj.left_price && (!exists)) {
          return;
        }
        p *= 60 / time;
        if ((obj.left_price > p) || (!obj.left_price)) {
          return obj.left_price = p;
        }
      };
      cRight = function(p, time, exists) {
        if (time == null) {
          time = 60;
        }
        if (exists == null) {
          exists = true;
        }
        if (!(p && (p > 0))) {
          return;
        }
        if (obj.right_price && (!exists)) {
          return;
        }
        p *= 60 / time;
        if ((obj.right_price < p) || (!obj.right_price)) {
          return obj.right_price = p;
        }
      };
      obj.newl = null;
      obj.newr = null;
      obj.ordered_subj = [];
      ref22 = t != null ? t.subjects : void 0;
      for (ind in ref22) {
        val = ref22[ind];
        obj.ordered_subj.push(val.name);
        ns = obj.subjects[val.name] = {};
        ns.description = val.description;
        ns.reason = val.reason;
        ns.slogan = val.slogan;
        ns.tags = val.tags;
        ns.course = val.course;
        ns.price = {
          left: +((ref23 = val.price) != null ? (ref24 = ref23.range) != null ? ref24[0] : void 0 : void 0)
        };
        ns.price.right = +((ref25 = (ref26 = val.price) != null ? (ref27 = ref26.range) != null ? ref27[1] : void 0 : void 0) != null ? ref25 : ns.price.left);
        ns.duration = {};
        d = (ref28 = val.price) != null ? ref28.duration : void 0;
        if ((d != null ? d.left : void 0) != null) {
          d = [d != null ? d.left : void 0, d != null ? d.right : void 0];
          if (d[1] == null) {
            d[1] = d[0];
          }
        }
        if ((typeof d === 'string') && d) {
          o = d.match(/^\D*(\d*)?\D*(\d*)?/);
          d = [];
          if (o[1] != null) {
            d.push(o[1]);
          }
          if (((ref29 = o[2]) != null ? ref29 : o[1]) != null) {
            d.push((ref30 = o[2]) != null ? ref30 : o[1]);
          }
        }
        if (!((+(d != null ? d[0] : void 0)) > 1)) {
          d = [60, 120];
        }
        if (!((+(d != null ? d[1] : void 0)) > 1)) {
          d[1] = d[0] + 30;
        }
        ns.duration = {
          left: d[0],
          right: d[1]
        };
        def = 800;
        if (!(((ref31 = ns.price) != null ? ref31.right : void 0) > 0)) {
          if ((ref32 = ns.price) != null) {
            ref32.right = 900 * 3;
          }
        }
        if (!(((ref33 = ns.price) != null ? ref33.left : void 0) > 0)) {
          if ((ref34 = ns.price) != null) {
            ref34.left = 600;
          }
        }
        if (!(((ref35 = ns.duration) != null ? ref35.right : void 0) > 0)) {
          if ((ref36 = ns.duration) != null) {
            ref36.right = 180;
          }
        }
        if (!(((ref37 = ns.duration) != null ? ref37.left : void 0) > 0)) {
          if ((ref38 = ns.duration) != null) {
            ref38.left = 90;
          }
        }
        ns.place_prices = {};
        ref39 = val.place_prices;
        for (place in ref39) {
          prices = ref39[place];
          ns.place_prices[place] = {};
          if (prices[0] !== '') {
            ns.place_prices[place]['v60'] = prices[0];
          }
          if (prices[1] !== '') {
            ns.place_prices[place]['v90'] = prices[1];
          }
          if (prices[2] !== '') {
            ns.place_prices[place]['v120'] = prices[2];
          }
          cLeft(prices[0]);
          cLeft(prices[1], 90, false);
          cLeft(prices[2], 120, false);
          cRight(prices[0]);
          cRight(prices[1], 90, false);
          cRight(prices[2], 120, false);
        }
        l = ((ref40 = ns.price) != null ? ref40.left : void 0) * 60 / ((ref41 = ns.duration) != null ? ref41.left : void 0);
        r = ((ref42 = ns.price) != null ? ref42.right : void 0) * 60 / ((ref43 = ns.duration) != null ? ref43.right : void 0);
        if ((!obj.newl) || (obj.newl > l)) {
          obj.newl = l;
        }
        if ((!obj.newr) || (obj.newr > r)) {
          obj.newr = r;
        }
        ns.price_per_hour = 0.5 * (r + l);
        obj.price_left = Math.round(Math.min((ref44 = obj.price_left) != null ? ref44 : (ref45 = ns.price) != null ? ref45.left : void 0, (ref46 = ns.price) != null ? ref46.left : void 0) / 50) * 50;
        obj.price_right = Math.round(Math.max((ref47 = obj.price_right) != null ? ref47 : (ref48 = ns.price) != null ? ref48.right : void 0, (ref49 = ns.price) != null ? ref49.right : void 0) / 50) * 50;
        obj.duration_left = Math.round(Math.min((ref50 = obj.duration_left) != null ? ref50 : (ref51 = ns.duration) != null ? ref51.left : void 0, (ref52 = ns.duration) != null ? ref52.left : void 0) / 15) * 15;
        obj.duration_right = Math.round(Math.max((ref53 = obj.duration_right) != null ? ref53 : (ref54 = ns.duration) != null ? ref54.right : void 0, (ref55 = ns.duration) != null ? ref55.right : void 0) / 15) * 15;
        obj.price_per_hour = Math.round(ns.price_per_hour / 50) * 50;
        ref56 = val != null ? val.place : void 0;
        for (key in ref56) {
          val = ref56[key];
          obj.place[val] = true;
        }
      }
      cLeft(obj.newl, 60, false);
      cRight(obj.newr, 60, false);
      obj.left_price = Math.round(obj.left_price / 50) * 50;
      obj.right_price = Math.round(obj.right_price / 50) * 50;
      obj.experience = t != null ? t.experience : void 0;
      if (!obj.experience || (obj.experience === 'неважно')) {
        obj.experience = '1-2 года';
      }
      obj.status = t != null ? t.status : void 0;
      obj.media = [];
      if (p.photos) {
        ref57 = p.photos;
        for (q = 0, len3 = ref57.length; q < len3; q++) {
          photo = ref57[q];
          media = (yield _invoke(this.dbuploaded.find({
            hash: {
              $in: [photo + 'low', photo + 'high']
            }
          }), 'toArray'));
          if ((media[0] != null) && media[1]) {
            obj.media.push({
              lwidth: media[0].width,
              lheight: media[0].height,
              lurl: media[0].url,
              hheight: media[1].height,
              hwidth: media[1].width,
              hurl: media[1].url
            });
          }
        }
      }
      obj.photos = [];
      if (p.avatar) {
        ref58 = p.avatar;
        for (u = 0, len4 = ref58.length; u < len4; u++) {
          ava = ref58[u];
          avatar = (yield _invoke(this.dbuploaded.find({
            hash: {
              $in: [ava + 'low', ava + 'high']
            }
          }), 'toArray'));
          if ((avatar[0] != null) && (avatar[1] != null)) {
            obj.photos.push({
              lwidth: avatar[0].width,
              lheight: avatar[0].height,
              lurl: avatar[0].url,
              hheight: avatar[1].height,
              hwidth: avatar[1].width,
              hurl: avatar[1].url
            });
          }
        }
      }
      if (!obj.photos.length) {
        obj.photos.push({
          lwidth: 130,
          lheight: 163,
          lurl: "/file/f1468c11ce/unknown.photo.gif",
          hheight: 163,
          hwidth: 130,
          hurl: "/file/f1468c11ce/unknown.photo.gif"
        });
      }
      obj.location = p.location;
      persons[account] = obj;
    }
    if (rmin == null) {
      rmin = 0;
    }
    if (rmax == null) {
      rmax = 1;
    }
    if (rmax <= rmin) {
      rmax = rmin + 1;
    }
    rgtop = 5.5;
    rgs = 3;
    rgmin = 4;
    rgleft = 1 / (rgmin - rgtop);
    for (acc in persons) {
      p = persons[acc];
      p.ratingMax = rmax;
      p.ratingNow = p.rating;
      plast = p.rating;
      p.rating = (p.rating - rmin) / (rmax - rmin);
      p.rating = -1 / (p.rating * rgs - rgleft) + rgtop;
      p.rmin = rmin;
      p.rmax = rmax;
      p.sorts = {};
      ss = Object.keys((ref59 = p.subjects) != null ? ref59 : {});
      ss2 = [];
      for (v = 0, len5 = ss.length; v < len5; v++) {
        s = ss[v];
        s = s.split(/[,;\.]/);
        for (x = 0, len6 = s.length; x < len6; x++) {
          k = s[x];
          k = k.replace(/^\s+/, '');
          k = k.replace(/\s+$/, '');
          if (k) {
            ss2.push(k);
          }
        }
      }
      ss = ss2;
      if (p != null ? (ref60 = p.name) != null ? ref60.first : void 0 : void 0) {
        ss.push(p.name.first);
      }
      if (p != null ? (ref61 = p.name) != null ? ref61.middle : void 0 : void 0) {
        ss.push(p.name.middle);
      }
      if (p != null ? (ref62 = p.name) != null ? ref62.last : void 0 : void 0) {
        ss.push(p.name.last);
      }
      words = {};
      for (y = 0, len7 = ss.length; y < len7; y++) {
        s = ss[y];
        words[s] = true;
      }
      p.words = Object.keys(words);
      lang = false;
      ref63 = p.words;
      for (i = z = 0, len8 = ref63.length; z < len8; i = ++z) {
        w = ref63[i];
        if (w.match(/язык$/g)) {
          lang = true;
          p.words[i] = w.replace(/язык$/g, '');
        }
      }
      if (lang) {
        p.words.push('языки');
        p.words.push('иностранный');
      }
      awords = "";
      ref65 = (ref64 = p.location) != null ? ref64 : {};
      for (k in ref65) {
        str = ref65[k];
        awords += ' ' + (str != null ? str : '');
      }
      ref67 = (ref66 = p.interests) != null ? ref66 : [];
      for (aa = 0, len9 = ref67.length; aa < len9; aa++) {
        el = ref67[aa];
        for (k in el) {
          str = el[k];
          if (typeof str === 'string') {
            awords += ' ' + (str != null ? str : '');
          }
        }
      }
      ref69 = (ref68 = p.check_out_the_areas) != null ? ref68 : [];
      for (ab = 0, len10 = ref69.length; ab < len10; ab++) {
        el = ref69[ab];
        for (k in el) {
          str = el[k];
          if (typeof str === 'string') {
            awords += ' ' + (str != null ? str : '');
          }
        }
      }
      ref71 = (ref70 = p.education) != null ? ref70 : [];
      for (ac = 0, len11 = ref71.length; ac < len11; ac++) {
        el = ref71[ac];
        for (k in el) {
          str = el[k];
          if (typeof str === 'string') {
            awords += ' ' + (str != null ? str : '');
          }
        }
      }
      ref73 = (ref72 = p.work) != null ? ref72 : [];
      for (ad = 0, len12 = ref73.length; ad < len12; ad++) {
        el = ref73[ad];
        for (k in el) {
          str = el[k];
          if (typeof str === 'string') {
            awords += ' ' + (str != null ? str : '');
          }
        }
      }
      ref74 = p.name;
      for (k in ref74) {
        str = ref74[k];
        if (typeof str === 'string') {
          awords += ' ' + (str != null ? str : '');
        }
      }
      ref75 = p.phone;
      for (k in ref75) {
        str = ref75[k];
        if (typeof str === 'string') {
          awords += ' ' + ((ref76 = typeof str.replace === "function" ? str.replace(/\D/gmi, '').substr(-10) : void 0) != null ? ref76 : '');
        }
      }
      ref77 = p.email;
      for (k in ref77) {
        str = ref77[k];
        if (typeof str === 'string') {
          awords += ' ' + (str != null ? str : '');
        }
      }
      if (typeof p.reason === 'string') {
        awords += " " + ((ref78 = p.reason) != null ? ref78 : '');
      }
      if (typeof p.slogan === 'string') {
        awords += " " + ((ref79 = p.slogan) != null ? ref79 : '');
      }
      if (typeof p.about === 'string') {
        awords += " " + ((ref80 = p.about) != null ? ref80 : '');
      }
      if (typeof p.login === 'string') {
        awords += " " + ((ref81 = p.login) != null ? ref81 : '');
      }
      if (typeof p.login === 'string') {
        awords += " " + ((ref82 = (ref83 = p.login) != null ? typeof ref83.replace === "function" ? ref83.replace(/\D/gmi, '').substr(-10) : void 0 : void 0) != null ? ref82 : '');
      }
      ref84 = p.subjects;
      for (sname in ref84) {
        sbj = ref84[sname];
        awords += ' ' + sname;
        ref86 = (ref85 = sbj.course) != null ? ref85 : [];
        for (ae = 0, len13 = ref86.length; ae < len13; ae++) {
          el = ref86[ae];
          awords += ' ' + (el != null ? el : '');
          awords += ' ' + ((ref87 = sbj.description) != null ? ref87 : '');
          for (tag in sbj.tags) {
            awords += ' ' + tag;
          }
        }
      }
      awords = awords.replace(/[^\s\w\@\-а-яА-ЯёЁ]/gim, ' ');
      awords = awords.replace(/\s+/gi, ' ');
      awords = awords.replace(/^\s+/gi, '');
      awords = awords.replace(/\s+$/gi, '');
      awords = awords.split(' ');
      Awords = {};
      for (af = 0, len14 = awords.length; af < len14; af++) {
        word = awords[af];
        Awords[_diff.prepare(word)] = true;
      }
      awords = Awords;
      p.awords = awords;
    }
    this.persons = persons;
    this.index = {};
    if (this.filters == null) {
      this.filters = {};
    }
    ref88 = this.filters;
    for (key in ref88) {
      f = ref88[key];
      f.redis = true;
    }
    Q.spawn((function(_this) {
      return function*() {
        return (yield _this.refilterRedis());
      };
    })(this));
    ref89 = this.persons;
    for (key in ref89) {
      val = ref89[key];
      this.index[val.index] = val;
    }
    Q.spawn((function(_this) {
      return function*() {
        return (yield _invoke(_this.redis, 'set', 'persons', JSON.stringify(_this.persons)));
      };
    })(this));
    return this.persons;
  };

}).call(this);
