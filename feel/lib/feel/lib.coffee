

require 'harmony-reflect'
require 'colors'
global._colors = require 'colors/safe'
###
__used = 0
setInterval ->
  n = process.memoryUsage().heapUsed
  console.log "+"+(n-__used)/1024
  __used = n
, 5000
###
String::capitalizeFirstLetter = -> @charAt(0).toUpperCase() + @slice(1)

switch require('os').hostname()
  when 'pi0h.org','lessonhome.org','lessonhome.ru'
    global._production = true
  else
    global._production = false

fs = require 'fs'

logStream = fs.createWriteStream './out',flags:'a'
errStream = fs.createWriteStream './err',flags:'a'

swrite = process.stdout.write
process.stdout.write = ->
  swrite.apply process.stdout, arguments
  logStream.write arguments...
swriteerr = process.stderr.write
process.stderr.write = ->
  swriteerr.apply process.stderr, arguments
  errStream.write arguments...
   

last = ""
log =
  s1 : ""
  s2 : ""
  s3 : ""
doted = false
set = (n,args...)->
  args ?= [""]
  sbstr = ""
  sbstr = args[0].substr 0,13 if typeof args[0] == 'string'
  last = n
  if doted
    doted = false
    process.stdout.write "\n"
  log['s'+n] = sbstr
  
relog = (n,args...)->
  args ?= [""]
  sbstr = args[0].substr 0,13
  if (last != n) || (log['s'+n]!=sbstr)||(log['s'+n]=="")
    set n,args...
    return true
  doted = true
  process.stdout.write '.'
  return false
    
global.Log  = ->
  set 1,arguments...
  console.log arguments...
global.Log2  = ->
  #return unless relog 3,arguments...
  set 2,arguments...
  console.log arguments...
global.Log3  = ->
  return unless relog 3,arguments...
  console.log arguments...
global.Warn = ->
  console.log arguments...
global.Err = ->
  console.error arguments...

global.VC = (classes...)->
  classes.reduceRight (Parent, Child)->
    class Child_Projection extends Parent
      constructor: ->
        # Temporary replace Child.__super__ and call original `constructor`
        child_super = Child.__super__
        Child.__super__ = Child_Projection.__super__
        Child.apply @, arguments
        Child.__super__ = child_super

        # If Child.__super__ not exists, manually call parent `constructor`
        unless child_super?
          super

    # Mixin prototype properties, except `constructor`
    for own key  of Child::
      if Child::[key] isnt Child
        Child_Projection::[key] = Child::[key]

    # Mixin static properties, except `__super__`
    for own key  of Child
      if Child[key] isnt Object.getPrototypeOf(Child::)
        Child_Projection[key] = Child[key]

    Child_Projection

_getCallerFile = ->
  try
    err = new Error()
    callerfile = null
    currentfile = null
    Error.prepareStackTrace = (err, stack)->stack
    currentfile = err.stack.shift().getFileName()
    for f in err.stack
      console.log f.getFileName()
    while err.stack.length
      callerfile = err.stack.shift().getFileName()
      if(currentfile != callerfile)
        return callerfile
  catch err
    undefined

strlen = (str,len,real)->
  real ?= str.length
  n = len-real
  while n>0
    str+=" "
    n--
  return str

global.Wrap = (obj,prot)->
  proto = prot
  proto ?= obj?.__proto__
  return obj unless proto?
  return obj if obj.__wraped
  __functionName__ = ""
  __FNAME__ = ""
  _single = {}
  logFunction = (args...)->
    s = "#{Main.name}".blue+":".grey
    s+= "#{Main.processId}".gray+":".grey if Main.processId?
    s+= "#{proto.constructor.name}".cyan
    s+= "#{__functionName__}".cyan
    for val,i in args
      if _util.isError val
        args[i] = Exception val
      if typeof (args[i]) == 'string'
        args[i] = (""+args[i]).green
    console.log s,args...
  errorFunction = (args...)->
    s= "\n********************************************************\n".red
    s+= "ERROR".red+":#{Main.name}:".yellow
    s+= "#{Main.processId}:".yellow if Main.processId?
    s+= "#{proto.constructor.name}".yellow
    s+= "#{__functionName__}".yellow
    for val,i in args
      if _util.isError val
        args[i] = Exception val
      if typeof (args[i]) == 'string'
        args[i] = (""+args[i]).magenta
    console.log s,args...,"\n********************************************************".red
  single = (name=__FNAME__)-> Q.then ->
    obj._lock('__s_'+name,true).then (id)->
      #return single(__FNAME__) if _single[__FNAME__]
      _single[name] = id
  unsingle = (f)-> Q.then ->
    return unless _single[f]
    obj._unlock('__s_'+f,_single[f]).then ->
      _single[f] = false

  obj.__wraped = true
  #proto.__wraped ?= {}
  for key,val of proto
    if (typeof val=='function') #&& !proto.__wraped[key]
      #proto.__wraped[key] = true
      do (key,val)->
        fname = "::".grey+key.cyan+"()".blue
        FNAME = key
        gen = null
        if val?.constructor?.name == 'GeneratorFunction'
          gen = Q.async val
        foo = (args...)->
          nerror = new Error()
          __FNAME__ = FNAME
          __functionName__ = fname
          if gen?
            q = gen.apply obj,args
          else
            q = Q.then -> val.apply obj,args
          if key == 'init'
            __inited = false
            obj.once 'inited',-> __inited = true
            q = q.then (arg)->
              obj.emit 'inited' unless __inited
              return arg
          q = q.then (a)-> unsingle(FNAME).then -> a
          q = q.catch (e)->
            errs = Exception(nerror).match /(at.*\n)/g
            nerrs = ""
            for err in errs
              continue if err.match /lib\.coffee/
              break if err.match /node_modules/
              break if err.match /q\.js/
              break if err.match /\(native\)/
              nerrs += "\n\t"+err.replace(/\n/g,"")
            unless _util.isError e
              oe = e
              e = _inspect e unless typeof e == 'string'
              ne = new Error()
              ne.message = e
              if typeof oe == 'object' && oe != null
                ne._obj = oe
                for key,val of oe
                  ne[key] = val

              e = ne
            e.message ?= ""
            e.message += "\n#{proto.constructor.name}::#{key}(".red
            na = []
            for a,i in args
              if typeof a == 'object' && (a != null)
                try a = '{'+Object.keys(a).join(',')+'}'
                catch e
                  a = '...'
              else if typeof a == 'string'
                a = a
              else a = '...'
              na.push a
            e.message += na.join(',').red
            e.message += ");".red+nerrs.grey
            #if key != 'destructor'
            #  if typeof obj.destructor == 'function'
            #    return obj.destructor(e)
            #obj?.emit? 'destruct',e
            e.stack ?= ""
            e.stack = e.stack.replace e.message,""
            throw e
          return q
        #proto[key] = foo
        obj[key] = foo if !prot?
  obj.log   ?= (args...)-> logFunction.apply    obj,args
  obj.error ?= (args...)-> errorFunction.apply  obj,args
  obj._single?= single
  obj._block = (state=true,pref="",err)->
    if (typeof pref != 'string') && (!err?)
      err  = pref
      pref = ""
    if err?
      obj["__blockErr"+pref] = err
    obj["__isBlocked"+pref] ?= false
    return Q() if obj["__isBlocked"+pref] == state
    obj["__isBlocked"+pref] = state
    if state
      obj.emit '_block'+pref
    else
      obj.emit '_unblock'+pref
    Q()
  obj._unblock = (pref="")->
    q = Q()
    if obj["__isBlocked"+pref]
      q = q.then -> _waitFor obj,'_unblock'+pref
    q = q.then ->
      throw obj["__blockErr"+pref] if obj["__blockErr"+pref]?
    return q
  obj._lock = (sel)-> Q.then ->
    _id = __lockId++
    q = Q()
    if __locking
      q = q.then -> _waitFor(__eeLock,''+(_id-1))
    else
      __locking = true
    return q.then ->
      __locking = true
      _lockFoo(sel).then ->
        __locking = false
        __eeLock.emit _id

  _lockArr = {}
  _lockId  = 1
  obj._lock = (_sel,idin=false,_id)->
    id = _id
    id = _lockId++ unless _id?
    sel = '__lock_'+_sel
    lockid       = _lockArr[sel]
    _lockArr[sel] = id unless lockid
    if idin
      idsel=sel+lockid
    else
      idsel=sel
    if lockid
      return obj._unblock(idsel)
        .tick ->
          obj._lock(_sel,idin,id)
        .then (id)->
          return id

    if idin
      idsel = sel+id
    else
      idsel = sel
    obj._block(true,idsel)
    return Q(id)
  obj._unlock = (sel,id="")->
    throw new Error 'bad id' if _lockArr['__lock_'+sel]!=id
    _lockArr['__lock_'+sel] = false
    obj._block(false,'__lock_'+sel+id)
    return Q()

    
      
        #c[key] = foo
        #c.constructor[key]     = foo
  #Wrap obj,proto.constructor.__super__ if proto?.constructor?.__super__?
  unless obj.emit?
    ee = new EE
    #for key,val of ee
    #  if typeof val == 'function'
    #    oldval = val
    #    do (oldval)=>
    #      val = (args...)->
    #        #console.log 'old',oldval,obj,args
    #        oldval.apply obj,args
    #  obj[key] = val
    obj.emit  = -> ee.emit arguments...
    obj.on    = (action,foo)->
      if foo?.constructor?.name == 'GeneratorFunction'
        foo = Q.async foo
      ee.on action, (args...)->
        ret = foo args...
        ret.done() if Q.isPromise ret
    obj.once    = (action,foo)->
      if foo?.constructor?.name == 'GeneratorFunction'
        foo = Q.async foo
      ee.once action, (args...)->
        ret = foo args...
        ret.done() if Q.isPromise ret
  return obj

global.$W = (obj)->
  proto = obj?.__proto__
  proto ?= obj
  return Q.async obj if (typeof obj == 'function') && (obj?.constructor?.name == 'GeneratorFunction')
  return obj if obj.__wraped
  obj.__wraped = true
  newfunc = null
  for fname,func of proto
    continue unless typeof func == 'function'
    if func?.constructor?.name == 'GeneratorFunction'
      do (func)=> newfunc = => Q.async(func).apply obj,arguments
      obj[fname] = newfunc
  unless obj.emit?
    ee = new EE
    obj.emit = -> ee.emit arguments...
    obj.on = (action,foo)->
      foo = Q.async foo if foo?.constructor?.name == 'GeneratorFunction'
      ee.on action,(args...)-> Q.spawn -> yield foo args...
    obj.once = (action,foo)->
      foo = Q.async foo if foo?.constructor?.name == 'GeneratorFunction'
      ee.once action,(args...)-> Q.spawn -> yield foo args...
  return obj


global.lrequire = (name)-> require './lib/'+name

global.Path     = new (require('./service/path'))()
global.Q        = require 'q'

_oldQAsync = Q.async
global.Q.async = (f)=>
  if f?.constructor?.name == 'GeneratorFunction'
    return _oldQAsync.call Q,f
  return f
_oldQSpawn = Q.spawn
global.Q.spawn = (f)=>
  if f?.constructor?.name == 'GeneratorFunction'
    return _oldQSpawn.call Q,f
  return f?()?.done?()

#Q.longStackSupport  = true

global._lookDown = (obj,first,foo)-> do Q.async ->
  [foo,first]=[first,undefined] unless foo?
  return unless obj && ((typeof obj == 'function') || (typeof obj == 'object'))
  qs = []
  if first
    qs.push foo obj,first,obj[first]
  else for key,val of obj
    qs.push foo obj,key,val
  yield Q.all qs
  if first
    if (typeof obj[first] == 'function') || (typeof obj[first] == 'object')
      yield _lookDown obj[first],foo
  else for key,val of obj
    if (typeof val == 'function') || (typeof val == 'object')
      yield _lookDown val,foo
  return
global._lookUp = (obj,first,foo)-> do Q.async ->
  [foo,first]=[first,undefined] unless foo?
  return unless obj && ((typeof obj == 'function') || (typeof obj == 'object'))
  if first
    if (typeof obj[first] == 'function') || (typeof obj[first] == 'object')
      yield _lookUp obj[first],foo
  else for key,val of obj
    if (typeof val == 'function') || (typeof val == 'object')
      yield _lookUp val,foo
  qs = []
  if first
    qs.push foo obj,first,obj[first]
  else for key,val of obj
    qs.push foo obj,key,val
  yield Q.all qs
  return


Q.rdenodeify = (f)-> Q.denodeify (as...,cb)-> f? as..., (a,b)->cb? b,a
Q.denode  = -> Q.denodeify  arguments...
Q.rdenode = -> Q.rdenodeify arguments...

global._invoke  = (args...)-> Q.ninvoke args...


Q.then = -> Q().then arguments...
###
  args = arguments
  d = Q.defer()
  process.nextTick ->
    q = Q()
    q.then.apply q,args
    d.resolve q
  d.promise
###
###
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
###
Q.Promise::wait = (t,args...)->
  unless typeof t == 'number'
    args = [arguments...]
    t = 0
  q = Q.Promise::delay.call @,t
  if args.length
    q = q.then args...
  return q
###
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
  ###
Q.wait = -> Q().wait arguments...
Q.tick = -> Q().wait arguments...
Q.Promise::tick = Q.Promise::wait
global.EE           = require('events').EventEmitter
EE.defaultMaxListeners = 100

class Wraper extends EE
  constructor : ->
    Wrap @
global.Wraper = Wraper

global.Exception = (e)=>
  str = ""
  str += (e.name+"\n").blue    if e.name?
  str += (e.message+"\n").cyan if e.message?
  str += (""+e.stack).grey          if e.stack?
  return str
global.ExceptionJson = (e)=>
  _jsoned : true
  name    : e.name
  message : e.message
  stack   : e.stack
  _obj     : e._obj
global.ExceptionUnJson = (j)=>
  e = new Error()
  e.stack   = j.stack
  e.message = j.message
  e.name    = j.name
  e._obj     = j._obj
  if e._obj? && (typeof e._obj == 'object') && e._obj != null
    for key,val of e._obj
      e[key] = val


  return e
#global.Watcher  = new (lrequire('watcher'))()

class Lib
  constructor : ->
    Wrap @
  init : ->
    #Watcher.init()
    #
_js_infinite_json = require 'js-infinite-json'
global._fse     = require 'fs-extra'
global._deflate = Q.denode require('zlib').deflate
global._gzip = Q.denode require('zlib').gzip
global._qlimit  = require './lib/qlimit'
global._crypto  = require 'crypto'
global._        = require 'lodash'
global._util    = require 'util'
global._fs      = require 'fs'
global._readdir = Q.denode _fs.readdir
global._readFile= Q.denode _fs.readFile
global._writeFile = Q.denode _fs.writeFile
global._exists  = Q.rdenode _fs.exists
global._path    = require 'path'
global._stat    = Q.denode _fs.stat
global._unlink    = Q.denode _fs.unlink
global._inspect = _util.inspect
global._hash    = (f)-> _crypto.createHash('sha1').update(f).digest('hex')
global._object_hash = require './lib/object_hash'
global._toJson  = (o)-> _js_infinite_json.stringify o
global._unJson  = (o)-> _js_infinite_json.parse     o
global._mkdirp  = Q.denode require 'mkdirp'
global._rename  = Q.denode _fs.rename
global._requestPost = Q.denode require('request').post
global._request = Q.denode require('request')
global._fs_copy =   Q.denode _fse.copy
global._fs_remove =   Q.denode _fse.remove
global._readdirp = Q.denode require 'readdirp'
global.md5file = Q.denode require 'md5-file'
regenerator = require("regenerator")
global._LZString = require './lib/lz-string.min.js'
global._regenerator = (source)-> regenerator.compile(source).code
babel = require("babel-core")
babel_options = {
  presets : ["stage-0"]
  plugins : [
    "check-es2015-constants"
    "transform-es2015-arrow-functions"
    "transform-es2015-block-scoped-functions"
    "transform-es2015-block-scoping"
    "transform-es2015-classes"
    "transform-es2015-computed-properties"
    "transform-es2015-destructuring"
    "transform-es2015-duplicate-keys"
    "transform-es2015-for-of"
    "transform-es2015-function-name"
    "transform-es2015-literals"
    #"transform-es2015-modules-commonjs"
    "transform-es2015-object-super"
    "transform-es2015-parameters"
    "transform-es2015-shorthand-properties"
    "transform-es2015-spread"
    "transform-es2015-sticky-regex"
    "transform-es2015-template-literals"
    "transform-es2015-typeof-symbol"
    "transform-es2015-unicode-regex"
    "transform-regenerator"
    #"transform-strict-mode"
  ]
  compact : false
  comments : true
}
global._regenerator = (s)->
  ret = babel.transform s, babel_options
  return ret.code

global._rmrf = Q.denode require 'rimraf'
global._args    = (a)->
  for ar,i in a
    if ar == null
      a[i] = undefined
  return a
global._randomHash = (b=20)-> _crypto.randomBytes(b).toString('hex')
global._shash   = (f)-> _hash(f).substr 0,10
global._invoke  = (args...)-> Q.ninvoke args...
global._mkdirp  = Q.denode require 'mkdirp'

require './lib/wget'
zlib    = require 'zlib'
zlib_gzip = Q.denode zlib.gzip
global._gzip = (data)-> zlib_gzip data,{level:5}

#v8clone = require 'node-v8-clone'
#global._clone   = (o,d=true)-> v8clone.clone o,d
module.exports  = Lib

global._waitFor = (obj,action,time=300000)->
  waited = false
  defer = Q.defer()
  obj.once action, (args...)=>
    args = args[0] if args.length == 1
    waited = true
    defer.resolve args
  if time > 0
    setTimeout =>
      return if waited
      defer.reject "timout waiting action #{action}"
    ,time
  return defer.promise
  
global._Inited = (obj)-> Q.then ->
  obj.__initing = 0
  return true if obj.__initing > 1
  if obj.__initing == 1
    return _waitFor(obj,'inited').then -> true
  obj.__initing = 1
  return false

global._setKey = (obj,key,val,force=false)=>
  key = key?.split '.' if typeof key == 'string'
  return obj unless key?.length
  if val? || force
    obj?[key?[0]] ?= {}
    obj?[key?[0]] = val if key?.length <= 1
  kk  = key?.shift?()
  obj = obj?[kk] if kk != ""
  return obj if (!key?.length) || (!obj) || (!typeof obj == 'object')
  return global._setKey obj,key,val,force

# parse obj like : form:key:foo
parseFKF = (obj)=>
  ret = {}
  return ret unless obj
  if typeof obj == 'string'
    ret.form = obj
    return ret
  if typeof obj == 'object'
    ret.form = Object.keys(obj)?[0]
    obj = obj[ret.form]
    return ret unless obj
    if typeof obj == 'string'
      ret.key = obj
      return ret
    if typeof obj == 'object'
      ret.key = Object.keys(obj)?[0]
      obj = obj[ret.key]
      ret.foo = obj if typeof obj == 'function'
      return ret
  return ret
  
global._objRelativeKey = (obj,key,foo,part="")=>
  return unless obj && (typeof obj =='object')
  for k,v of obj
    if k == key
      foo obj,part,parseFKF v
      continue
    if v && typeof v == 'object'
      npart = part
      npart += '.' if npart
      npart += k
      _objRelativeKey v,key,foo,npart
global._declOfNum = (number, titles)->
  cases = [2, 0, 1, 1, 1, 2]
  return titles[ if (number%100>4 && number%100<20) then 2 else cases[ if(number%10<5) then number%10 else 5 ]]



global._diff = require './diff/main'

global._nameLib = require('./lib/name')

helpers = {}
global._Helper = (service)-> helpers[service] ?= new (require('./'+service))
global._HelperJobs = _Helper 'jobs/main'


_spawn = require('child_process').spawn
global._exec = (file,args...)->
  d = Q.defer()
  prog = _spawn file,args
  data = ""
  prog.stdout.on 'data',(d)-> data+=d
  prog.stderr.on 'data',(d)-> data+=d
  prog.on 'close',-> d.resolve data
  prog.on 'error',(err)-> d.reject err
  return d.promise
  


