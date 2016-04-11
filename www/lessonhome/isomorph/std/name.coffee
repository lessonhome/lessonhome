
@prepare = (str = '') ->
#  str = _string.prepare(str)
  return '' unless str
  str = str.toLowerCase().split(/\s+/g)
  str = ( ( s[0].toUpperCase() + s.substr(1) ) for s, i in str when s[0]?)
  return str.join(' ')

@check = (str) ->
#  return false unless _string.check str
  str = @prepare(str)
  return true
