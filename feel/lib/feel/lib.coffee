global.Path = new (require('./service/path'))()
global.Q            = require 'q'
Q.longStackSupport  = true
Q.tick = ->
  args = arguments
  d = Q.defer()
  process.nextTick ->
    q = Q()
    q.then.apply q,args
    d.resolve q
  d.promise
Q.Promise::tick = ->
  args = arguments
  q = Q.tick ->
    console.log 'tick',args
    Q().then args...
  console.log 'q',q
  q = q.then =>
    console.log 'q then'
  console.log 'q',q
  @then =>
    console.log 'this then'
  .then q
 
 
global.EE           = require('events').EventEmitter

global.Exception = (e)=>
  str = ""
  str += e.name+"\n"    if e.name?
  str += e.message+"\n" if e.message?
  str += e.stack        if e.stack?
  return str


