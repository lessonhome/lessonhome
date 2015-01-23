
Module = require './module'

_fs = require 'fs'
_readdir =  Q.denodeify _fs.readdir
_stat    =  Q.denodeify _fs.stat
class Site
  constructor : (@name)->
    @path = {}
    @path.site    = "#{Path.sites}/#{@name}"
    @path.modules = "#{@path.site}/modules"
    @module = {}
  init : => Q().then =>
    console.log 'init site',@name
  addModule : (module)=> Q().then =>
    @module[module.name] = new Module module.name,@,module
    @module[module.name].init()
  rescanModules : => Q().then =>
    @scanDirForModule ""
  scanDirForModule : (prefix)=> Q().then =>
    _readdir "#{@path.modules}/#{prefix}"
    .then (files)=>
      pref = prefix
      pref += '/' if pref
      q = Q()
      for file in files
        name = "#{pref}#{file}"
        do (name)=>
          q = q.then =>
            _stat "#{@path.modules}/#{name}"
          .then (stat)=>
            return unless stat.isDirectory()
            @addModuleByDir name
            .then => @scanDirForModule name
      return q

  addModuleByDir : (name)=> Q().then =>
    return if @module[name]?
    @module[name] = new Module name,@
    @module[name].init()

module.exports = Site


