

coffee    = require 'coffee-script'
yui       = require 'yuicompressor'
ycompress = Q.denode yui.compress

class ModuleJs
  constructor : (@module)->
    Wrap @
    @coffee   = {}
    @js       = {}
    @compiled = {}
  init    : =>
    yield @_block()
    yield @initDb()
    yield @loadDb()
    yield @_block(false)
    @on 'change', => console.log 'change'.yellow, @module.name
  run     : =>
    yield @compile()
  compile : =>
    @emit 'lock'
    yield @_unblock()
    yield @_single()
    qs = []
    for file in @module.files
      basename = _path.basename file
      if m = basename.match /^(\w.*)\.(\w+)$/
        qs.push @add file,m[1],m[2]
    yield Q.all qs
    qs = []
    for fname,file of @coffee
      hash = yield file.getHash()
      @compiled[fname] ?= filename:fname
      unless @compiled[fname].hash == hash
        console.log 'hash'.yellow,@compiled[fname].hash, hash
        qs.push @compileFile fname,file
    yield Q.all qs
    @emit 'change' if qs.length
  compileFile : (fname,file)=>
    data = yield file.get()
    place = @compiled[fname]
    place.hash  = data.hash
    place.site  = @module.site.name
    place.source = data.src
    res = coffee._compileFile fname,true
    place.js  = res.js.replace /call\(this\)\;\n$/mg,'call(that);\n'
    place.js += "\n//# sourceMappingURL=/jsmap/#{place.hash}/#{_path.relative(@module.site.path.modules,fname)}"
    place.yjs = yield ycompress place.js
    place.djs = yield _deflate place.js
    place.dyjs= yield _deflate place.yjs
    place.sourceMap = res.v3SourceMap
    console.log place.js.red,place.yjs
    console.log place.js.length,place.yjs.length,place.djs.length,place.dyjs.length,"***".red
    yield @writeToDb place
    @compiled[fname] =
      hash      : place.hash
      filename  : place.filename
  initDb : =>
    db = yield Main.service 'db'
    @db = yield db.get 'feel-modulesJs'
  loadDb : (filename)=>
    defer = Q.defer()
    qs    = []
    find = {module:@module.name,site:@module.site.name}
    if filename?
      find.filename = filename
    @db.find(find,{hash:1,filename:1}).each (err,file)=>
      qs.push Q.reject err    if err?
      qs.push @addFromDb file if file?
      defer.resolve Q.all qs  unless file?
    return defer.promise
  writeToDb : (obj)=>
    unless obj?
      qs = []
      for fname,place of @compiled
        qs.push @writeToDb place
      return yield Q.all qs
    yield _invoke @db,'update',{module:@module.name,filename:obj.filename},{$set:obj},{upsert:true}
    @log 'writed'.yellow,obj.filename
  addFromDb : (dbFile)=>
    @compiled[dbFile.filename] = dbFile
  add : (fname,name,ext)=>
    switch ext
      when 'coffee'
      else return
    file = yield @module.watcher.file fname
    file.on 'change',   =>
      yield @compile()

    file.on 'deleted',  =>
      console.log 'delete'
      delete @coffee[fname]
      delete @compiled[fname]
      yield _invoke @db,'remove',{module:@module.name,filename:fname}
      @emit 'change'
    switch ext
      when 'coffee'
        @coffee[fname] = file





module.exports = ModuleJs
