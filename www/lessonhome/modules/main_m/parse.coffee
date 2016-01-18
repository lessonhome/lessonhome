getExist = (obj) ->
  result = {}
  if obj then for key, val of obj when obj.hasOwnProperty(key) then result[val] = true
  return result

@parse = (value) ->
  value.cou_exist = getExist value.course
  value.sub_exist = getExist value.subjects
  return value