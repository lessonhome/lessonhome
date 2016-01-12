metro = Feel.const('metro')
stations = metro.stations
lines = metro.lines

getInf = (obj) ->
  res = {
    fill: false
  }
  for key, val of obj when obj.hasOwnProperty(key)
    res.fill = true
    return res if typeof val is 'boolean'
    res['exist']?={}
    res.exist[val] = true if typeof val isnt 'object'
  return res


@parse = (data) ->

  data.sub_exist = getInf(data.filter.subjects).exist
  data.course_exist = getInf(data.filter.course).exist
  data.metro_exist = getInf(data.filter.metro).exist

  data.sh_price = getInf(data.filter.price).fill
  data.sh_status = getInf(data.filter.status).fill
  data.sh_metro = data.filter.metro[0]?

  data.metro = {}
  for k, l of lines
    data.metro[k] = {name: l.name,color: l.color, stations: metro_s =  {}}
    for s_name in l.stations
      metro_s[s_name] = stations[s_name].name

#  ready = metro.ready
#  stations = {}
#  lines = {}
#
#  colors = {
#    "Сокольническая линия": "#ED1B35"
#    "Замоскворецкая линия": "#44B85C"
#    "Арбатско-Покровская линия": "#0078BF"
#    "Филёвская линия": "#19C1F3"
#    "Кольцевая линия": "#894E35"
#    "Калужско-Рижская линия": "#F58631"
#    "Таганско-Краснопресненская линия": "#8E479C"
#    "Калининская линия": "#FFCB31"
#    "Серпуховско-Тимирязевская линия": "#A1A2A3"
#    "Люблинско-Дмитровская линия": "#B3D445"
#    "Каховская линия": "#79CDCD"
#    "Бутовская линия": "#ACBFE1"
#  }
#
#  means = {}
#  exist = {}
#
#  for a in ready
#    l = _diff.metroPrepare(a.line.replace(' линия', '')).slice(0,4)
#    s = []
#    lines[l] = { name: a.line, color: colors[a.line], stations: s}
#    for stat in a.stations
#      s_name = _diff.metroPrepare(stat)
#      a = stat.toLowerCase()
#      unless exist[a]
#        a = a.split(' ')
#
#        if a.length > 1
#          for word in a
#            means[word]?=[]
#            means[word].push s_name
#
#        exist[a] = true
#
#      s.push s_name
#      if stations[s_name]? then console.log stations[s_name].name, stat, s_name
#      stations[s_name]?= {name: stat, lines: []}
#      stations[s_name].lines.push l
#
#  for w of means
#    if means[w].length == 1
#      means[w] = means[w][0]
#    else
#      delete means[w]
#
#  console.log '@stations = ', JSON.stringify(stations)
#  console.log '@lines = ', JSON.stringify(lines)
##  console.log means
#  console.log '@means=', JSON.stringify(means)


  return data