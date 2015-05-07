

class Data
  constructor : ->
    Wrap @
    @form = {}
    @data  = {}
    @flushs = {}
  init : =>
    @db = yield Main.service 'db'
    
      
  get : (fname,find,fields)=>
    @log find
    fhash= yield @findtohash find
    hash = _shash fname+fhash
    @log fhash,hash
    return @returnData fname,find,fields,hash,@data[hash] if @data[hash]
    data = yield @loadData fname,find,fields,hash,fhash
    return @returnData fname,find,fields,hash,data
  loadData : (fname,find,fields,hash,fhash)=>
    yield @loadForm fname unless @form[fname]?
    $ = {}
    $.find = find
    $.form = @form[fname]
    $.db = @db
    obj = yield @form[fname].dbread.read $,fields
    data = {}
    data.data = obj
    data.fdata = {}
    data.fdata[key] = val for key,val of data.data
    qs = []
    if $.form.d2f? then for key,val of $.form.d2f
      if (m=key.match(/^\$(.*)$/)) && (typeof val == 'function')
        do (m,key)=>
          qs.push $.form.d2f[key](data.data).then (v)=>
            data.fdata[m[1]] = v
            return
    yield Q.all qs
    data.vdata = {}
    data.vdata[key] = val for key,val of data.fdata
    qs = []
    if $.form.f2v? then for key,val of $.form.f2v
      if (m=key.match(/^\$(.*)$/)) && (typeof val == 'function')
        do (m,key)=>
          qs.push $.form.f2v[key](data.fdata).then (v)=>
            data.vdata[m[1]] = v
            return
    yield Q.all qs
    console.log data.data,data.fdata,data.vdata
    data.form = @form[fname]
    data.hash = hash
    @data[hash] = data
    @flushs[fhash] ?= []
    @flushs[fhash].push [@data,hash]
    return data
  findtohash : (find)=>
    @log find
    keys = Object.keys(find).sort()
    o = {}
    for k in keys
      o[k] = find[k]
    @log o
    return _shash JSON.stringify o
  returnData : (fname,find,fields,hash,data=@data[hash])=>
    fields ?= Object.keys data.vdata
    ret = {}
    ret[f] = data.vdata[f] for f in fields
    return ret
  flush : (find,dbname)=>
    fhash = yield @findtohash find
    if @flushs?[fhash]?
      for o in @flushs[fhash]
        delete o[0][o[1]]
    delete @flushs[fhash]
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
      form.f['db.read'] = require process.cwd()+"/www/lessonhome/runtime/forms/db.read.coffee"
    if files.convert
      form.f.convert = require process.cwd()+"/#{form.dir}/convert.coffee"
      if form.f.convert?.F2V?
        form.f2v = Wrap new form.f.convert.F2V
      if form.f.convert?.V2F?
        form.v2f = Wrap new form.f.convert.V2F
      if form.f.convert?.F2B?
        form.F2B = Wrap new form.f.convert.F2B
      if form.f.convert?.B2F?
        form.b2f = Wrap new form.f.convert.B2F
    form.dbread = Wrap new form.f['db.read']
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
