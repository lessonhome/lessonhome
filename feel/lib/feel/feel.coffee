
global.Q = require "q"
Q.longStackSupport = true
global.CLONE = require './lib/clone'
_beautify = require 'js-beautify'
LoadSites = require './scripts/loadSites'
Server    = require './class/server/server'
fs        = require 'fs'
_path     = require 'path'
mkdirp    = require 'mkdirp'
unlink    = Q.denodeify fs.unlink
readdir   = Q.denodeify fs.readdir
spawn     = require('child_process').spawn
watch     = require 'node-watch'
coffee    = require 'coffee-script'
Static    = require './class/static'
_readFile = Q.denodeify fs.readFile
_writeFile = Q.denodeify fs.writeFile
_rmrf     = Q.denodeify require('rimraf')
curl = (url)->
  def = Q.defer()
  http = require("http")
  req = http.get "http://127.0.0.1:8081#{url}"
  req.on 'finish', =>
    def.resolve()
  return def.promise
    




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
    .then => @version()
    .then =>
      return if @version == @oversion
      _rmrf('.cache').then -> _rmrf 'feel/.sass-cache'
    .then => mkdirp '.cache'
    .then =>
      _writeFile '.cache/version',@sVersion
    .then => mkdirp 'log'
    .then @checkCache
    .then @compass
    .then LoadSites
    .then @watch
    .then @static.init
    .then @loadClient
    .then @createServer
    #.then @checkPages
  createServer : =>
    @server = new Server()
    Q().then @server.init
  version : =>
    _readFile('feel/version')
    .then (text)=>
      m = text.toString().match /(\d+)\.(\d+)\.(\d+)/
      v = (m[1]*100+m[2])*1000+m[3]
      @version = v
      @sVersion = text
      _readFile('.cache/version')
    .then (text)=>
      m = text.toString().match /(\d+)\.(\d+)\.(\d+)/
      v = (m[1]*100+m[2])*1000+m[3]
      @oversion = v
    .catch (e)=>
      console.error e


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
    console.log 'compass compile'.magenta
    compass = spawn 'compass', ['compile']
    process.chdir '..'
    compass.stdout.on 'data', (data)=>
      return if data.toString().substr(5,9).match /directory/mg
      if data.toString().substr(9,5).match /write/
        m = data.toString().substr(14).match /.*(modules\/.*)\.css/
        if m
          console.log "sass\t\t".cyan,"#{m[1]}.sass".grey
      else
        process.stdout.write data
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
    console.log 'npm install'.red
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
    if o.ext == 'coffee'
      @site[o.site].modules[o.dir].rebuildCoffee()
  rebuildSass : (site,module,name)=>
    console.log "rebuild sass for #{site}/#{module}:#{name}.sass".yellow
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
    @_compiling = true
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
    .catch =>
      setTimeout =>
        @compileSass() unless @_compiling
      , 3000
    .then =>
      @_compiling = false
    .done()
    
  loadClient : =>
    @client   = {}
    @clientJs = ""
    @loadClientDir 'feel/lib/feel/client',''
    .then =>
      for key,val of @client
        @clientJs += val unless key == 'main'
      @clientJs += @client['main']
    @clientJs = @bjs @clientJs
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
          n = ndir.match /^\/(.*)\.coffee$/
          @client[n[1]] = src
  checkPages : =>
    q = Q()
    for sitename,site of @site
      for statename,state of site.state
        if state.class::route? && state.class::title? && state.class::model?
          do (state,statename)=>
            q = q.then =>
              curl state.class::route
    return q
  bcss : (css)=>
    return _beautify.css css,{
      "indent-size" : 2
      "selector-separator-newline" : true
      "newline-between-rules" : true
    }
  bjs  : (js)=>
    return _beautify.js js,{
      "indent_size": 2,
      "indent_char": " ",
      "indent_level": 1,
      "indent_with_tabs": false,
      "preserve_newlines": true,
      "max_preserve_newlines": 10,
      "jslint_happy": true,
      "space_after_anon_function": false,
      "brace_style": "collapse",
      "keep_array_indentation": false,
      "keep_function_indentation": false,
      "space_before_conditional": true,
      "break_chained_methods": false,
      "eval_code": false,
      "unescape_strings": false,
      "wrap_line_length": 0,
      "wrap_attributes": "auto",
      "wrap_attributes_indent_size": 4
    }


    
    


