

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

global._production = false
if require('os').hostname() == 'pi0h.org'
  global._production = true

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
  return unless proto?
  return if obj.__wraped
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
global.lrequire = (name)-> require './lib/'+name

global.Path     = new (require('./service/path'))()
global.Q        = require 'q'

#Q.longStackSupport  = true



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
global._deflate = Q.denode require('zlib').deflate
global._qlimit  = require './lib/qlimit'
global._crypto  = require 'crypto'
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
global._toJson  = (o)-> _js_infinite_json.stringify o
global._unJson  = (o)-> _js_infinite_json.parse     o
global._mkdirp  = Q.denode require 'mkdirp'
global._rename  = Q.denode _fs.rename
regenerator = require("regenerator")
global._regenerator = (source)-> regenerator.compile(source).code
global._args    = (a)->
  for ar,i in a
    if ar == null
      a[i] = undefined
  return a
global._randomHash = (b=20)-> _crypto.randomBytes(b).toString('hex')
global._shash   = (f)-> _hash(f).substr 0,10
global._invoke  = (args...)-> Q.ninvoke args...
global._mkdirp  = Q.denode require 'mkdirp'
module.exports  = Lib

global._waitFor = (obj,action,time=60000)-> Q.then ->
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
      return
    ,time
  return defer.promise
  
global._Inited = (obj)-> Q.then ->
  obj.__initing = 0
  return true if obj.__initing > 1
  if obj.__initing == 1
    return _waitFor(obj,'inited').then -> true
  obj.__initing = 1
  return false



