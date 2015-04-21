

_upload = require 'jquery-file-upload-middleware'
_express = require 'express'
bodyParser = require 'body-parser'
im = require 'imagemagick'
_convert = Q.denode im.convert
_resize = Q.denode im.resize
_identify = Q.denode im.identify
class FileUpload
  constructor : (@site)->
    @dir = "www/#{@site.name}/static/user_data"
    Wrap @
  init : =>
    @app = _express()
    _upload.configure
      uploadDir: process.cwd()+"/#{@dir}/temp"
      uploadUrl: '/upload/image'
      maxPostSize: 1024*1024*200
      minFileSize: 1
      maxFileSize: 1024*1024*20
      acceptFileTypes: /.+/i
      imageTypes: /\.(gif|jpe?g|png)$/i
    _upload.on 'begin',@onBegin
    _upload.on 'abort',@onAbort
    _upload.on 'end',@onEnd
    _upload.on 'delete',@onDelete
    _upload.on 'error',@onError
    #@app.use bodyParser.urlencoded({ extended: false })
    @app.use(bodyParser.json())
    @app.use '/upload/image', (req,res,next)=> Q.spawn =>
      return @res404 req,res unless req?.user?.tutor
      yield #_mkdirp '.user_data/temp/'+req.user.id+'/image'
      _upload.fileHandler(uploadDir:process.cwd()+"/#{@dir}/temp/"+req.user.id+'/image')(req,res,next)
  res404  : (req,res)=>
    res.statusCode = 404
    return res.end()
  handler : (req,res)=>
    @app.handle req,res,@done
    console.log req.body
    #console.log req.set
    #_upload.fileHandler()(req,res,@next)
  next : (args...)=>
    console.log 'next',args...
  onBegin : (info,req,res)=>
    @log info
  onAbort : (info,req,res)=>
    @log info
  onEnd   : (info,req,res)=>
    @log info
  onDelete : (info,req,res)=>
    @log info
  onError   : (e,req,res)=>
    @error e
  done : =>
    @log()
  uploaded : (req,res)=>
    console.log 'uploaded'.red
    return unless req.user?.tutor
    console.log req.user
    files = yield _readdir "#{@dir}/temp/"+req.user.id+"/image"
    arr = []
    qs = []
    yield _mkdirp "#{@dir}/images"
    hash = _randomHash().substr 0,10
    for f in files
      o =
        hash      : hash
        original  : hash+".jpg"
        high      : hash+"h.jpg"
        low       : hash+"l.jpg"
        name      : f
        tdir      : "#{@dir}/temp/"+req.user.id+'/image/'
        ndir      : "#{@dir}/images/"
      arr.push o
      qs.push @parseImage o
    yield Q.all qs
    db = yield Main.service 'db'
    db = yield db.get 'persons'
    photos = yield _invoke db.find({account:req.user.id},{photos:1}), 'toArray'
    photos = photos?[0]?.photos
    photos ?= []
    for o in arr
      photos.push
        hash  : o.hash
        oname : o.name
        dir   : o.ndir
        name  : o.hash
        original : o.original
        high  : o.high
        low   : o.low
        owidth  : o.owidth
        oheight : o.oheight
        hwidth  : o.hwidth
        hheight : o.hheight
        lwidth  : o.lwidth
        lheight : o.lheight
        ourl    : Feel.static.F @site.name,"user_data/images/"+o.original
        hurl    : Feel.static.F @site.name,"user_data/images/"+o.high
        lurl    : Feel.static.F @site.name,"user_data/images/"+o.low
    yield _invoke db, 'update', {account:req.user.id},{$set:{photos:photos}},{upsert:true}
    res.setHeader 'content-type','application/json'
    el = photos.pop()
    res.end JSON.stringify {
      url : el.hurl
      width : el.hwidth
      height : el.hheight
    }
    
  parseImage : (o)=>
    qs = []
    qs.push _resize
      srcPath : o.tdir+o.name
      dstPath : o.ndir+o.high
      width   : 640
      quality : 0.8
    qs.push _resize
      srcPath : o.tdir+o.name
      dstPath : o.ndir+o.low
      width   : 200
      quality : 0.8
    yield Q.all qs
    qs = []
    qs.push _identify o.ndir+o.low
    qs.push _identify o.ndir+o.high
    yield _rename o.tdir+o.name,o.ndir+o.original
    qs.push _identify o.ndir+o.original
    [sl,sh,so] = yield Q.all qs
    o.owidth  = so.width
    o.oheight = so.height
    o.hwidth  = sh.width
    o.hheight = sh.height
    o.lwidth  = sl.width
    o.lheight = sl.height

module.exports = FileUpload





