subjects = Feel.const('filter').subjects
metro = Feel.const('metro')
stations = metro.stations
lines = metro.lines

getExist = (obj) ->
  result = {}
  if obj then for key, val of obj when obj.hasOwnProperty(key) then result[val] = true
  return result

@parse = (value) ->
  value.sub_link = {}

  for key, ss of subjects when subjects.hasOwnProperty(key)
    value.sub_link[key] = a = []
    for subject in ss
      a.push {
        text: subject[0].toUpperCase() + subject.slice(1)
        link: "/tutors_search?#{ yield Feel.udata.d2u 'tutorsFilter', {subjects: [subject]} }"
      }

  value.metro = {}
  for k, l of lines
    value.metro[k] = {name: l.name,color: l.color, stations: metro_s =  {}}
    for s_name in l.stations
      metro_s[s_name] = stations[s_name].name

  value.cou_exist = getExist value.course
  value.sub_exist = getExist value.subjects
  return value