

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
      tmpDir: ".cache/"
      uploadDir: "#{@dir}/temp"
      uploadUrl: '/upload/image'
      maxPostSize: 1024*1024*200
      minFileSize: 1
      maxFileSize: 1024*1024*200
      acceptFileTypes: /(gif|jpe?g|png|pdf|doc|docx|bmp)/i
      imageArgs: ['-auto-orient']
      imageTypes: /\.(gif|jpe?g|png|bmp)$/i
      accessControl:
        allowOrigin: '*',
        allowMethods: 'OPTIONS, HEAD, GET, POST, PUT'
    _upload.on 'begin',@onBegin
    _upload.on 'abort',@onAbort
    _upload.on 'end',@onEnd
    _upload.on 'delete',@onDelete
    _upload.on 'error',@onError
    #@app.use bodyParser.urlencoded({ extended: false })
    @app.use(bodyParser.json())
    @app.get '/upload/image', (req,res)-> res.redirect '/'
    @app.put '/upload/image', (req,res)-> res.redirect '/'
    @app.delete '/upload/image', (req,res)-> res.redirect '/'
    @app.use '/upload/image', (req,res,next)=> Q.spawn =>
      return @res404 req,res unless req?.user?.tutor
      #console.log 'mkdirp',"#{@dir}/temp/"+req.user.id+'/image'
      yield _mkdirp "#{@dir}/temp/"+req.user.id+'/image' #_mkdirp '.user_data/temp/'+req.user.id+'/image'
      _upload.fileHandler(uploadDir:"#{@dir}/temp/"+req.user.id+'/image')(req,res,next)
  res404  : (req,res)=>
    res.statusCode = 404
    return res.end()
  handler : (req,res)=>
    @app.handle req,res,@done
    ##console.log req.body
    ##console.log req.set
    #_upload.fileHandler()(req,res,@next)
  next : (args...)=>
    #console.log 'next',args...
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
    #console.log 'uploaded'.red
    return unless req.user?.tutor

    db = yield Main.service 'db'
    personsDb = yield db.get 'persons'
    uploadedDb = yield db.get 'uploaded'

    qs = require 'querystring'
    url = require 'url'

    if req.originalUrl?
      params = qs.parse url.parse(req.originalUrl).query
    else
      params = {}

    files = yield _readdir "#{@dir}/temp/"+req.user.id+"/image"

    if files.length

      arr = []
      qs = []

      yield _mkdirp "#{@dir}/images"

      for f in files

        #console.log 'fileupload.coffee EXTENSION', f.split('.').pop()
        hash = _randomHash().substr 0,10
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
      photos = []
      user_uploads = {}
      avatars = []

      for o in arr
        photos.push(
          {
            hash: o.hash
            account: req.user.id
            type: 'image'
            name: o.name
            dir: o.ndir
            width: o.owidth
            height: o.oheight
            url: Feel.static.F @site.name, "user_data/images/" + o.original
          }
          {
            hash: o.hash+'low'
            account: req.user.id
            type: 'image'
            name: o.name
            dir: o.ndir
            width: o.lwidth
            height: o.lheight
            url: Feel.static.F @site.name, "user_data/images/" + o.low
          }
          {
            hash: o.hash+'high'
            account: req.user.id
            type: 'image'
            name: o.name
            dir: o.ndir
            width: o.hwidth
            height: o.hheight
            url: Feel.static.F @site.name, "user_data/images/" + o.high
          }
        )
        accountsDb = yield db.get 'accounts'
        persons =  yield _invoke personsDb.find({account:req?.user?.id}), 'toArray'
        person = persons[0] ? {}
        user_photos = person.photos ? []
        user_uploads = person.uploaded
        avatars.push o.hash


        if !user_photos?
          user_photos = [o.hash]
          yield _invoke personsDb, 'update', {account: req.user.id}, {$set:{photos : user_photos} }, {upsert: true}
        else
          yield _invoke personsDb, 'update', {account: req.user.id}, {$push:{photos : o.hash} }, {upsert: true}

        if !user_uploads?
          user_uploads = {}
        user_uploads[o.hash] = {
          type : 'image'
          original : o.hash
          low : o.hash+'low'
          high : o.hash+'high'
          original_url : Feel.static.F @site.name, "user_data/images/" + o.original
          low_url : Feel.static.F @site.name, "user_data/images/" + o.low
          high_url : Feel.static.F @site.name, "user_data/images/" + o.high
        }

      if photos.length
        yield _invoke uploadedDb, 'insert',     photos
        yield _invoke personsDb, 'update', {account: req.user.id}, {$set:{uploaded : user_uploads} }, {upsert: true}
        if params.avatar == 'true'
          yield _invoke personsDb, 'update', {account: req.user.id}, {$push:{avatar : {$each: avatars}} }, {upsert: true}

    yield @site.form.flush ['person'],req,res
    res.setHeader 'content-type','application/json'
    avatar = yield _invoke personsDb.find({account: req.user.id}, {avatar:1}), 'toArray'
    avatar = avatar[0].avatar

    if avatar? and avatar.length
      avatar = avatar[avatar.length-1]
      el = yield _invoke uploadedDb.find({hash:avatar+'high'}), 'toArray'
      el = el[0]
      res.end JSON.stringify {
        url : el.url
        width : el.width
        height : el.height
        uploaded : photos
      }
    else
      res.end JSON.stringify {uploaded: photos}
 
  parseImage : (o)=>
    qs = []
    qs.push _resize
      srcPath : o.tdir+o.name
      dstPath : o.ndir+o.high
      width   : 720
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
    yield _fs_copy o.tdir+o.name,o.ndir+o.original
    #console.log o.tdir+o.name,o.ndir+o.original
    yield _fs_remove(o.tdir+o.name)
    #yield _rename o.tdir+o.name,o.ndir+o.original
    qs.push _identify o.ndir+o.original
    [sl,sh,so] = yield Q.all qs
    o.owidth  = so.width
    o.oheight = so.height
    o.hwidth  = sh.width
    o.hheight = sh.height
    o.lwidth  = sl.width
    o.lheight = sl.height

module.exports = FileUpload



###
  uploaded :
    {
      hash: 'hashxxx'
      name : 'asfasf'
      dir : 'asfas/asfasf/asf'
      account : 'asd'
      type: 'image'
      width: 1920
      height: 1200
      url: 'afaf/asfasf/asfasf/aasf.jpg'
      low : {
        width: 200
        height: 125
        url: 'afaf/asfasf/asfasf/aasflow.jpg'
      }
      high; {
        width: 720
        height: 450
        url: 'afaf/asfasf/asfasf/aasfhigh.jpg'
      }
    }

    {
      hash : 'hashxxx'
      account : 'asd'
      type : 'image'
      path  : ''
    }
    {
      hash : 'hashxxxlow'
      account : 'asd'
      type : 'image'
      path  : ''
    }
  persons
    {
      avatar : 'hashxxx'
      photos : ['hashxxx','hashxxx2']
      uploaded : {
        'hashxxx' : {
          type : 'image'
          original : 'hashxxx'
          low : 'hashxxxlow'
          high : 'hashxxxhigh'
          original_url : '/file/hashxxx/hashxxx.jpg'
        }
      }
    }



###

