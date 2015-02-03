
Lib = new (require './lib')()
console.log Lib
_cluster = require 'cluster'

log = (msg)=>
  console.log.apply console, ["main_process:#{process.pid}", arguments...]
error = (msg)=>
  console.error "********************************************************"
  console.error "EE:main_process:#{process.pid}", arguments...
  console.error "********************************************************"
process.on 'uncaughtException', (e)=>
  error "uncaughtException",e.stack
  process.exit 1

process.on 'exit', (code)=>
  for id,worker of _cluster.workers
    worker.kill()
  log "exit with code #{code}"

process.on 'SIGINT', =>
  log "SIGINT"
  process.exit 0

process.on 'SIGTERM', =>
  log "SIGTERM"
  process.exit 0


class module.exports
  constructor : ->
    Wrap @
    @domain   = require 'domain'
    @context  = @domain.create()
    @context.on 'error', @onerror
  init : => Q.then =>
    Lib.init()
    .then =>
      Main = require "./main"
      @main = new Main()
      @main.init()
    .catch (e)=>
      error 'main class handle',Exception e
      process.exit 1
  onerror : (err)=>
    try
      error 'main domain handle',Exception err
      process.exit 1
  run : ->
    Q.then =>
      log "run()"
    .catch (e)=>
      error 'main class handle', Exception e
      process.exit 1


