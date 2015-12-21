(function() {
  var ex,
    slice = [].slice;

  ex = (function(_this) {
    return function(v) {
      if (typeof v !== 'string') {
        v = '';
      }
      if (v != null ? typeof v.match === "function" ? v.match('1') : void 0 : void 0) {
        return 1;
      }
      if (v != null ? typeof v.match === "function" ? v.match('3') : void 0 : void 0) {
        return 2;
      }
      if (v != null ? typeof v.match === "function" ? v.match('4') : void 0 : void 0) {
        return 3;
      }
      return 0;
    };
  })(this);

  this.filter = (function(_this) {
    return function(input, mf) {
      return Q.async(function() {
        var _out, acc, arr, c, course, course2, coursearr, dif, exists, exp, fn, found, i, j, k, key, l, len, len1, len2, len3, len4, m, min, n, nd, nw1, nw2, out, out2, out3, out4, p, place, r, ref, ref1, ref10, ref11, ref12, ref13, ref14, ref15, ref16, ref17, ref2, ref3, ref4, ref5, ref6, ref7, ref8, ref9, ret, ret2, s, status, subject, val, word;
        if (((ref = mf.price) != null ? ref.right : void 0) > 3000) {
          if ((ref1 = mf.price) != null) {
            ref1.right = 300000;
          }
        }
        if (((ref2 = mf.price) != null ? ref2.left : void 0) < 600) {
          if ((ref3 = mf.price) != null) {
            ref3.left = 0;
          }
        }
        out = [];
        out2 = [];
        out3 = [];
        out4 = [];
        _out = [];
        coursearr = [];
        ref4 = mf.course;
        for (i = 0, len = ref4.length; i < len; i++) {
          course = ref4[i];
          course = _diff.prepare(course);
          course2 = _diff.prepare(course.replace(/[^\w\@\-а-яА-ЯёЁ]/gmi, ''));
          arr = course.split(' ');
          coursearr = slice.call(coursearr).concat(slice.call(arr), [course2], [course2.substr(1)], [course2.substr(0, (course2 != null ? course2.length : void 0) - 2)]);
        }
        arr = {};
        if (coursearr == null) {
          coursearr = [];
        }
        for (j = 0, len1 = coursearr.length; j < len1; j++) {
          c = coursearr[j];
          if (!c) {
            continue;
          }
          arr[c] = true;
        }
        coursearr = Object.keys(arr);
        fn = function(p) {
          return p.sortf = function(byf) {
            var ref5, ref6;
            return ((((ref5 = p.points) != null ? ref5 : 0) * 100 + ((ref6 = p.sorts.subject) != null ? ref6 : 0)) * 1000) * 100 + byf;
          };
        };
        for (acc in input) {
          p = input[acc];
          if (!(p != null ? (ref5 = p.name) != null ? ref5.first : void 0 : void 0)) {
            continue;
          }
          if (!(p.left_price <= (mf != null ? (ref6 = mf.price) != null ? ref6.right : void 0 : void 0))) {
            continue;
          }
          if (!(p.right_price >= (mf != null ? (ref7 = mf.price) != null ? ref7.left : void 0 : void 0))) {
            continue;
          }
          p.points = 0;
          p.points2 = 0;
          p.pointsNeed = false;
          for (k = 0, len2 = coursearr.length; k < len2; k++) {
            c = coursearr[k];
            if (!c) {
              continue;
            }
            p.pointsNeed = true;
            for (word in p.awords) {
              if (c === word) {
                p.points += 10;
                continue;
              }
              if ((c != null ? c.length : void 0) < (word != null ? word.length : void 0)) {
                l = c;
                r = word;
              } else {
                l = word;
                r = c;
              }
              r = r.substr(0, l != null ? l.length : void 0);
              if (((r != null ? r.length : void 0) > 2) && (r === l) && (Math.abs((c != null ? c.length : void 0) - (word != null ? word.length : void 0)) < 4)) {
                p.points2 += 0.1;
              }
            }
          }
          if (!p.points) {
            p.points += p.points2;
          }
          if (p.pointsNeed && (p.points <= 0)) {
            continue;
          }
          min = -1;
          exists = false;
          ref8 = mf.subject;
          for (key in ref8) {
            subject = ref8[key];
            exists = true;
            found = -1;
            if (p.words == null) {
              p.words = [];
            }
            ref9 = p.words;
            for (m = 0, len3 = ref9.length; m < len3; m++) {
              s = ref9[m];
              nw1 = subject.replace(/язык$/g, '');
              nw2 = s.replace(/язык$/g, '');
              if (((nw1 != null ? nw1.length : void 0) < 10) || ((nw2 != null ? nw2.length : void 0) < 10)) {
                if (Math.abs((nw2 != null ? nw2.length : void 0) - (nw1 != null ? nw1.length : void 0)) > 2) {
                  continue;
                }
              }
              dif = _diff.match(nw1, nw2);
              if ((dif < 0) || (dif > 0.4)) {
                continue;
              }
              if ((found < 0) || (dif < found)) {
                found = dif;
              }
            }
            if (found < 0) {
              continue;
            }
            if (min < 0) {
              min = 0.1 + found;
            } else {
              min *= 0.1 + found;
            }
          }
          if (!exists) {
            min = 0;
          }
          if (min < 0) {
            continue;
          }
          p.subject_dist = min;
          p.sorts.subject = (0.5 - min) / 0.5;
          status = false;
          ref10 = mf.tutor_status;
          for (key in ref10) {
            val = ref10[key];
            if (val) {
              status = true;
            }
          }
          if (status) {
            if (!mf.tutor_status[p.status]) {
              continue;
            }
          }
          place = false;
          ref11 = mf.place;
          for (key in ref11) {
            val = ref11[key];
            if (val === true) {
              place = true;
            }
          }
          if (place) {
            if (!p.place.other) {
              ref12 = p.place;
              for (key in ref12) {
                val = ref12[key];
                if (mf.place[key]) {
                  place = false;
                  break;
                }
              }
              if (place) {
                continue;
              }
            }
          }
          exp = false;
          ref13 = mf.experience;
          for (key in ref13) {
            val = ref13[key];
            if (val) {
              exp = true;
            }
          }
          if (exp) {
            exp = 0;
            if (mf.experience['bigger_experience']) {
              exp = 3;
            }
            if (mf.experience['big_experience']) {
              exp = 2;
            }
            if (mf.experience['little_experience']) {
              exp = 1;
            }
            if (ex((ref14 = p.experience) != null ? ref14 : "") < exp) {
              continue;
            }
          }
          if (mf.gender) {
            if (mf.gender !== p.gender) {
              continue;
            }
          }
          fn(p);
          if (mf.with_photo) {
            if (p.nophoto) {
              continue;
            }
          }
          if (mf.with_verification) {
            if (p.nophoto || (((ref15 = p.about) != null ? ref15.length : void 0) < 200)) {
              continue;
            }
          }
          if (!p.nophoto) {
            if (((ref16 = p.about) != null ? ref16.length : void 0) > 50) {
              out.push(p);
            } else {
              out2.push(p);
            }
          } else {
            if (((ref17 = p.about) != null ? ref17.length : void 0) > 50) {
              out3.push(p);
            } else {
              out4.push(p);
            }
          }
        }
        nd = new Date().getTime();
        switch (mf.sort) {
          case 'rating':
            out.sort(function(a, b) {
              return -(a.sortf(a.rating / 5) - b.sortf(b.rating / 5));
            });
            out2.sort(function(a, b) {
              return -(a.sortf(a.rating / 5) - b.sortf(b.rating / 5));
            });
            out3.sort(function(a, b) {
              return -(a.sortf(a.rating / 5) - b.sortf(b.rating / 5));
            });
            out4.sort(function(a, b) {
              return -(a.sortf(a.rating / 5) - b.sortf(b.rating / 5));
            });
            break;
          case '-rating':
            out.sort(function(a, b) {
              return -(a.sortf(5 / a.rating) - b.sortf(5 / b.rating));
            });
            out2.sort(function(a, b) {
              return -(a.sortf(5 / a.rating) - b.sortf(5 / b.rating));
            });
            out3.sort(function(a, b) {
              return -(a.sortf(5 / a.rating) - b.sortf(5 / b.rating));
            });
            out4.sort(function(a, b) {
              return -(a.sortf(5 / a.rating) - b.sortf(5 / b.rating));
            });
            break;
          case 'price':
            out.sort(function(a, b) {
              return -(a.sortf(5000 / a.left_price) - b.sortf(5000 / b.left_price));
            });
            out2.sort(function(a, b) {
              return -(a.sortf(5000 / a.left_price) - b.sortf(5000 / b.left_price));
            });
            out3.sort(function(a, b) {
              return -(a.sortf(5000 / a.left_price) - b.sortf(5000 / b.left_price));
            });
            out4.sort(function(a, b) {
              return -(a.sortf(5000 / a.left_price) - b.sortf(5000 / b.left_price));
            });
            break;
          case '-price':
            out.sort(function(a, b) {
              return -(a.sortf(a.left_price / 5000) - b.sortf(b.left_price / 5000));
            });
            out2.sort(function(a, b) {
              return -(a.sortf(a.left_price / 5000) - b.sortf(b.left_price / 5000));
            });
            out3.sort(function(a, b) {
              return -(a.sortf(a.left_price / 5000) - b.sortf(b.left_price / 5000));
            });
            out4.sort(function(a, b) {
              return -(a.sortf(a.left_price / 5000) - b.sortf(b.left_price / 5000));
            });
            break;
          case 'experience':
            out.sort(function(a, b) {
              return -(a.sortf(ex(a.experience) / 10) - b.sortf(ex(b.experience) / 10));
            });
            out2.sort(function(a, b) {
              return -(a.sortf(ex(a.experience) / 10) - b.sortf(ex(b.experience) / 10));
            });
            out3.sort(function(a, b) {
              return -(a.sortf(ex(a.experience) / 10) - b.sortf(ex(b.experience) / 10));
            });
            out4.sort(function(a, b) {
              return -(a.sortf(ex(a.experience) / 10) - b.sortf(ex(b.experience) / 10));
            });
            break;
          case '-experience':
            out.sort(function(a, b) {
              return -(a.sortf(10 / ex(a.experience)) - b.sortf(10 / ex(b.experience)));
            });
            out2.sort(function(a, b) {
              return -(a.sortf(10 / ex(a.experience)) - b.sortf(10 / ex(b.experience)));
            });
            out3.sort(function(a, b) {
              return -(a.sortf(10 / ex(a.experience)) - b.sortf(10 / ex(b.experience)));
            });
            out4.sort(function(a, b) {
              return -(a.sortf(10 / ex(a.experience)) - b.sortf(10 / ex(b.experience)));
            });
            break;
          case 'register':
            out = slice.call(out).concat(slice.call(out2), slice.call(out3), slice.call(out4));
            out2 = out3 = out4 = [];
            out.sort(function(a, b) {
              return -(a.sortf(a.registerTime / nd) - b.sortf(b.registerTime / nd));
            });
            break;
          case '-register':
            out = slice.call(out).concat(slice.call(out2), slice.call(out3), slice.call(out4));
            out2 = out3 = out4 = [];
            out.sort(function(a, b) {
              return -(a.sortf(nd / a.registerTime) - b.sortf(nd / b.registerTime));
            });
            break;
          case 'access':
            out = slice.call(out).concat(slice.call(out2), slice.call(out3), slice.call(out4));
            out2 = out3 = out4 = [];
            out.sort(function(a, b) {
              return -(a.sortf(a.accessTime / nd) - b.sortf(b.accessTime / nd));
            });
            break;
          case '-access':
            out = slice.call(out).concat(slice.call(out2), slice.call(out3), slice.call(out4));
            out2 = out3 = out4 = [];
            out.sort(function(a, b) {
              return -(a.sortf(nd / a.accessTime) - b.sortf(nd / b.accessTime));
            });
        }
        ret = slice.call(out).concat(slice.call(out2), slice.call(out3), slice.call(out4));
        ret2 = [];
        for (n = 0, len4 = ret.length; n < len4; n++) {
          p = ret[n];
          ret2.push(p.index);
        }
        return ret2;
      })();
    };
  })(this);

}).call(this);
