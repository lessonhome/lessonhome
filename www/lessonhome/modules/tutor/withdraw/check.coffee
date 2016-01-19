@check = (data)->
  errs = []

  unless data.value
    errs.push('empty')
  else
    f = parseFloat(data.value)
    errs.push('amount_not_num') if isNaN(f) or f < 0

  errs.push('wr_date') if isNaN(data.date)
  errs.push('future') if data.date > new Date
  errs.push('type_req') unless data.type

  return errs