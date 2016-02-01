

words   = "qwertyuioplkjhgfdsazxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM0123456789"
kwords  = {}
coffee = require 'coffee-script'
UrlDataFunctions = require('../client/urlDataFunctions').UrlDataFunctions


class UrlData
  constructor : ->
    Wrap @
    for w,i in words
      kwords[w] = i

    @path = _path.resolve process.cwd()+"/www/lessonhome"
    @forms  = {}
    @fforms = {}
    @files = {}
    @const = {}
    @udata = new UrlDataFunctions
  init : =>
    @Feel = yield Main.service 'feel'
    yield @readConsts()
    @hostname = require('os').hostname()
    try
      @json = require "#{@path}/static/urldata/#{@hostname}.json"
      @json = JSON.parse JSON.stringify @json
    catch e
      @json = {}
    files = yield _readdir "#{@path}/runtime/urldata"
    for f in files
      continue unless m = f.match(/(.*)\.coffee$/)
      @fforms[m[1]] = require "#{@path}/runtime/urldata/#{f}"

    for fname,form of @fforms
      @forms[fname] = {}
      @forms[fname].U2D = Wrap new form.U2D if form.U2D?
      @forms[fname].D2U = Wrap new form.D2U if form.D2U?
    @json.shorts ?= {}
    @json.forms  ?= {}
    for fname,form of @forms
      @json.forms[fname] ?= {}
      for key,foo of form.D2U
        continue unless m = key.match /^\$(.*)$/
        res = yield foo {}
        res.cookie ?= false
        throw new Error "need type in field #{m[1]} in urlform #{fname}" unless res.type
        @json.forms[fname][m[1]] ?= yield @next()
        unless res.default?
          switch res.type
            when 'int'
              res.default = undefined
            when 'string'
              res.default = ''
            when 'bool'
              res.default = false
            when 'obj'
              res.default = {}
        @json.shorts[@json.forms[fname][m[1]]] = {
          form  : fname
          field : m[1]
          type  : res.type
          cookie : res.cookie
          default : res.default
        }
        @json.shorts[@json.forms[fname][m[1]]][key] ?= val for key,val of res
    yield _writeFile "#{@path}/static/urldata/#{@hostname}.json", JSON.stringify @json,4,4
    @jsonstring = JSON.stringify @json
    yield @genFiles()
    yield @udata.init @json,@forms
    #@udata.d2u({mainFilter:{price:{left:10}}}).then(function(u){console.log('a',u);}).catch(function(e){console.error(e)})
  getFFile  : (fname)=> @files[fname] ? {}
  getFFiles : (fname)=> @files
  getJsonString : => @jsonstring
  genFiles : =>
    for fname of @forms
      @files[fname] =
        src: coffee._compileFile "#{@path}/runtime/urldata/#{fname}.coffee"
    for fname,file of @files
      @files[fname].src =  "(function(){"+(yield file.src)+"}).call(_FEEL_that);"
      @files[fname].hash = _shash @files[fname].src
  readConsts : => do Q.async =>
    global.Feel ?= {}
    global.Feel.const ?= (name)=> @const[name]
    @const = {}
    readed = yield _readdirp
      root : 'www/lessonhome/const'
      fileFilter  : '*.coffee'
    files = for file in readed.files then file.path
    w8for = for file,i in files
      @const[file.replace(/\.coffee$/,'')] = require process.cwd()+'/www/lessonhome/const/'+file
    yield Q.all w8for
  next : (str)=>
    make = false
    make = true unless str?
    @json.last ?= ''
    str ?= @json.last
    if str == ''
      str = 'q'
      @json.last = str if make
      return str
    w = str.substr -1
    w = words[kwords[w]+1]
    if w
      str = (str.substr 0,str.length-1)+w
      @json.last = str if make
      return str
    n = yield @next str.substr 0,str.length-1
    n+='q'
    @json.last = n if make
    return n
  d2u : => @udata.d2u arguments...
  u2d : => @udata.u2d arguments...
  d2o : => @udata.d2o arguments...
  filter : (obj,field,value=true)=>
    string = false
    if typeof obj == 'string'
      obj = yield @toObject obj
      string = true
    ret = {}
    for key,val of obj
      ret[key] = val if @json?.shorts?[key]?[field]==value
    return @objectTo ret if string
    return ret
  objectTo : (obj)=>
    obj = {} unless obj && typeof obj=='object'
    ret = []
    ret.push [key,val] for key,val of obj
    ret.sort (a,b)-> a?[0] < b?[0]
    str = ''
    for r in ret
      continue unless r[0]
      str += '&' if str
      str += r[0]
      str += "="+r[1] if r[1]?
    return str
  toObject : (url)=>
    url = '' unless typeof url == 'string'
    url = url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    url = url.split '&'
    ret = {}
    for u in url
      u = u?.split? '=' ? []
      ret[u[0]]=u[1] if u[0]?
    return ret
  filterHash : (o={},field='filter')=>
    if typeof o == 'object'
      url = yield @d2u o
    else
      url = o
    return (yield @filter "blablabla?"+url,field) ? ''
 




module.exports = UrlData

