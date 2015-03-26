
Module = require './module'

_fs = require 'fs'
_readdir =  Q.denodeify _fs.readdir
_stat    =  Q.denodeify _fs.stat
class Site
  constructor : (@name)->
    Wrap @
    @path = {}
    @path.site    = "#{Path.sites}/#{@name}"
    @path.modules = "#{@path.site}/modules"
    @module = {}
  init : => Q.tick =>
    Log "site(#{@name}):init"
  addModule : (module)=> Q.tick =>
    Log3 "site(#{@name}):addModule",module.name
    @module[module.name] = new Module module.name,@,module
    @module[module.name].init()
  rescanModules : => Q.tick =>
    Log "site(#{@name}):rescanModules"
    @scanDirForModule ""
  scanDirForModule : (prefix)=> Q.tick =>
    #Log3 "site(#{@name}):scanDirForModule","/"+prefix
    _readdir "#{@path.modules}/#{prefix}"
    .tick (files)=>
      pref = prefix
      pref += '/' if pref
      qs = []
      for file in files
        name = "#{pref}#{file}"
        do (name)=>
          q = _stat "#{@path.modules}/#{name}"
          .tick (stat)=>
            return unless stat.isDirectory()
            Q.all [
              @addModuleByDir   name
              @scanDirForModule name
            ]
          qs.push q
      Q.all qs

  addModuleByDir : (name)=> Q.tick =>
    return if @module[name]?
    #Log3 "site(#{@name}):addModuleByDir",name
    @module[name] = new Module name,@
    @module[name].init()

module.exports = Site


