

_cluster = require 'cluster'
global.EE = require('events').EventEmitter
global.Q            = require "q"
Q.longStackSupport  = true


log = (msg)=>
  console.log.apply console, ["main_process:#{process.pid}", arguments...]
error = (msg)=>
  console.error ""
  console.error.apply console, ["EE:main_process:#{process.pid}", arguments...]
  console.error ""
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

Main = require "./main"

class module.exports
  constructor : ->
    @domain   = require 'domain'
    @context  = @domain.create()
    @context.on 'error', @onerror
    @main = new Main()
    @main.init().done()
  onerror : (err)=>
    try
      error 'main domain handle',err.stack
      process.exit 1
  run : ->

