
@prepare = (str = '') ->
#  str = _string.prepare(str)
  str = str.toLowerCase().split(' ')
  str = ( ( s[0].toUpperCase() + s.substr(1) ) for s, i in str)
  return str.join(' ')

@check = (str) ->
#  return false unless _string.check str
  str = @prepare(str)
  return true
