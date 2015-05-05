

class DbRead
  read : ($,fields=$.form.fields)=>
    @dbs = {}
    for f in fields
      dbname = $.form.dbname  f
      bname  = $.form.toBName f
      @dbs[dbname] ?= {}
      @dbs[dbname][bname] = 1
    find = account:$.find.account
    qs = []
    for db,arr of @dbs
      qs.push @getObjFromDb $,db,find,arr
    qs = yield Q.all qs
    obj = {}
    i = 0
    for db of @dbs
      obj[db] = qs[i]
      i++
    data = {}
    for db,o of obj
      for key,val of o
        fname = $.form.toFName(db,key)
        data[fname] = val if fname
    return data

  getObjFromDb : ($,bname,find,fields)=>
    db = yield $.db.get bname
    console.log bname,find,fields
    cursor = db.find(find,fields).limit(1)
    obj = yield _invoke cursor,'nextObject'
    cursor.close()
    return obj

module.exports = DbRead
