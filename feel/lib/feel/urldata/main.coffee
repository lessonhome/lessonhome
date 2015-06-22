

words   = "qwertyuioplkjhgfdsazxcvbnmQWERTYUIOPLKJHGFDSAZXCVBNM0123456789"
kwords  = {}

class UrlData
  constructor : ->
    Wrap @
    for w,i in words
      kwords[w] = i

    @path = _path.resolve process.cwd()+"/www/lessonhome"
    @forms  = {}
    @fforms = {}
  init : =>
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
      for key of form.D2U
        continue unless m = key.match /^\$(.*)$/
        @json.forms[fname][m[1]] ?= yield @next()
        @json.shorts[@json.forms[fname][m[1]]] = {
          form  : fname
          field : m[1]
        }
    yield _writeFile "#{@path}/static/urldata/#{@hostname}.json", JSON.stringify @json,4,4
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


    

module.exports = UrlData

