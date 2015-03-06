

_mime = require 'mime'


class MasterDir
  constructor : (@conf)->
    Wrap @
    @_block().done()
  fixPath : =>
    conf = @conf
    console.log conf
    if typeof conf == 'string'
      conf = path:_path.resolve "#{process.cwd()}/#{conf}"
    if conf.path
      conf.dir = _path.relative process.cwd(),conf.path
    else
      if conf.dir
        conf.path = _path.resolve "#{process.cwd()}/#{conf.dir}"
      else
        throw new Error 'cant resolve path in config'+_inspect(conf)
    conf.pdir = _path.dirname  conf.dir
    conf.name = _path.basename conf.dir
    console.log 'ok'
    @conf = conf
  init :  (@master)=>
    @on 'deleted',@onDeleted
    @on 'change', @change
    yield @fixPath()
    @in   = {}
    @dir = {}
    for key,val of @conf
      @dir[key]  = val
      @in[key]   = val
    if @dir.ready
      yield @regetContent()
      @_block(false)
    yield @stat()

  regetContent : =>
    qd = []
    if @dir.dirs?
      for dir in @dir.dirs
        qd.push @master.dir dir
    qf = []
    if @dir.files?
      for file in @dir.files
        qf.push @master.file file
    [qd,qf] = yield Q.all [Q.all(qd),Q.all(qf)]
    console.log qd,qf
  stat : =>
    yield @_single()
    #@log 'stat',@file.file.red
    @dir.exists = yield _exists @dir.path
    return @delete() unless @dir.exists
    @dir.stat   = yield _stat   @dir.path
    delete @dir.stat.atime
    delete @dir.stat.ino
    
    statHash = _shash _inspect @dir.stat
    @_block()
    @dir.statHash = statHash
    readed = yield _readdir @dir.path
    files = []
    dirs  = []
    qs = []
    for f in readed
      do (f)=>
        q = _exists(@dir.path+"/"+f)
        .then (ex)=>
          return false unless ex
          return _stat @dir.path+"/"+f
        qs.push q
    qs = yield Q.all qs
    for f,i in readed
      if qs[i]?.isFile?()
        files.push "#{@dir.dir}/#{f}"
      else if qs[i]?.isDirectory?()
        dirs.push  "#{@dir.dir}/#{f}"

    @dir.dirs   = dirs
    @dir.files  = files
    hash  = _shash dirs.join(',')+';'+files.join(',')
    dhash = @dir.hash
    @dir.hash = hash
    @_block(false)
    return if dhash == hash
    yield @updateDb()
  delete : =>
    @emit 'deleted',@dir
  onDeleted : =>
    @_block()
    @_block false,new Error 'dir deleted',@dir.path
    yield @initDb()
    yield _invoke @db,'delete',path:@dir.path

  updateDb  : =>
    yield @_single()
    _dir = @dir
    _in   = @in
    update = false
    for key,val of _dir
      if val != _in[key]
        update = true
    return unless update
    @in = {}
    for key,val of _dir
      @in[key] = val
    #@log 'write to db'.yellow,_file.file
    yield @initDb()
    yield _invoke @db,'update',{path:_dir.path},{$set:_dir},{upsert:true}
    @emit 'change',@dir if _in.hash != _dir.hash
  change : (f)=>
    #@log f.dir.yellow,f.hash.grey
  initDb : =>
    return if @db?
    db  = yield Main.serviceManager.nearest('db')
    @db = yield db.get 'watcherDirs'

  get :   =>
    yield @_unblock()
    return @dir

    

module.exports = MasterDir





