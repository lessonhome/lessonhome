
global.Q = require "q"
Q.longStackSupport = true
global.CLONE = require './lib/clone'

LoadSites = require './scripts/loadSites'
Server    = require './class/server/server'

spawn     = require('child_process').spawn

class module.exports
  constructor : ->
    global.Feel = this
    @site = {}
    @path =
      www   : "www"
      cache : ".cache"
    @init()
    .done()
  init : =>
    Q()
    .then @npm
    .then @compass
    .then LoadSites
    .then @createServer
  createServer : =>
    @server = new Server()
    Q().then @server.init

  compass : =>
    defer = Q.defer()
    process.chdir 'feel'
    console.log 'compass compile'
    compass = spawn 'compass', ['compile']
    process.chdir '..'
    #compass.stdout.on 'data', (data)=> process.stdout.write data
    compass.stderr.on 'data', (data)=> process.stderr.write 'compass: '+data
    compass.on 'close', (code)=>
      if code != 0
        defer.reject new Error 'compass failed'
      else
        defer.resolve()
    return defer.promise
  npm : =>
    defer = Q.defer()
    process.chdir 'feel'
    console.log 'npm install'
    npm = spawn 'npm', ['i']
    process.chdir '..'
    npm.stdout.on 'data', (data)=> process.stdout.write data
    npm.stderr.on 'data', (data)=> process.stderr.write data
    npm.on 'close', (code)=>
      if code != 0
        defer.reject new Error 'npm i failed'
      else
        defer.resolve()
    return defer.promise
    
    
