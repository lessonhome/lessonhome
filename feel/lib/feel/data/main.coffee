

class Data
  constructor : ->
    Wrap @
    @form = {}
    @data  = {}
  init : =>
    @db = yield Main.service 'db'
    
      
  get : (fname,find,fields)=>
    hash = _shash fname+JSON.stringify find
    return @returnData fname,find,fields,hash if @data[hash]
    data = yield @loadData fname,find,fields,hash
    return @returnData fname,find,fields,hash,data
  loadData : (fname,find,fields,hash)=>
    yield @loadForm fname unless @form[fname]?
    $ = {}
    $.find = find
    $.form = @form[fname]
    $.db = @db
    obj = yield @form[fname].dbread.read $,fields
    data = {}
    data.data = obj
    data.form = @form[fname]
    data.hash = hash
    @data[hash] = data
    return data

  returnData : (fname,find,fields,hash,data=@data[hash])=>
    return data.data

  loadForm : (fname)=>
    form = {}
    form.name = fname
    form.dir  = "www/lessonhome/runtime/forms/#{fname}"
    readed = yield _readdir form.dir
    files = {}
    for f in readed
      if m = f.match /^(.*)\.coffee$/
        files[m[1]] = true
    form.f = {}
    form.f.base = require process.cwd()+"/#{form.dir}/base.coffee"
    if files['db.read']
      form.f['db.read'] = require process.cwd()+"/#{form.dir}/db.read.coffee"
    else
      form.f['db.read'] = require process.cwd()+"/db.read.coffee"
    form.dbread = new form.f['db.read']
    Wrap form.dbread
    form.fields   = []
    form.bfields  = {}
    form.ffields  = {}
    for bname,arr of form.f.base
      form.bfields[bname] ?= {}
      for bf in arr
        f = bf
        if typeof bf != 'string'
          f = Object.keys(bf)[0]
          bf = bf[f]
          [f,bf] = [bf,f]
        form.fields.push f
        form.bfields[bname][bf]  = f
        form.ffields[f]   = [bf,bname]
    form.dbname = (f)=> @form[fname].ffields[f][1]
    form.toBName= (f)=> @form[fname].ffields[f][0]
    form.toFName= (b,f)=> @form[fname].bfields[b][f]
    @form[fname] = form
module.exports = Data
