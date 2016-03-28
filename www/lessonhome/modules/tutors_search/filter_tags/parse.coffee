metro = Feel.const('metro')
stations = metro.stations
lines = metro.lines
getParam = (names) ->
  if names and stations[names[1]]? and lines[names[0]]?
    return {
      name : stations[names[1]].name
      color : lines[names[0]].color
    }
  return null

getNames = (name = '') ->
  name = name.split ':'
  return name if name.length > 1
  return null

@parse = (data) =>

  if data?.filter?.metro?
    metro = {}

    if data.filter.metro.length?
      for m in data.filter.metro
        metro[m] = getParam getNames m
    else
      for own key, m of data.filter.metro
        metro[m] = getParam getNames m

    data.metro_tags = metro

  return data
