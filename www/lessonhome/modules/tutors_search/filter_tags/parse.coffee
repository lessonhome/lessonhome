stations = Feel.const('metro').stations
FullName = (name,obj = stations) ->
  if name
    return obj[name].name
  return ''

getNameStation = (name) ->
  name = name.split ':'
  return name[1] if name.length > 1
  return ''

@parse = (data) =>

  if data?.filter?.metro?
    metro = {}

    if data.filter.metro.length?
      for m in data.filter.metro
        metro[m] = FullName getNameStation m
    else
      for key, m of data.filter.metro when data.filter.metro.hasOwnProperty(key)
        metro[m] = FullName getNameStation m

    data.metro_tags = metro

  return data
