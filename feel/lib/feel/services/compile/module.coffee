

class Module extends EE
  constructor : (@name,@site,options)->
    if options?
      @[key] = val for key,val of options
      @indb = options
      delete @indb._id
    @indb ?= {}
    @inited = false
  init : =>
    Q().then =>
      return if @inited
    .then =>
      @emit 'init'
      @inited = true
    .then @updateDb
  updateDb : => Q().then =>
    obj =
      name      : @name
      sitename  : @site.name
    return if JSON.stringify(obj) == JSON.stringify(@indb)
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
    .then (result)=>
      @emit 'change'


module.exports = Module


