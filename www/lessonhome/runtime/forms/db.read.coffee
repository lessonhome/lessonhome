

@read = ($,fields=$.base.fields)=>
  @dbs = {}
  for f in fields
    dbname = $.base.dbname f
    bname  = $.base.toBName f
    @dbs[dbname] ?= []
    @dbs[dbname].push {}[bname] = 1
  find = account:$.user.id
  qs = []
  for db,arr of @dbs
    qs.push @getObjFromDb $,db,find,arr
  qs = yield Q.all qs
   
  console.log qs


@getObjFromDb = ($,bname,find,fields)=>
  db = yield $.db.get bname
  cursor = db.find(find,fields).limit(1)
  obj = yield _invoke cursor,'nextObject'
  cursor.close()
  return obj
