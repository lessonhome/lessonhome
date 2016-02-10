

getExist = (arr) ->
  return null unless arr?
  exist = {}
  exist[sub] = true for sub in arr
  return exist

hasProp = (obj) ->
  return false unless obj?
  for own key of obj then return true
  return false

@takeData = (data = {}) =>
  subjects : data.subjects
  course : data.course
  name : data.name
  phone : data.phone
  comment : data.comment
  linked : data.linked

@check  = (data) =>
  filter = Feel.const('filter')
  errs = []
#  data = @takeData(data)

  if data.phone?.length
    errs.push 'wrong_phone' unless 7 <= data.phone.replace(/\D/g, '').length <= 13
  else
    errs.push 'empty_phone'

  if exist = getExist data.subjects
    for own key, vv of filter.subjects
      for v in vv
        delete exist[v] if exist[v]
    errs.push 'wrong_subj' if hasProp exist

  if exist = getExist data.course
    for v in filter.course
      delete exist[v] if exist[v]
    errs.push 'wrong_course' if hasProp exist

  return errs





