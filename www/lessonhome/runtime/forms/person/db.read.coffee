

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

    data = {}
    for db,o of obj
      if db == 'uploaded'
        data.uploaded = o
      else
        for key,val of o
          fname = $.form.toFName(db,key)
          data[fname] = val if fname
    return data

  getObjFromDb : ($,bname,find,fields)=>
    db = yield $.db.get bname
    cursor = db.find(find,fields)
    obj = yield _invoke cursor,'toArray'
    cursor.close()
    if obj.length == 1
      return obj[0]
    else
      _obj = {}
      for item in obj
        _obj[item.hash] = item
    return _obj

module.exports = DbRead
