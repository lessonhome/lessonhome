
global.Q = require "q"
Q.longStackSupport = true
global.CLONE = require './lib/clone'

LoadSites = require './scripts/loadSites'
Server    = require './class/server/server'
fs        = require 'fs'
_path     = require 'path'
mkdirp    = require 'mkdirp'
unlink    = Q.denodeify fs.unlink
readdir   = Q.denodeify fs.readdir
spawn     = require('child_process').spawn
watch     = require 'node-watch'
exists    = Q.denodeify fs.exists
coffee    = require 'coffee-script'
Static    = require './class/static'

class module.exports
  constructor : ->
    global.Feel = this
    @site         = {}
    @sassChanged  = {}
    @static       = new Static()
    @path =
      www   : "www"
      cache : ".cache"
    @init()
    .done()
  init : =>
    Q()
    .then => mkdirp '.cache'
    .then => mkdirp 'log'
    .then @checkCache
    .then @compass
    .then LoadSites
    .then @watch
    .then @static.init
    .then @loadClient
    .then @createServer
  createServer : =>
    @server = new Server()
    Q().then @server.init

  checkCache : =>
    @checkCacheDir @path.cache
  checkCacheDir : (dir)=>
    readdir dir
    .then (files)=>
      for f in files
        stat = fs.statSync "#{dir}/#{f}"
        if stat.isDirectory()
          @checkCacheDir "#{dir}/#{f}"
        else
          @checkCacheFile "#{dir}/#{f}"
  checkCacheFile : (file)=>
    if file.match /.*(\.css)$/
      sass = file.match /^.cache\/(.*)\.css$/
      if sass[1] && !fs.existsSync "www/#{sass[1]}.sass"
        fs.unlinkSync file
  cacheFile : (path,data)=>
    path = _path.normalize path
    cache = path.replace /^\w+\//, ".cache\/"
    cache = _path.normalize cache
    cache = ".cache/"+cache unless cache.match /^\.cache\//
    return null if cache == path
    cachedir = _path.dirname cache
    srcStat = fs.statSync path

    if fs.existsSync cache
      cacheStat = fs.statSync cache
      if cacheStat.isFile() && (cacheStat.mtime>srcStat.mtime) && !data?
        return fs.readFileSync cache
      if cacheStat.isFile()
        fs.unlinkSync cache
    return data if !data?
    if !fs.existsSync cachedir
      mkdirp.sync cachedir
    fs.writeFileSync cache, data
    return data
  cacheCoffee : (path)=>
    data = @cacheFile path
    return data if data?
    data = coffee._compileFile path
    return @cacheFile path,data
  compass : =>
    defer = Q.defer()
    process.chdir 'feel'
    console.log 'compass compile'
    compass = spawn 'compass', ['compile']
    process.chdir '..'
    #compass.stdout.on 'data', (data)=> process.stdout.write data
    compass.stderr.on 'data', (data)=> process.stderr.write 'compass: '+data
    compass.on 'close', (code)=>
      if code != 0
        defer.reject new Error 'compass failed'
      else
        defer.resolve()
    return defer.promise
  npm : =>
    defer = Q.defer()
    process.chdir 'feel'
    console.log 'npm install'
    npm = spawn 'npm', ['i']
    process.chdir '..'
    npm.stdout.on 'data', (data)=> process.stdout.write data
    npm.stderr.on 'data', (data)=> process.stderr.write data
    npm.on 'close', (code)=>
      if code != 0
        defer.reject new Error 'npm i failed'
      else
        defer.resolve()
    return defer.promise
  watch : =>
    watch  @path.www, {recursive:true}, @watchHandler
  watchHandler : (file)=>
    m = file.match /^[^\/]+\/([^\/]+)\/([^\/]+)\/?(.*)\/([^\.][^\/]+)\.(\w+)$/
    return unless m
    o =
      site  : m[1]
      type  : m[2]
      dir   : m[3]
      name  : m[4]
      ext   : m[5]
    if o.ext == 'sass'
      @rebuildSass o.site,o.dir,o.name
    if o.ext == 'jade'
      @site[o.site].modules[o.dir].rebuildJade()
  rebuildSass : (site,module,name)=>
    console.log "rebuild sass for #{site}/#{module}:#{name}.sass"
    cache = "#{@path.cache}/#{site}/modules/#{module}/#{name}.css"
    @sassChanged["#{site}/#{module}"] = {
      site
      module
    }
    fs.exists cache, (ex)=>
      return @compileSass() unless ex
      fs.unlink cache, =>
        return @compileSass()
  
  compileSass : =>
    @compass()
    .then =>
      arr = []
      for key,val of @sassChanged
        arr.push val
      @sassChanged = {}
      return arr.reduce (promise,o)=>
        m = @site[o.site].modules[o.module]
        promise.then =>
          m.rescanFiles()
          .then m.makeSassAsync
      , Q()
    .done()
    
  loadClient : =>
    @client   = {}
    @clientJs = ""
    @loadClientDir 'feel/lib/feel/client',''
    .then =>
      @clientJs += @client['main']
      for key,val of @client
        @clientJs += val unless key == 'main'
  loadClientDir : (path,dir)=>
    readdir "#{path}#{dir}"
    .then (files)=>
      for f in files
        file = "#{path}#{dir}/#{f}"
        stat = fs.statSync file
        ndir = "#{dir}/#{f}"
        if stat.isDirectory()
          @loadClientDir path,ndir
        else if stat.isFile() && f.match /^[^\.].*\.coffee$/
          src = @cacheCoffee file
          n = ndir.match /^(.*)\.coffee$/
          @client[n[1]] = src

