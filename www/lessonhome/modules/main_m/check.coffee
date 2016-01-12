

getExist = (arr) ->
  exist = {}
  exist[sub] = true for sub in arr
  return exist

hasProp = (obj) ->
  for key of obj when obj.hasOwnProperty(key) then return true
  return false

@takeData = (data = {}) =>
  subject : data.subject
  course : data.course
  name : data.name
  phone : data.phone
  comment : data.comment

@check  = (data) =>
#  filter = Feel.const('filter')

  errs = []
  data = @takeData(data)

  if data.phone
    errs.push 'wrong_phone' unless 7 <= data.phone.replace(/\D/g, '').length <= 13
  else errs.push 'empty_phone'

#  exist = getExist data.subject
#  for key, vv of filter.subjects when filter.subjects.hasOwnProperty(key)
#    for v in vv
#      delete exist[v] if exist[v]
#  errs.push 'wrong_subj' if hasProp exist
#
#  exist = getExist data.course
#  for v in filter.course
#      delete exist[v] if exist[v]
#  errs.push 'wrong_course' if hasProp exist
  return errs





