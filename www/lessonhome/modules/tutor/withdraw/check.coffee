@check = (data)->
  return 'empty' unless data?
  data = parseFloat(data)
  return 'amount_not_num' if isNaN(data) or data < 0
  return null