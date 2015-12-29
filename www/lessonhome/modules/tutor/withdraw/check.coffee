@check = (data)->
  return 'empty' unless data?
  data = parseFloat(data)
  return 'wrong' if isNaN(data) or data < 0
  return null