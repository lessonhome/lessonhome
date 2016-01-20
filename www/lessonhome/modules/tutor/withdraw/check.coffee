validAmount = (num) ->
  num = parseFloat(num)
  return isNaN(num) || num < 0

@check = (data)->
  errs = []

  unless data.value
    errs.push('empty')
  else
    errs.push('wrong amount') if validAmount(data.value)

  errs.push('invalid date') if isNaN(data.date)
  errs.push('future date') if data.date > new Date
  errs.push('type not exist') unless data.type

  return errs

@valid_trans = (transactions) ->
  for t in transactions
    return false unless t.value? and t.type? and validAmount(t.value)
  return true