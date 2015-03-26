
_fs       = require 'fs'
_readdir  = Q.denodeify _fs.readdir

class Module extends EE
  constructor : (@name,@site,options)->
    Wrap @
    @path = "#{@site.path.modules}/#{@name}"
    if options?
      @[key] = val for key,val of options
      @indb = options
      delete @indb._id
    @indb ?= {}
    @inited = false
  init : =>
    Q.tick =>
      return if @inited
    .tick =>
      Log3 "module(#{@site.name}:#{@name}):init"
      @emit 'init'
      @inited = true
    .tick @updateDb
  updateDb : => Q.tick =>
    obj =
      name      : @name
      sitename  : @site.name
    return if JSON.stringify(obj) == JSON.stringify(@indb)
    Log3 "module(#{@site.name}:#{@name}):updateDb"
    @indb = obj
    @db = Main.db.collection 'modules'
    Q.ninvoke @db,'update',{
      name      : @name
      sitename  : @site.name
    },{
      $set : obj
    },{
      upsert : true
    }
    .tick (result)=>
      @emit 'change'
  
  scanFiles : =>

    

module.exports = Module


