

@read = ($,fields=$.base.fields)=>
  @dbs = {}
  for f in fields
    dbname = $.base.dbname f
    bname  = $.base.toBName f
    @dbs[dbname] ?= []
    @dbs[dbname].push {}[bname] = 1



  b = {}
  for f in fields
    continue unless _fields[f]?
    (b[_fields[f]]?={})[f] = 1
  qs = []
  for bname,obj of b
    qs.push @getObjFromDb $,bname,obj
@getObjFromDb = ($,bname,obj)=>
  db = yield $.db.get bname
  _invoke db,

  dbp   = yield $.db.get 'persons'
  dbt   = yield $.db.get 'tutor'
