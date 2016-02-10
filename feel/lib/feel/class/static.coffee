
fs      = require 'fs'
crypto  = require('crypto')
watch   = require 'watch'
_path   = require 'path'
mime    = require 'mime'
mkdirp  = require 'mkdirp'


class Static
  constructor : ->
    @files = {}

  init : =>
    @www = "#{process.cwd()}/www"
    @watch()
  watch : =>
    return if _production
    q = Q()
    watch.createMonitor './',(@monitor)=>
      ###
      for file,stat of @monitor.files
        if file.match /^www\/\w+\/static\/.*\.\w+$/
          if stat.isFile()
            do (file,stat)=> q = q.then =>
              process.stdout.write '.'
              Q.rdenode(@createHash) file,stat
      q.done()
      ###
      if _production
        @monitor.stop()
      else
        @monitor.on 'created', @mcreated
        @monitor.on 'changed', @mchanged
        @monitor.on 'removed', @mremoved
    
  mcreated : (f,stat)=>
    @checkHash f,stat
  mchanged : (f,stat,pstat)=>
    @checkHash f,stat
  mremoved : (f,stat)=>
    delete @watch[f] if @watch[f]
  checkHash : (f,stat,cb)=>
    f = _path.resolve f
    return cb?() unless @watch[f]?
    @createHash f,stat,cb
  createHash : (f,stat,cb)=>
    f = _path.resolve f
    if !stat?
      return fs.exists f,(exists)=>
        unless exists
          @deleteHash f
          return cb?()
        fs.stat f,(err,stats)=>
          if err || !stats.isFile()
            @deleteHash f
            return cb?()
          @createHash f,stats,cb
    sha1 = crypto.createHash 'sha1'
    sha1.setEncoding 'hex'
    if stat.size > 10*1024*1024
      sha1.update JSON.stringify stat
      @setHash f, sha1.digest('hex').substr 0,10
      return cb? @watch[f]

    fd = fs.createReadStream f
    fd.on 'end', =>
      sha1.end()
      hash = sha1.read()
      @setHash f,hash
      cb? @watch[f]
    fd.pipe sha1
  setHash : (f,hash)=>
    @watch[f] = hash.substr 0,10

    cacheDir = _path.dirname ".cache/monitor/"+f.replace process.cwd()+"\/", ""
    mkdirp cacheDir, =>

  deleteHash : (f)=>
    delete @watch[f] if @watch[f]?
  createHashS : (f,stat)=>
    f = _path.resolve f
    if !stat?
      exists = fs.existsSync f
      unless exists
        return @deleteHash f
      stat = fs.statSync f
      if !stat?.isFile?()
        return @deleteHash f
      return @createHashS f,stat
    sha1 = crypto.createHash 'sha1'
    sha1.setEncoding 'hex'
    if stat.size > 100*1024*1024
      sha1.update JSON.stringify stat
    else
      sha1.update fs.readFileSync f
    
    @setHash f,sha1.digest('hex')
    return @watch[f]
    
  handler : (req,res,site)=>
    m     = req.url.match /^\/file\/(\w+)\/([^\.].*)\.(\w+)$/
    return Feel.res404 req,res unless m
    isroot = false
    if req.url.match /^\/file\/\w+\/root\//
      isroot = true
    if req.url.match(/^\/file\/\w+\/root\/(.*)\.coffee$/)
      return Feel.res403 req,res

    if m[2].match /\.\./
      return Feel.res404 req,res unless m
    hash  = m[1]
    fname = "#{m[2]}.#{m[3]}"
    path  = "./www/#{site}/static/#{fname}"
    hhash = req.headers['if-none-match']

    hhash ?= 2
    @hash path,(rhash=1)=>
      res.setHeader 'ETag', rhash
      unless isroot
        res.setHeader 'Cache-Control', 'public, max-age=126144001'
        res.setHeader 'Expires', "Thu, 07 Mar 2086 21:00:00 GMT"
      else
        res.setHeader 'Cache-Control', 'public, max-age=60'
      return @res304 req,res if rhash==hhash
      if rhash != hash
        unless isroot
          return @url fname,site,(url)=> @res303 req,res,url
      ext   = m[3]
      if @files[path]?
        return @write @files[path],req,res

      fs.readFile path, (err,data)=> fs.stat path,(err2,stat)=>
        if err? || err2?
          console.error Exception err,err2
          return Feel.res500 req,res,err||err2
        @files[path] =
          data : data
          mime : mime.lookup path
          stat : stat
          name : fname
        return @write @files[path],req,res
  statRoot : (url,site)=> do Q.async =>
    @cacheStatRoot ?= {}
    return @cacheStatRoot[site+url] if @cacheStatRoot[site+url]
    ftext =_path.resolve "#{@www}/#{site}/static/root/"+_path.resolve url
    fdir = _path.dirname ftext
    ftext = _path.relative fdir,ftext
    if ftext.match /\./
      fnoext = ""
    else
      fnoext = ftext
      ftext = ""
    try
      readed = yield _readdir fdir
    catch e
      return @cacheStatRoot[site+url] = {}
    files = {}
    exts  = {}
    readed.sort()
    for f in readed
      files[f] = true
      exts[f.replace(/\.\w+$/,"")] = f
      if f.match /\.coffee$/
        exts[f.replace(/\.\w+\.coffee$/,"")+".coffee"] = f

    o = {}
    if ftext
      if files[ftext+'.coffee']
        o.coffee = ftext+'.coffee'
      else if files[ftext]
        o.file = "#{fdir}/#{ftext}"
    else
      if files[fnoext+'.coffee']
        o.coffee = fnoext+'.coffee'
      else if exts[fnoext+'.coffee']
        o.coffee = exts[fnoext+'.coffee']
      else if files[fnoext]
        o.file = "#{fdir}/#{fnoext}"
      else if exts[fnoext]
        o.file = "#{fdir}/#{exts[fnoext]}"
    if o.coffee
      o.coffee =  require "#{fdir}/#{o.coffee}"
      if typeof o.coffee == 'function'
        if o.coffee::handler?
          o.coffee = new o.coffee
      o.coffee = $W o.coffee
      yield o.coffee?.init?()
      yield o.coffee?.run?()
    return @cacheStatRoot[site+url] = o
  handlerRoot : (req,res,site)=> do Q.async =>
    try
      o = yield @statRoot req.url,site
    catch e
      console.error Exception e
      o = {}
    unless o.file || o.coffee
      return Feel.res404 req,res
    if o.coffee
      if typeof o.coffee?.handler == 'function'
        return o.coffee.handler req,res,site
      else if typeof o.coffee == 'function'
        return o.coffee req,res,site
      else throw new Error 'bad root coffee handler in '+req.url
    if o.file
      rel = _path.relative("#{@www}/#{site}/static/root",o.file)
      req.url = "/file/666/root/#{rel}"
      try
        yield @handler req,res,site
        return
      catch e
        console.error Exception e
        return Feel.res500 req,res

    throw new Error 'something gone wrong'

  
      


  res304 : (req,res)=>
    res.writeHead 304
    res.end()
  res303 : (req,res,location)=>
    if req.url == location
      console.error Exception new Error 'req.url == location :'+req.url
      return Feel.res500 req,res
    res.statusCode = 303
    res.setHeader 'Location', location
    res.end()
  write   : (file,req,res)=>
    charset = mime.charsets.lookup(file.mime)
    if charset
      charset = "charset=#{charset}"
    else
      charset = ""
    res.setHeader 'Content-type', "#{file.mime}; #{charset}"
    zlib = require 'zlib'
    zlib.gzip file.data,{level:9},(err,resdata)=>
      if err?
        console.error Exception err
        return Feel.res500 req,res,err
      res.statusCode = 200
      res.setHeader 'Content-Length', resdata.length
      res.setHeader 'Content-Encoding', 'gzip'
      #console.log "file\t#{file.name}",resdata.length/1024,file.data.length/1024,Math.ceil((resdata.length/file.data.length)*100)+"%"
      return res.end resdata
  F       : (site,file)=>
    f = _path.resolve "www/#{site}/static/#{file}"
    if @watch[f]?
      hash = @watch[f]
    else
      hash = @hashS f
      #@createHash f
    return "/file/#{hash}/#{file}"
  res404  : (req,res,err)=>
    res.writeHead 404
    res.end()
    console.error err if err?

  hash : (f,cb)=>
    f = _path.resolve f
    return cb(@watch[f]) if @watch[f]?
    hash = @createHash f,null,cb
    hash ?= 666
    return hash
  hashS : (f)=>
    f = _path.resolve f
    return @watch[f] if @watch[f]?
    hash = @createHashS f
    hash ?= 666
    return hash
  url : (f,site,cb)=>
    @hash "www/#{site}/static/#{f}", (hash=666)=>
      cb "/file/#{hash}/#{f}"
  urlS : (f,site)=>
    hash = @hashS "www/#{site}/static/#{f}"
    hash ?= 666
    return "/file/#{hash}/#{f}"

  
  part : (name,site,data)=>
    name = ".cache/part/#{site}/"+_path.normalize(name)
    




module.exports = Static



