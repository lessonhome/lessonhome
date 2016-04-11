console.log()
Lib = new (require './lib')()
_cluster = require 'cluster'

log = (msg)=>
  console.log.apply console, ["main_process".blue+":#{process.pid}".grey, arguments...]
error = (msg)=>
  console.error "********************************************************".red
  console.error "ERROR".red+":main_process:".blue+"#{process.pid}".grey, arguments...
  console.error "********************************************************".red
process.on 'uncaughtException', (e)=>
  error "uncaughtException".red,e.stack
  process.exit 1

process.on 'exit', (code)=>
  for id,worker of _cluster.workers
    worker.kill()
  log "exit with code".yellow+" #{code}".red

process.on 'SIGINT', =>
  log "SIGINT".red
  process.exit 0

process.on 'SIGTERM', =>
  log "SIGTERM".red
  process.exit 0


class module.exports
  constructor : ->
    $W @
    @domain   = require 'domain'
    @context  = @domain.create()
    @context.on 'error', @onerror
  init : =>
    yield Lib.init()
    Main_ = require "./main"
    @main = new Main_()
    global.Main = @main
    yield @main.init()
  onerror : (err)=>
    try
      error 'main domain handle'.yellow,Exception err
      process.exit 1
  run : => do Q.async =>
    log "run()".blue
