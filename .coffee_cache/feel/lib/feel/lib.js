(function() {
  var Lib, Wraper, _getCallerFile, _js_infinite_json, _oldQAsync, _oldQSpawn, doted, last, log, parseFKF, regenerator, relog, set, strlen,
    slice = [].slice,
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  require('colors');

  global._colors = require('colors/safe');


  /*
  __used = 0
  setInterval ->
    n = process.memoryUsage().heapUsed
    console.log "+"+(n-__used)/1024
    __used = n
  , 5000
   */

  String.prototype.capitalizeFirstLetter = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  };

  global._production = false;

  if (require('os').hostname() === 'pi0h.org') {
    global._production = true;
  }

  last = "";

  log = {
    s1: "",
    s2: "",
    s3: ""
  };

  doted = false;

  set = function() {
    var args, n, sbstr;
    n = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (args == null) {
      args = [""];
    }
    sbstr = "";
    if (typeof args[0] === 'string') {
      sbstr = args[0].substr(0, 13);
    }
    last = n;
    if (doted) {
      doted = false;
      process.stdout.write("\n");
    }
    return log['s' + n] = sbstr;
  };

  relog = function() {
    var args, n, sbstr;
    n = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (args == null) {
      args = [""];
    }
    sbstr = args[0].substr(0, 13);
    if ((last !== n) || (log['s' + n] !== sbstr) || (log['s' + n] === "")) {
      set.apply(null, [n].concat(slice.call(args)));
      return true;
    }
    doted = true;
    process.stdout.write('.');
    return false;
  };

  global.Log = function() {
    set.apply(null, [1].concat(slice.call(arguments)));
    return console.log.apply(console, arguments);
  };

  global.Log2 = function() {
    set.apply(null, [2].concat(slice.call(arguments)));
    return console.log.apply(console, arguments);
  };

  global.Log3 = function() {
    if (!relog.apply(null, [3].concat(slice.call(arguments)))) {
      return;
    }
    return console.log.apply(console, arguments);
  };

  global.Warn = function() {
    return console.log.apply(console, arguments);
  };

  global.Err = function() {
    return console.error.apply(console, arguments);
  };

  global.VC = function() {
    var classes;
    classes = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return classes.reduceRight(function(Parent, Child) {
      var Child_Projection, key, ref;
      Child_Projection = (function(superClass) {
        extend(Child_Projection, superClass);

        function Child_Projection() {
          var child_super;
          child_super = Child.__super__;
          Child.__super__ = Child_Projection.__super__;
          Child.apply(this, arguments);
          Child.__super__ = child_super;
          if (child_super == null) {
            Child_Projection.__super__.constructor.apply(this, arguments);
          }
        }

        return Child_Projection;

      })(Parent);
      ref = Child.prototype;
      for (key in ref) {
        if (!hasProp.call(ref, key)) continue;
        if (Child.prototype[key] !== Child) {
          Child_Projection.prototype[key] = Child.prototype[key];
        }
      }
      for (key in Child) {
        if (!hasProp.call(Child, key)) continue;
        if (Child[key] !== Object.getPrototypeOf(Child.prototype)) {
          Child_Projection[key] = Child[key];
        }
      }
      return Child_Projection;
    });
  };

  _getCallerFile = function() {
    var callerfile, currentfile, err, error, f, l, len1, ref;
    try {
      err = new Error();
      callerfile = null;
      currentfile = null;
      Error.prepareStackTrace = function(err, stack) {
        return stack;
      };
      currentfile = err.stack.shift().getFileName();
      ref = err.stack;
      for (l = 0, len1 = ref.length; l < len1; l++) {
        f = ref[l];
        console.log(f.getFileName());
      }
      while (err.stack.length) {
        callerfile = err.stack.shift().getFileName();
        if (currentfile !== callerfile) {
          return callerfile;
        }
      }
    } catch (error) {
      err = error;
      return void 0;
    }
  };

  strlen = function(str, len, real) {
    var n;
    if (real == null) {
      real = str.length;
    }
    n = len - real;
    while (n > 0) {
      str += " ";
      n--;
    }
    return str;
  };

  global.Wrap = function(obj, prot) {
    var __FNAME__, __functionName__, _lockArr, _lockId, _single, ee, errorFunction, key, logFunction, proto, single, unsingle, val;
    proto = prot;
    if (proto == null) {
      proto = obj != null ? obj.__proto__ : void 0;
    }
    if (proto == null) {
      return obj;
    }
    if (obj.__wraped) {
      return obj;
    }
    __functionName__ = "";
    __FNAME__ = "";
    _single = {};
    logFunction = function() {
      var args, i, l, len1, s, val;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      s = ("" + Main.name).blue + ":".grey;
      if (Main.processId != null) {
        s += ("" + Main.processId).gray + ":".grey;
      }
      s += ("" + proto.constructor.name).cyan;
      s += ("" + __functionName__).cyan;
      for (i = l = 0, len1 = args.length; l < len1; i = ++l) {
        val = args[i];
        if (_util.isError(val)) {
          args[i] = Exception(val);
        }
        if (typeof args[i] === 'string') {
          args[i] = ("" + args[i]).green;
        }
      }
      return console.log.apply(console, [s].concat(slice.call(args)));
    };
    errorFunction = function() {
      var args, i, l, len1, s, val;
      args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
      s = "\n********************************************************\n".red;
      s += "ERROR".red + (":" + Main.name + ":").yellow;
      if (Main.processId != null) {
        s += (Main.processId + ":").yellow;
      }
      s += ("" + proto.constructor.name).yellow;
      s += ("" + __functionName__).yellow;
      for (i = l = 0, len1 = args.length; l < len1; i = ++l) {
        val = args[i];
        if (_util.isError(val)) {
          args[i] = Exception(val);
        }
        if (typeof args[i] === 'string') {
          args[i] = ("" + args[i]).magenta;
        }
      }
      return console.log.apply(console, [s].concat(slice.call(args), ["\n********************************************************".red]));
    };
    single = function(name) {
      if (name == null) {
        name = __FNAME__;
      }
      return Q.then(function() {
        return obj._lock('__s_' + name, true).then(function(id) {
          return _single[name] = id;
        });
      });
    };
    unsingle = function(f) {
      return Q.then(function() {
        if (!_single[f]) {
          return;
        }
        return obj._unlock('__s_' + f, _single[f]).then(function() {
          return _single[f] = false;
        });
      });
    };
    obj.__wraped = true;
    for (key in proto) {
      val = proto[key];
      if (typeof val === 'function') {
        (function(key, val) {
          var FNAME, fname, foo, gen, ref;
          fname = "::".grey + key.cyan + "()".blue;
          FNAME = key;
          gen = null;
          if ((val != null ? (ref = val.constructor) != null ? ref.name : void 0 : void 0) === 'GeneratorFunction') {
            gen = Q.async(val);
          }
          foo = function() {
            var __inited, args, nerror, q;
            args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
            nerror = new Error();
            __FNAME__ = FNAME;
            __functionName__ = fname;
            if (gen != null) {
              q = gen.apply(obj, args);
            } else {
              q = Q.then(function() {
                return val.apply(obj, args);
              });
            }
            if (key === 'init') {
              __inited = false;
              obj.once('inited', function() {
                return __inited = true;
              });
              q = q.then(function(arg) {
                if (!__inited) {
                  obj.emit('inited');
                }
                return arg;
              });
            }
            q = q.then(function(a) {
              return unsingle(FNAME).then(function() {
                return a;
              });
            });
            q = q["catch"](function(e) {
              var a, err, error, errs, i, l, len1, len2, m, na, ne, nerrs, oe;
              errs = Exception(nerror).match(/(at.*\n)/g);
              nerrs = "";
              for (l = 0, len1 = errs.length; l < len1; l++) {
                err = errs[l];
                if (err.match(/lib\.coffee/)) {
                  continue;
                }
                if (err.match(/node_modules/)) {
                  break;
                }
                if (err.match(/q\.js/)) {
                  break;
                }
                if (err.match(/\(native\)/)) {
                  break;
                }
                nerrs += "\n\t" + err.replace(/\n/g, "");
              }
              if (!_util.isError(e)) {
                oe = e;
                if (typeof e !== 'string') {
                  e = _inspect(e);
                }
                ne = new Error();
                ne.message = e;
                if (typeof oe === 'object' && oe !== null) {
                  ne._obj = oe;
                  for (key in oe) {
                    val = oe[key];
                    ne[key] = val;
                  }
                }
                e = ne;
              }
              if (e.message == null) {
                e.message = "";
              }
              e.message += ("\n" + proto.constructor.name + "::" + key + "(").red;
              na = [];
              for (i = m = 0, len2 = args.length; m < len2; i = ++m) {
                a = args[i];
                if (typeof a === 'object' && (a !== null)) {
                  try {
                    a = '{' + Object.keys(a).join(',') + '}';
                  } catch (error) {
                    e = error;
                    a = '...';
                  }
                } else if (typeof a === 'string') {
                  a = a;
                } else {
                  a = '...';
                }
                na.push(a);
              }
              e.message += na.join(',').red;
              e.message += ");".red + nerrs.grey;
              if (e.stack == null) {
                e.stack = "";
              }
              e.stack = e.stack.replace(e.message, "");
              throw e;
            });
            return q;
          };
          if (prot == null) {
            return obj[key] = foo;
          }
        })(key, val);
      }
    }
    if (obj.log == null) {
      obj.log = function() {
        var args;
        args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
        return logFunction.apply(obj, args);
      };
    }
    if (obj.error == null) {
      obj.error = function() {
        var args;
        args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
        return errorFunction.apply(obj, args);
      };
    }
    if (obj._single == null) {
      obj._single = single;
    }
    obj._block = function(state, pref, err) {
      var name1;
      if (state == null) {
        state = true;
      }
      if (pref == null) {
        pref = "";
      }
      if ((typeof pref !== 'string') && (err == null)) {
        err = pref;
        pref = "";
      }
      if (err != null) {
        obj["__blockErr" + pref] = err;
      }
      if (obj[name1 = "__isBlocked" + pref] == null) {
        obj[name1] = false;
      }
      if (obj["__isBlocked" + pref] === state) {
        return Q();
      }
      obj["__isBlocked" + pref] = state;
      if (state) {
        obj.emit('_block' + pref);
      } else {
        obj.emit('_unblock' + pref);
      }
      return Q();
    };
    obj._unblock = function(pref) {
      var q;
      if (pref == null) {
        pref = "";
      }
      q = Q();
      if (obj["__isBlocked" + pref]) {
        q = q.then(function() {
          return _waitFor(obj, '_unblock' + pref);
        });
      }
      q = q.then(function() {
        if (obj["__blockErr" + pref] != null) {
          throw obj["__blockErr" + pref];
        }
      });
      return q;
    };
    obj._lock = function(sel) {
      return Q.then(function() {
        var __locking, _id, q;
        _id = __lockId++;
        q = Q();
        if (__locking) {
          q = q.then(function() {
            return _waitFor(__eeLock, '' + (_id - 1));
          });
        } else {
          __locking = true;
        }
        return q.then(function() {
          __locking = true;
          return _lockFoo(sel).then(function() {
            __locking = false;
            return __eeLock.emit(_id);
          });
        });
      });
    };
    _lockArr = {};
    _lockId = 1;
    obj._lock = function(_sel, idin, _id) {
      var id, idsel, lockid, sel;
      if (idin == null) {
        idin = false;
      }
      id = _id;
      if (_id == null) {
        id = _lockId++;
      }
      sel = '__lock_' + _sel;
      lockid = _lockArr[sel];
      if (!lockid) {
        _lockArr[sel] = id;
      }
      if (idin) {
        idsel = sel + lockid;
      } else {
        idsel = sel;
      }
      if (lockid) {
        return obj._unblock(idsel).tick(function() {
          return obj._lock(_sel, idin, id);
        }).then(function(id) {
          return id;
        });
      }
      if (idin) {
        idsel = sel + id;
      } else {
        idsel = sel;
      }
      obj._block(true, idsel);
      return Q(id);
    };
    obj._unlock = function(sel, id) {
      if (id == null) {
        id = "";
      }
      if (_lockArr['__lock_' + sel] !== id) {
        throw new Error('bad id');
      }
      _lockArr['__lock_' + sel] = false;
      obj._block(false, '__lock_' + sel + id);
      return Q();
    };
    if (obj.emit == null) {
      ee = new EE;
      obj.emit = function() {
        return ee.emit.apply(ee, arguments);
      };
      obj.on = function(action, foo) {
        var ref;
        if ((foo != null ? (ref = foo.constructor) != null ? ref.name : void 0 : void 0) === 'GeneratorFunction') {
          foo = Q.async(foo);
        }
        return ee.on(action, function() {
          var args, ret;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          ret = foo.apply(null, args);
          if (Q.isPromise(ret)) {
            return ret.done();
          }
        });
      };
      obj.once = function(action, foo) {
        var ref;
        if ((foo != null ? (ref = foo.constructor) != null ? ref.name : void 0 : void 0) === 'GeneratorFunction') {
          foo = Q.async(foo);
        }
        return ee.once(action, function() {
          var args, ret;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          ret = foo.apply(null, args);
          if (Q.isPromise(ret)) {
            return ret.done();
          }
        });
      };
    }
    return obj;
  };

  global.$W = function(obj) {
    var ee, fname, func, newfunc, proto, ref, ref1;
    proto = obj != null ? obj.__proto__ : void 0;
    if (proto == null) {
      proto = obj;
    }
    if ((typeof obj === 'function') && ((obj != null ? (ref = obj.constructor) != null ? ref.name : void 0 : void 0) === 'GeneratorFunction')) {
      return Q.async(obj);
    }
    if (obj.__wraped) {
      return obj;
    }
    obj.__wraped = true;
    for (fname in proto) {
      func = proto[fname];
      if (typeof func !== 'function') {
        continue;
      }
      newfunc = func;
      if ((func != null ? (ref1 = func.constructor) != null ? ref1.name : void 0 : void 0) === 'GeneratorFunction') {
        newfunc = Q.async(func);
      }
      obj[fname] = newfunc;
    }
    if (obj.emit == null) {
      ee = new EE;
      obj.emit = function() {
        return ee.emit.apply(ee, arguments);
      };
      obj.on = function(action, foo) {
        var ref2;
        if ((foo != null ? (ref2 = foo.constructor) != null ? ref2.name : void 0 : void 0) === 'GeneratorFunction') {
          foo = Q.async(foo);
        }
        return ee.on(action, function() {
          var args;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return Q.spawn(function*() {
            return (yield foo.apply(null, args));
          });
        });
      };
      obj.once = function(action, foo) {
        var ref2;
        if ((foo != null ? (ref2 = foo.constructor) != null ? ref2.name : void 0 : void 0) === 'GeneratorFunction') {
          foo = Q.async(foo);
        }
        return ee.once(action, function() {
          var args;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          return Q.spawn(function*() {
            return (yield foo.apply(null, args));
          });
        });
      };
    }
    return obj;
  };

  global.lrequire = function(name) {
    return require('./lib/' + name);
  };

  global.Path = new (require('./service/path'))();

  global.Q = require('q');

  _oldQAsync = Q.async;

  global.Q.async = (function(_this) {
    return function(f) {
      var ref;
      if ((f != null ? (ref = f.constructor) != null ? ref.name : void 0 : void 0) === 'GeneratorFunction') {
        return _oldQAsync.call(Q, f);
      }
      return f;
    };
  })(this);

  _oldQSpawn = Q.spawn;

  global.Q.spawn = (function(_this) {
    return function(f) {
      var ref, ref1;
      if ((f != null ? (ref = f.constructor) != null ? ref.name : void 0 : void 0) === 'GeneratorFunction') {
        return _oldQSpawn.call(Q, f);
      }
      return typeof f === "function" ? (ref1 = f()) != null ? typeof ref1.done === "function" ? ref1.done() : void 0 : void 0 : void 0;
    };
  })(this);

  global._lookDown = function(obj, first, foo) {
    return Q.async(function*() {
      var key, qs, ref, val;
      if (foo == null) {
        ref = [first, void 0], foo = ref[0], first = ref[1];
      }
      if (!(obj && ((typeof obj === 'function') || (typeof obj === 'object')))) {
        return;
      }
      qs = [];
      if (first) {
        qs.push(foo(obj, first, obj[first]));
      } else {
        for (key in obj) {
          val = obj[key];
          qs.push(foo(obj, key, val));
        }
      }
      (yield Q.all(qs));
      if (first) {
        if ((typeof obj[first] === 'function') || (typeof obj[first] === 'object')) {
          (yield _lookDown(obj[first], foo));
        }
      } else {
        for (key in obj) {
          val = obj[key];
          if ((typeof val === 'function') || (typeof val === 'object')) {
            (yield _lookDown(val, foo));
          }
        }
      }
    })();
  };

  global._lookUp = function(obj, first, foo) {
    return Q.async(function*() {
      var key, qs, ref, val;
      if (foo == null) {
        ref = [first, void 0], foo = ref[0], first = ref[1];
      }
      if (!(obj && ((typeof obj === 'function') || (typeof obj === 'object')))) {
        return;
      }
      if (first) {
        if ((typeof obj[first] === 'function') || (typeof obj[first] === 'object')) {
          (yield _lookUp(obj[first], foo));
        }
      } else {
        for (key in obj) {
          val = obj[key];
          if ((typeof val === 'function') || (typeof val === 'object')) {
            (yield _lookUp(val, foo));
          }
        }
      }
      qs = [];
      if (first) {
        qs.push(foo(obj, first, obj[first]));
      } else {
        for (key in obj) {
          val = obj[key];
          qs.push(foo(obj, key, val));
        }
      }
      (yield Q.all(qs));
    })();
  };

  Q.rdenodeify = function(f) {
    return Q.denodeify(function() {
      var as, cb, l;
      as = 2 <= arguments.length ? slice.call(arguments, 0, l = arguments.length - 1) : (l = 0, []), cb = arguments[l++];
      return typeof f === "function" ? f.apply(null, slice.call(as).concat([function(a, b) {
        return typeof cb === "function" ? cb(b, a) : void 0;
      }])) : void 0;
    });
  };

  Q.denode = function() {
    return Q.denodeify.apply(Q, arguments);
  };

  Q.rdenode = function() {
    return Q.rdenodeify.apply(Q, arguments);
  };

  global._invoke = function() {
    var args;
    args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return Q.ninvoke.apply(Q, args);
  };

  Q.then = function() {
    var ref;
    return (ref = Q()).then.apply(ref, arguments);
  };


  /*
    args = arguments
    d = Q.defer()
    process.nextTick ->
      q = Q()
      q.then.apply q,args
      d.resolve q
    d.promise
   */


  /*
  Q.Promise::tick = (fulfilled,rejected,ms)->
    self = this
    deferred = Q.defer()
    
    _fulfilled = null
    if typeof fulfilled == 'function'
      _fulfilled = Promise_tick_fulfilled = (value)->
        process.nextTick =>
          try
            deferred.resolve  fulfilled.call null,value
          catch e
            deferred.rejected e
    else
      _fulfilled = deferred.resolve
    _rejected = null
    if typeof rejected == 'function'
      _rejected = Promise_tick_rejected = (e)->
        try
          deferred.resolve rejected.call null,e
        catch ne
          deferred.reject ne
    else
      _rejected = deferred.reject
    @done _fulfilled,_rejected
    if ms?
      ue = Promise_tick_updateEstimate ->
        deferred.setEstimate self.getEstimate()+ms
      @observeEstimate ue
      ue()
    return deferred.promise
   */

  Q.Promise.prototype.wait = function() {
    var args, q, t;
    t = arguments[0], args = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    if (typeof t !== 'number') {
      args = slice.call(arguments);
      t = 0;
    }
    q = Q.Promise.prototype.delay.call(this, t);
    if (args.length) {
      q = q.then.apply(q, args);
    }
    return q;
  };


  /*
  (wait,fulfilled,rejected,ms)->
    args = [arguments...]
    if typeof wait == 'function'
      return @tick args.slice(1)...
    self = this
    deferred = Q.defer()
    setTimeout ->
      _fulfilled = null
      if typeof fulfilled == 'function'
        _fulfilled = Promise_tick_fulfilled = (value)->
          try
            deferred.resolve  fulfilled.call null,value
          catch e
            deferred.rejected e
      else
        _fulfilled = deferred.resolve
      _rejected = null
      if typeof rejected == 'function'
        _rejected = Promise_tick_rejected = (e)->
          try
            deferred.resolve rejected.call null,e
          catch ne
            deferred.reject ne
      else
        _rejected = deferred.reject
      @done _fulfilled,_rejected
      if ms?
        ue = Promise_tick_updateEstimate ->
          deferred.setEstimate self.getEstimate()+ms
        @observeEstimate ue
        ue()
    ,wait
    return deferred.promise
   */

  Q.wait = function() {
    var ref;
    return (ref = Q()).wait.apply(ref, arguments);
  };

  Q.tick = function() {
    var ref;
    return (ref = Q()).wait.apply(ref, arguments);
  };

  Q.Promise.prototype.tick = Q.Promise.prototype.wait;

  global.EE = require('events').EventEmitter;

  EE.defaultMaxListeners = 100;

  Wraper = (function(superClass) {
    extend(Wraper, superClass);

    function Wraper() {
      Wrap(this);
    }

    return Wraper;

  })(EE);

  global.Wraper = Wraper;

  global.Exception = (function(_this) {
    return function(e) {
      var str;
      str = "";
      if (e.name != null) {
        str += (e.name + "\n").blue;
      }
      if (e.message != null) {
        str += (e.message + "\n").cyan;
      }
      if (e.stack != null) {
        str += ("" + e.stack).grey;
      }
      return str;
    };
  })(this);

  global.ExceptionJson = (function(_this) {
    return function(e) {
      return {
        name: e.name,
        message: e.message,
        stack: e.stack,
        _obj: e._obj
      };
    };
  })(this);

  global.ExceptionUnJson = (function(_this) {
    return function(j) {
      var e, key, ref, val;
      e = new Error();
      e.stack = j.stack;
      e.message = j.message;
      e.name = j.name;
      e._obj = j._obj;
      if ((e._obj != null) && (typeof e._obj === 'object') && e._obj !== null) {
        ref = e._obj;
        for (key in ref) {
          val = ref[key];
          e[key] = val;
        }
      }
      return e;
    };
  })(this);

  Lib = (function() {
    function Lib() {
      Wrap(this);
    }

    Lib.prototype.init = function() {};

    return Lib;

  })();

  _js_infinite_json = require('js-infinite-json');

  global._fse = require('fs-extra');

  global._deflate = Q.denode(require('zlib').deflate);

  global._gzip = Q.denode(require('zlib').gzip);

  global._qlimit = require('./lib/qlimit');

  global._crypto = require('crypto');

  global._ = require('lodash');

  global._util = require('util');

  global._fs = require('fs');

  global._readdir = Q.denode(_fs.readdir);

  global._readFile = Q.denode(_fs.readFile);

  global._writeFile = Q.denode(_fs.writeFile);

  global._exists = Q.rdenode(_fs.exists);

  global._path = require('path');

  global._stat = Q.denode(_fs.stat);

  global._unlink = Q.denode(_fs.unlink);

  global._inspect = _util.inspect;

  global._hash = function(f) {
    return _crypto.createHash('sha1').update(f).digest('hex');
  };

  global._object_hash = require('./lib/object_hash');

  global._toJson = function(o) {
    return _js_infinite_json.stringify(o);
  };

  global._unJson = function(o) {
    return _js_infinite_json.parse(o);
  };

  global._mkdirp = Q.denode(require('mkdirp'));

  global._rename = Q.denode(_fs.rename);

  global._requestPost = Q.denode(require('request').post);

  global._request = Q.denode(require('request'));

  global._fs_copy = Q.denode(_fse.copy);

  global._fs_remove = Q.denode(_fse.remove);

  global._readdirp = Q.denode(require('readdirp'));

  global.md5file = Q.denode(require('md5-file'));

  regenerator = require("regenerator");

  global._LZString = require('./lib/lz-string.min.js');

  global._regenerator = function(source) {
    return regenerator.compile(source).code;
  };

  global._args = function(a) {
    var ar, i, l, len1;
    for (i = l = 0, len1 = a.length; l < len1; i = ++l) {
      ar = a[i];
      if (ar === null) {
        a[i] = void 0;
      }
    }
    return a;
  };

  global._randomHash = function(b) {
    if (b == null) {
      b = 20;
    }
    return _crypto.randomBytes(b).toString('hex');
  };

  global._shash = function(f) {
    return _hash(f).substr(0, 10);
  };

  global._invoke = function() {
    var args;
    args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    return Q.ninvoke.apply(Q, args);
  };

  global._mkdirp = Q.denode(require('mkdirp'));

  module.exports = Lib;

  global._waitFor = function(obj, action, time) {
    if (time == null) {
      time = 60000;
    }
    return Q.then(function() {
      var defer, waited;
      waited = false;
      defer = Q.defer();
      obj.once(action, (function(_this) {
        return function() {
          var args;
          args = 1 <= arguments.length ? slice.call(arguments, 0) : [];
          if (args.length === 1) {
            args = args[0];
          }
          waited = true;
          return defer.resolve(args);
        };
      })(this));
      if (time > 0) {
        setTimeout((function(_this) {
          return function() {
            if (waited) {
              return;
            }
            defer.reject("timout waiting action " + action);
          };
        })(this), time);
      }
      return defer.promise;
    });
  };

  global._Inited = function(obj) {
    return Q.then(function() {
      obj.__initing = 0;
      if (obj.__initing > 1) {
        return true;
      }
      if (obj.__initing === 1) {
        return _waitFor(obj, 'inited').then(function() {
          return true;
        });
      }
      obj.__initing = 1;
      return false;
    });
  };

  global._setKey = (function(_this) {
    return function(obj, key, val, force) {
      var kk, name1;
      if (force == null) {
        force = false;
      }
      if (typeof key === 'string') {
        key = key != null ? key.split('.') : void 0;
      }
      if (!(key != null ? key.length : void 0)) {
        return obj;
      }
      if ((val != null) || force) {
        if (obj != null) {
          if (obj[name1 = key != null ? key[0] : void 0] == null) {
            obj[name1] = {};
          }
        }
        if ((key != null ? key.length : void 0) <= 1) {
          if (obj != null) {
            obj[key != null ? key[0] : void 0] = val;
          }
        }
      }
      kk = key != null ? typeof key.shift === "function" ? key.shift() : void 0 : void 0;
      if (kk !== "") {
        obj = obj != null ? obj[kk] : void 0;
      }
      if ((!(key != null ? key.length : void 0)) || (!obj) || (!typeof obj === 'object')) {
        return obj;
      }
      return global._setKey(obj, key, val, force);
    };
  })(this);

  parseFKF = (function(_this) {
    return function(obj) {
      var ref, ref1, ret;
      ret = {};
      if (!obj) {
        return ret;
      }
      if (typeof obj === 'string') {
        ret.form = obj;
        return ret;
      }
      if (typeof obj === 'object') {
        ret.form = (ref = Object.keys(obj)) != null ? ref[0] : void 0;
        obj = obj[ret.form];
        if (!obj) {
          return ret;
        }
        if (typeof obj === 'string') {
          ret.key = obj;
          return ret;
        }
        if (typeof obj === 'object') {
          ret.key = (ref1 = Object.keys(obj)) != null ? ref1[0] : void 0;
          obj = obj[ret.key];
          if (typeof obj === 'function') {
            ret.foo = obj;
          }
          return ret;
        }
      }
      return ret;
    };
  })(this);

  global._objRelativeKey = (function(_this) {
    return function(obj, key, foo, part) {
      var k, npart, results, v;
      if (part == null) {
        part = "";
      }
      if (!(obj && (typeof obj === 'object'))) {
        return;
      }
      results = [];
      for (k in obj) {
        v = obj[k];
        if (k === key) {
          foo(obj, part, parseFKF(v));
          continue;
        }
        if (v && typeof v === 'object') {
          npart = part;
          if (npart) {
            npart += '.';
          }
          npart += k;
          results.push(_objRelativeKey(v, key, foo, npart));
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
  })(this);

  global._declOfNum = function(number, titles) {
    var cases;
    cases = [2, 0, 1, 1, 1, 2];
    return titles[number % 100 > 4 && number % 100 < 20 ? 2 : cases[number % 10 < 5 ? number % 10 : 5]];
  };

  global._diff = require('./diff/main');

  global._nameLib = require('./lib/name');

}).call(this);
