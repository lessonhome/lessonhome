
base    = require './base'
_fields  = {}
for key,val of base
  for f in val
    _fields[f] = key
db = {}
for b of base
  db[b] 

@read = ($,obj={},fields=Object.keys(_fields))=>
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
