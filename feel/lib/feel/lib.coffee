
_util = require 'util'

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

global.Wrap = (obj,prot)->
  proto = prot
  proto ?= obj?.__proto__
  return unless proto?
  proto.__wraped ?= {}
  for key,val of proto
    if (typeof val=='function') && !proto.__wraped[key]
      proto.__wraped[key] = true
      do (key,val)->
        foo = ->
          args = arguments
          if val?.constructor?.name == 'GeneratorFunction'
            gen = Q.async val
            q = gen.apply obj,args
          else
            q = Q.then -> val.apply obj,args
          q = q.catch (e)->
            e = new Error e unless _util.isError e
            e.message += "\n#{proto.constructor.name}::#{key}("
            na = []
            for a,i in args
              if typeof a == 'object'
                a = '{'+Object.keys(a).join(',')+'}'
              else a = '...'
              na.push a
            e.message += na.join(',')
            e.message += ");"

            #if key != 'destructor'
            #  if typeof obj.destructor == 'function'
            #    return obj.destructor(e)
            #obj?.emit? 'destruct',e
            throw e
          return q
        proto[key] = foo
        obj[key] = foo if !prot?
        #c[key] = foo
        #c.constructor[key]     = foo
  #Wrap obj,proto.constructor.__super__ if proto?.constructor?.__super__?


global.lrequire = (name)-> require './lib/'+name

global.Path     = new (require('./service/path'))()
global.Q        = require 'q'

Q.longStackSupport  = true



Q.rdenodeify = (f)-> Q.denodeify (as...,cb)-> f? as..., (a,b)->cb? b,a
Q.denode  = -> Q.denodeify  arguments...
Q.rdenode = -> Q.rdenodeify arguments...


Q.then = -> Q().then arguments...
Q.tick = -> Q().tick arguments...
Q.wait = -> Q().wait arguments...
###
  args = arguments
  d = Q.defer()
  process.nextTick ->
    q = Q()
    q.then.apply q,args
    d.resolve q
  d.promise
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

Q.Promise::wait = (wait,fulfilled,rejected,ms)->
  if typeof wait == 'function'
    return @tick arguments
  self = this
  deferred = Q.defer()
  
  _fulfilled = null
  if typeof fulfilled == 'function'
    _fulfilled = Promise_tick_fulfilled = (value)->
      setTimeout ->
        try
          deferred.resolve  fulfilled.call null,value
        catch e
          deferred.rejected e
      ,wait
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

Q.wait = -> Q().wait arguments...

global.EE           = require('events').EventEmitter

class Wraper extends EE
  constructor : ->
    Wrap @
global.Wraper = Wraper

global.Exception = (e)=>
  str = ""
  str += e.name+"\n"    if e.name?
  str += e.message+"\n" if e.message?
  str += e.stack        if e.stack?
  return str

global.Watcher  = new (lrequire('watcher'))()

class Lib
  constructor : ->
    Wrap @
  init : ->
    Watcher.init()
module.exports = Lib
