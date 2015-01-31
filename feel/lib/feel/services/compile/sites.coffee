

_fs = require 'fs'
_readdir  = Q.denodeify _fs.readdir
_stat     = Q.denodeify _fs.stat

Site = require './site'


class Sites
  constructor : ->
    @db = Main.db.collection 'modules'
    @site = {}
  init    : => Q.tick =>
    console.log 'sites:init'
    _readdir Path.sites
    .then (sites)=>
      qs = []
      for sitename in sites
        do (sitename)=>
          q = _stat "#{Path.sites}/#{sitename}"
          .then (stat)=>
            throw new Error "bad sitename #{sitename}" unless stat.isDirectory()
            @site[sitename] = new Site sitename
            @site[sitename].init()
          qs.push q
      Q.all qs
    .then => @loadDb()
    .then =>
      qs = []
      for sitename,site of @site
        qs.push site.rescanModules()
      Q.all qs
  loadDb  : => Q.tick =>
    console.log 'sites:loadDb'
    defer = Q.defer()
    qs = []
    @db.find().each (err,module)=>
      qs.push Q.reject err if err?
      if module?.sitename? && module?.name?
        qs.push @site[module.sitename].addModule module
      else unless module?
        defer.resolve Q.all qs
    return defer.promise
        
      
module.exports = Sites

