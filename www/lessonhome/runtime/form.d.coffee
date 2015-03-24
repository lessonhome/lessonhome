



@get =(formname,property) ->
  find = {id:10,formname}
  db = yield @$db.get 'pupil-forms'
  values = yield _invoke db.find(find,{"#{property}":1}),'toArray'
  return values?[0]?[property]