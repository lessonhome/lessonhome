

class Module extends EE
  constructor : (@name,@site,options)->
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
      console.log "module(#{@site.name}:#{@name}):init"
      @emit 'init'
      @inited = true
    .tick @updateDb
  updateDb : => Q.tick =>
    obj =
      name      : @name
      sitename  : @site.name
    return if JSON.stringify(obj) == JSON.stringify(@indb)
    console.log "module(#{@site.name}:#{@name}):updateDb"
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


module.exports = Module


