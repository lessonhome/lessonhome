

_fs = require 'fs'
_readdir  = Q.denodeify _fs.readdir
_stat     = Q.denodeify _fs.stat

Site = require './site'


class Sites
  constructor : ->
    @db = Main.db.collection 'modules'
    @site = {}
  init    : => Q().then =>
    _readdir Path.sites
    .then (sites)=>
      q = Q()
      for sitename in sites
        do (sitename)=>
          q = q.then =>
            _stat "#{Path.sites}/#{sitename}"
          .then (stat)=>
            throw new Error "bad sitename #{sitename}" unless stat.isDirectory()
            @site[sitename] = new Site sitename
            @site[sitename].init()
      return q
    .then => @loadDb()
    .then =>
      q = Q()
      for sitename,site of @site
        q = q.then => site.rescanModules()
      return q
  loadDb  : => Q().then =>
    defer = Q.defer()
    q = Q()
    @db.find().each (err,module)=>
      if module?.sitename? && module?.name?
        q = q.then => @site[module.sitename].addModule module
      else
        return defer.reject err if err?
        defer.resolve q
    return defer.promise
        
      
module.exports = Sites

