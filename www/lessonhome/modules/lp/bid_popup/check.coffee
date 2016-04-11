

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
  linked : data.linked
  subjects : data.subjects
  gender: data.gender
  name : data.name
  phone : data.phone
  metro: data.metro
  status: data.status
  prices: data.prices
  comment : data.comment

@check  = (data) =>
  filter = Feel.const('filter')
  metro = Feel.const('metro')
  status = filter.obj_status
  metro = metro.for_select
  prices = filter.price

  errs = []
  #  data = @takeData(data)

  if data.phone?.length
    errs.push 'wrong_phone' unless 7 <= data.phone.replace(/\D/g, '').length <= 13
  else
    errs.push 'empty_phone'

  if hasProp data.status
    for own key of data.status
      unless status.hasOwnProperty(key)
        errs.push('wrong_status')
        break

  if data.prices?.length
    prices = getExist prices
    for price in data.prices when !prices[price]?
        errs.push 'wrong_price'
        break

  if hasProp data.metro
    for own key of data.metro
      s = key.split(':')
      unless metro[s[0]]?.stations[s[1]]?
        errs.push 'wrong_metro'
        break

  if exist = getExist data.subjects
    for own key, vv of filter.subjects
      for v in vv
        delete exist[v] if exist[v]
    errs.push 'wrong_subj' if hasProp exist


  return errs





