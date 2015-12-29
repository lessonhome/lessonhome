@check = (data)->
  return 'empty' unless data?
  data = parseFloat(data)
  return 'wrong' if isNaN(data) or data < 300
  return null