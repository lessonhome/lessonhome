stations = Feel.const('metro').stations
@prepare = (metro = '') ->
#  metro = _short_string.prepare()

  if metro.length
    metro = metro.split(/\s*,\s*/g)
#    _new  = {}
#
#    for own key, s of stations
#      name = s.name.toLowerCase()
#      for m, i in metro
#        _new[i] = s.name if m.toLowerCase() == name
#
#    metro[i] = m for own i, m of _new
    return metro.join(', ')

@check = (metro = '') ->