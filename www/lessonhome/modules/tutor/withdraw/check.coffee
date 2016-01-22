validAmount = (num) ->
  num = parseFloat(num)
  return !isNaN(num) and num >= 0

validDate = (date) -> return !isNaN new Date(date)

@check = (data)->
  errs = []

  unless data.value
    errs.push('empty')
  else
    errs.push('wrong amount') unless validAmount(data.value)

  errs.push('invalid date') unless validDate(data.date)
  errs.push('future date') if data.date > new Date
  errs.push('type not exist') unless data.type

  return errs

@validTrans = (transactions) ->
  for t in transactions
    return false unless t.value? and t.type? and validAmount(t.value) and validDate(t.date)
    switch t.type
      when 'fill', 'pay' then undefined
      else
        return false

  return true