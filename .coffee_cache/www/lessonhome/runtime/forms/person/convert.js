(function() {
  var comma, getLayers, month;

  month = ['январь', 'февраль', 'март', 'апрель', 'май', 'июнь', 'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь'];

  getLayers = function(uploaded, data) {
    var HMAX, HMIN, W, a, copy, d, i, j, k, key, l, layer, layers, len, len1, len2, len3, m, n, na, nh, nn, p, photos, ref, ref1, ref2, shift, value;
    if (!(data && uploaded)) {
      return [];
    }
    W = 738;
    HMIN = 150;
    HMAX = 350;
    d = 5;
    layers = [];
    layer = void 0;
    a = 0;
    n = 0;
    photos = [];
    ref = data != null ? data : [];
    for (j = 0, len = ref.length; j < len; j++) {
      p = ref[j];
      copy = {};
      ref1 = uploaded[p];
      for (key in ref1) {
        value = ref1[key];
        copy[key] = value;
      }
      photos.push(copy);
    }
    photos.reverse();
    for (k = 0, len1 = photos.length; k < len1; k++) {
      p = photos[k];
      if (!p) {
        continue;
      }
      if (!layer) {
        a = 0;
        layer = {
          photos: []
        };
      }
      na = a + p.width / p.height;
      nn = n + 1;
      nh = (W - nn * 2 * d) / na;
      if ((nh > HMIN) || (nn <= 1)) {
        layer.photos.push(p);
        if (nh > HMAX) {
          nh = HMAX;
        }
        layer.height = nh;
        n = nn;
        a = na;
      } else {
        layers.push(layer);
        a = p.width / p.height;
        n = 1;
        layer = {
          height: (W - 2 * d) / a,
          photos: [p]
        };
        if (layer.height > HMAX) {
          layer.height = HMAX;
        }
      }
    }
    if (layer) {
      layers.push(layer);
    }
    for (l = 0, len2 = layers.length; l < len2; l++) {
      layer = layers[l];
      shift = 0;
      ref2 = layer.photos;
      for (i = m = 0, len3 = ref2.length; m < len3; i = ++m) {
        p = ref2[i];
        p.left = shift + d;
        shift += p.width * layer.height / p.height + d * 2;
      }
    }
    return layers;
  };

  comma = function(str, next) {
    if (typeof str !== 'string') {
      str = "";
    }
    str = str.replace(/\s+$/, '');
    if (str && (!str.match(/\,$/))) {
      str += ",";
    }
    str += ' ';
    if (next && (typeof next === 'string')) {
      str += next;
    }
    return str;
  };

  this.F2V = (function() {
    function F2V() {}

    F2V.prototype.$birthday = function(data) {
      var ref;
      return data != null ? (ref = data.birthday) != null ? typeof ref.getDate === "function" ? ref.getDate() : void 0 : void 0 : void 0;
    };

    F2V.prototype.$birthmonth = function(data) {
      var ref;
      return month[data != null ? (ref = data.birthday) != null ? typeof ref.getMonth === "function" ? ref.getMonth() : void 0 : void 0 : void 0];
    };

    F2V.prototype.$birthyear = function(data) {
      var ref;
      return data != null ? (ref = data.birthday) != null ? typeof ref.getFullYear === "function" ? ref.getFullYear() : void 0 : void 0 : void 0;
    };

    F2V.prototype.$birthdate = function(data) {
      var d;
      d = data != null ? data.birthday : void 0;
      if (!d) {
        return;
      }
      return (d != null ? typeof d.getDate === "function" ? d.getDate() : void 0 : void 0) + "." + ((d != null ? typeof d.getMonth === "function" ? d.getMonth() : void 0 : void 0) + 1) + "." + (d != null ? typeof d.getFullYear === "function" ? d.getFullYear() : void 0 : void 0);
    };

    F2V.prototype.$firstphone = function(data) {
      var ref;
      return data != null ? (ref = data.phone) != null ? ref[0] : void 0 : void 0;
    };

    F2V.prototype.$phone = function(data) {
      var phone, ref, ref1;
      phone = data != null ? (ref = data.phone) != null ? ref[0] : void 0 : void 0;
      if (!phone && ((data != null ? data.login : void 0) != null)) {
        if (!((ref1 = data.login) != null ? typeof ref1.match === "function" ? ref1.match(/\@/) : void 0 : void 0)) {
          phone = data.login.replace(/[^\d]]/g, "");
          if (phone.length === 7) {
            phone = '495' + phone;
          }
        }
      }
      return phone;
    };

    F2V.prototype.$phone2 = function(data) {
      var ref;
      return data != null ? (ref = data.phone) != null ? ref[1] : void 0 : void 0;
    };

    F2V.prototype.$email = function(data) {
      var email, ref, ref1;
      email = data != null ? (ref = data.email) != null ? ref[0] : void 0 : void 0;
      if (!email && (data != null ? (ref1 = data.login) != null ? ref1.match(/\@/) : void 0 : void 0)) {
        email = data.login;
      }
      return email;
    };

    F2V.prototype.$skype = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.social_networks) != null ? (ref1 = ref.skype) != null ? ref1[0] : void 0 : void 0 : void 0;
    };

    F2V.prototype.$site = function(data) {
      var ref;
      return data != null ? (ref = data.site) != null ? ref[0] : void 0 : void 0;
    };

    F2V.prototype.$avatar = function(data) {
      var ava;
      if ((data.avatar != null) && data.avatar !== []) {
        ava = data.avatar[data.avatar.length - 1];
        if (data.uploaded[ava + 'high'] != null) {
          return data.uploaded[ava + 'high'];
        }
      }
    };

    F2V.prototype.$documents = function(data) {
      return getLayers(data.uploaded, data.documents);
    };

    F2V.prototype.$photos = function(data) {
      return getLayers(data.uploaded, data.photos);
    };

    F2V.prototype.$avatars = function(data) {
      return data != null ? data.ava : void 0;
    };

    F2V.prototype.$email_first = function(data) {
      var ref;
      return data != null ? (ref = data.email) != null ? ref[0] : void 0 : void 0;
    };

    F2V.prototype.$interests0_description = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.interests) != null ? (ref1 = ref[0]) != null ? ref1.description : void 0 : void 0 : void 0;
    };

    F2V.prototype.$interests = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.interests) != null ? (ref1 = ref[0]) != null ? ref1.description : void 0 : void 0 : void 0;
    };

    F2V.prototype.$city = function(data) {
      var ref;
      return data != null ? (ref = data.location) != null ? ref.city : void 0 : void 0;
    };

    F2V.prototype.$country = function(data) {
      var ref;
      return data != null ? (ref = data.location) != null ? ref.country : void 0 : void 0;
    };

    F2V.prototype.$work = function(data) {
      var ref;
      return data != null ? (ref = data.work) != null ? ref[0] : void 0 : void 0;
    };

    F2V.prototype.$works = function(data) {
      return data != null ? data.work : void 0;
    };

    F2V.prototype.$workplace = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.work) != null ? (ref1 = ref[0]) != null ? ref1.place : void 0 : void 0 : void 0;
    };

    F2V.prototype.$ecity = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.education) != null ? (ref1 = ref[0]) != null ? ref1.city : void 0 : void 0 : void 0;
    };

    F2V.prototype.$ename = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.education) != null ? (ref1 = ref[0]) != null ? ref1.name : void 0 : void 0 : void 0;
    };

    F2V.prototype.$efaculty = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.education) != null ? (ref1 = ref[0]) != null ? ref1.faculty : void 0 : void 0 : void 0;
    };

    F2V.prototype.$echair = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.education) != null ? (ref1 = ref[0]) != null ? ref1.chair : void 0 : void 0 : void 0;
    };

    F2V.prototype.$equalification = function(data) {
      var ref, ref1;
      return data != null ? (ref = data.education) != null ? (ref1 = ref[0]) != null ? ref1.qualification : void 0 : void 0 : void 0;
    };

    F2V.prototype.$eperiod = function(data) {
      var e, ref, ref1, ref2;
      e = data != null ? (ref = data.education) != null ? ref[0] : void 0 : void 0;
      if ((e != null ? (ref1 = e.period) != null ? ref1.start : void 0 : void 0) && (e != null ? (ref2 = e.period) != null ? ref2.end : void 0 : void 0)) {
        return e.period.start + " - " + e.period.end + " гг.";
      }
    };

    F2V.prototype.$dativeName = function(data) {
      var name, ref, ref1, ref2;
      name = _nameLib.get((ref = data != null ? data.last_name : void 0) != null ? ref : '', (ref1 = data != null ? data.first_name : void 0) != null ? ref1 : '', (ref2 = data != null ? data.middle_name : void 0) != null ? ref2 : '');
      return {
        first: name.firstName('dative'),
        middle: name.middleName('dative'),
        last: name.lastName('dative')
      };
    };

    F2V.prototype.$edu = function(data) {
      var ref;
      return data != null ? (ref = data.education) != null ? ref[0] : void 0 : void 0;
    };

    F2V.prototype.$education = function(data) {
      return data != null ? data.education : void 0;
    };

    F2V.prototype.$address = function(data) {
      var address, building, city, country, house, location, street;
      location = data != null ? data.location : void 0;
      country = location != null ? location.country : void 0;
      city = location != null ? location.city : void 0;
      street = location != null ? location.street : void 0;
      house = location != null ? location.house : void 0;
      building = location != null ? location.building : void 0;
      address = '';
      address = comma(address, country);
      address = comma(address, city);
      address = comma(address, street);
      address = comma(address, house);
      address = comma(address, building);

      /*
      if street?
        if house?
          address += "#{house} "
          if building?
            address += "#{building} "
       */
      return address;
    };

    F2V.prototype.$addressNeed = function(data) {
      var address, building, house, location, ref, street;
      if (!(data != null ? (ref = data.location) != null ? ref.street : void 0 : void 0)) {
        return "";
      }
      location = data != null ? data.location : void 0;
      street = location != null ? location.street : void 0;
      house = location != null ? location.house : void 0;
      building = location != null ? location.building : void 0;
      address = '';
      address = comma(address, street);
      address = comma(address, house);
      address = comma(address, building);
      return address;
    };

    F2V.prototype.$addressPost = function(data) {
      return Q.async((function(_this) {
        return function*() {
          var an;
          an = (yield _this.$addressNeed(data));
          if (an) {
            return "редактировать";
          }
          return "Укажите подробный адрес";
        };
      })(this))();
    };

    F2V.prototype.$area = function(data) {
      var area, city, location, ret;
      location = data != null ? data.location : void 0;
      city = location != null ? location.city : void 0;
      area = location != null ? location.area : void 0;
      ret = '';
      if (city != null) {
        ret += "" + city;
        if (area != null) {
          ret += ",  " + area;
        }
      } else {
        if (area != null) {
          ret += "" + area;
        }
      }
      return ret;
    };

    return F2V;

  })();

}).call(this);
