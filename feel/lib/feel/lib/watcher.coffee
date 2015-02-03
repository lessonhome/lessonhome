
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
  init : => Q.tick =>
    _exists @path
    .then (exists)=>
      throw new Error 'destructor' unless exists
      _stat @path
    .then (s)=>
      delete s.atime
      hashStat = _crypto.createHash('sha1').update(JSON.stringify(s)).digest('hex').substr 0,10
    .catch (e)=>
      return @destructor() if e.message == 'destructor'
      e.message += "\niniting file #{@path}"
      throw e

  destructor : => Q.then =>
    
class Dir extends EE
  constructor : (@path,options)->
    @[key] = val for key,val of options
  init : => Q.tick =>

  
class Watcher
  constructor : ->
    Wrap @
    @files = {}
  init : => Q.tick =>
    console.log 'watcher init'
    file = new File 'run.sh'
    file.init()
  loadDb : => Q.tick =>
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


