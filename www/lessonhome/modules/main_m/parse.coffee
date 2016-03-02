subjects = Feel.const('filter').subjects
metro = Feel.const('metro')
lines = metro.for_select


getExist = (obj) ->
  result = {}
  if obj then for own key, val of obj then result[val] = true
  return result

@parse = (value) ->
  qs = []
  rects = [
    { s:'математика', i:'icon-subjec1'}
    { s:'физика', i:'icon-subjec2'}
    { s:'русский язык', i:'icon-subjec3'}
    { s:'английский язык', i:'icon-subjec4'}
    { s:'биология', i:'icon-subjec5'}
    { s:'химия', i:'icon-subjec6'}
    { s:'младшая школа', i:'icon-subjec7', n:'Начальные классы'}
    { s:null, i:'icon-subjec8'}
  ]

  qs = for r in rects then do (r)=> do Q.async =>
    r.l = {
      link: "/tutors_search?#{ yield Feel.udata.d2u 'tutorsFilter', {subjects: [r.s]} }"
    }
    r.l.text = r.s[0].toUpperCase() + r.s.slice(1) if r.s
  yield Q.all qs
  value.rects = rects
  value.metro_line = lines

  value.metr_exist = getExist value.metro
  value.sub_exist = getExist value.subjects
  return value
