
_fs     = require 'fs'
_watch  = require 'watch'
_path   = require 'path'
_crypto = require 'crypto'
_mime   = require 'mime'
_stat   = Q.denode  _fs.stat
_exists = Q.rdenode _fs.exists



class File extends EE
  constructor : (@path,options)->
    Wrap @
    @[key]  = val for key,val of options
    @path   = _path.relative Path.root, _path.resolve @path
    @ext    = _path.extname  @path
    @name   = _path.basename @path,@ext
    @dir    = _path.dirname  @path
    @mime   = _mime.lookup   @path
    @hash  ?= "666"
    @ahash ?= {}
  init : =>
    exists = yield _exists @path
    throw new Error "file not exists" unless exists
    @stat   = yield _stat @path
    delete @stat.atime
    hashStat = _crypto.createHash('sha1').update(JSON.stringify(@stat)).digest('hex').substr 0,10
    @hash = hashStat
    return if @ahash.stat==hashStat
    @ahash.stat = hashStat
    hash = hashStat
    if @stat.size < 50*1024*1024
      defer = Q.defer()
      fd    = _fs.createReadStream @path
      hash  = _crypto.createHash 'sha1'
      hash.setEncoding 'hex'
      fd.on 'end', =>
        hash.end()
        defer.resolve hash.read()
      fd.on 'error', (err)=>
        defer.reject err
      fd.pipe hash
      hash = yield defer.promise
    @ahash.file = hash
    @hash       = hash



class Dir extends EE
  constructor : (@path,options)->
    @[key] = val for key,val of options
  init : => Q.tick =>



class Watcher
  constructor : ->
    Wrap @
    @files = {}
  init : =>
    console.log 'watcher init'
    file = new File 'run.sh'
    yield file.init()
    console.log file

  loadDb : =>
    @db = Main.db.collection 'watcher'
    defer = Q.defer()
    qs    = []

    @db.find().each (err,row)=>
      qs.push Q.reject err if err?
      if row?
        qs.push @site[module.sitename].addModule module
      else unless module?
        defer.resolve Q.all qs
    return defer.promise

    .then (c)=>
module.exports = Watcher


