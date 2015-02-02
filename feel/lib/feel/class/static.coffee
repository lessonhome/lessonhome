
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
    @watch()
  watch : =>
    watch.createMonitor './',(@monitor)=>
      @monitor.on 'created', @mcreated
      @monitor.on 'changed', @mchanged
      @monitor.on 'removed', @mremoved
      for file,stat of @monitor.files
        if file.match /^www\/\w+\/static\/.*\.\w+$/
          if stat.isFile()
            @createHash file,stat
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
    return @res404 req,res unless m
    if m[2].match /\.\./
      return @res404 req,res unless m
    hash  = m[1]
    fname = "#{m[2]}.#{m[3]}"
    path  = "./www/#{site}/static/#{fname}"
    hhash = req.headers['if-none-match']

    hhash ?= 2
    @hash path,(rhash=1)=>
      res.setHeader 'ETag', rhash
      res.setHeader 'Cache-Control', 'public, max-age=126144001'
      res.setHeader 'Cache-Control', 'public, max-age=126144001'
      res.setHeader 'Expires', "Thu, 07 Mar 2086 21:00:00 GMT"
      return @res304 req,res if rhash==hash==hhash
      if rhash != hash
        return @url fname,site,(url)=> @res303 req,res,url
      console.log "file\t#{m[2]}.#{m[3]}"
      ext   = m[3]
      if @files[path]?
        return @write @files[path],req,res

      fs.readFile path, (err,data)=> fs.stat path,(err2,stat)=>
        if err? || err2?
          return @res404 req,res
        @files[path] =
          data : data
          mime : mime.lookup path
          stat : stat
        return @write @files[path],req,res
  res304 : (req,res)=>
    res.writeHead 304
    res.end()
  res303 : (req,res,location)=>
    return @res404 req,res if req.url == location
    res.statusCode = 303
    res.setHeader 'Location', location
    res.end()
  write   : (file,req,res)=>
    res.setHeader 'Content-type', file.mime
    res.setHeader 'Content-Length', file.stat.size
    res.write file.data
    return res.end()
    
    
  F       : (site,file)=>
    f = _path.resolve "www/#{site}/static/#{file}"
    if @watch[f]?
      hash = @watch[f]
    else
      hash = @hashS f
      #@createHash f
    return "/file/#{hash}/#{file}"
  res404  : (req,res)=>
    res.writeHead 404
    res.end()

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



