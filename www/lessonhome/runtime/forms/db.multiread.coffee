

class DbRead
  read : ($,fields=$.form.fields)=>
    @dbs = {}
    for f in fields
      dbname = $.form.dbname  f
      bname  = $.form.toBName f
      @dbs[dbname] ?= {}
      @dbs[dbname][bname] = 1
    find = $.find
    qs = []
    for db,arr of @dbs
      qs.push @getObjFromDb $,db,find,arr
    qs = yield Q.all qs
    obj = {}
    i = 0
    for db of @dbs
      obj[db] = qs[i]
      i++
    data = []
    for db,arr of obj
      for o in arr
        dt = {}
        for key,val of o
          fname = $.form.toFName(db,key)
          dt[fname] = val if fname
        data.push dt
    return data

  getObjFromDb : ($,bname,find,fields)=>
    db = yield $.db.get bname
    cursor = db.find(find,fields)
    obj = yield _invoke cursor,'toArray'
    @log obj
    cursor.close()
    return obj

module.exports = DbRead
