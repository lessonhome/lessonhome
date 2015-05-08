


class Form
  constructor : ->
    Wrap @
    @form = {}
  init : =>
    @formnames = []
    formnames = yield _readdir "www/lessonhome/runtime/forms"
    for f in formnames
      @formnames.push f unless f.match /\./
    @service = yield Main.service 'data'
  get : (fname,req,res,fields)=>
    yield @loadForm fname unless @form[fname]
    find = yield @form[fname].find.get req,res
    @service.get fname,find,fields
  loadForm : (fname)=>
    data = yield _readdir "www/lessonhome/runtime/forms/#{fname}"
    form = {}
    files = {}
    files[f] = true for f in data
    if files['find.coffee']
      form.find = require process.cwd()+"/www/lessonhome/runtime/forms/#{fname}/find"
    else
      form.find = require process.cwd()+"/www/lessonhome/runtime/forms/find"
    form.find = Wrap new form.find
    @form[fname] = form
  flush : (data,req,res)=>
    if data == '*'
      data = @formnames
    if (typeof data == 'string') || (!data?.length>0)
      data = [data]
    qs = []
    for d in data
      do (d)=> qs.push do Q.async =>
        if typeof d == 'string'
          yield @loadForm d unless @form[d]
          fl = yield @form[d].find.get req,res
          return @service.flush fl,d
        return @service.flush d
    yield Q.all qs
        

module.exports = Form



