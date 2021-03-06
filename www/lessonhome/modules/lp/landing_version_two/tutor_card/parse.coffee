status =
  student : 'студент'
  school_teacher : 'Преподаватель школы'
  university_teacher : 'Преподаватель ВУЗа'
  private_teacher  :'Частный преподаватель'
  native_speaker : 'Носитель языка'

metro = Feel.const('metro')
metro_stations = metro.stations
metro_lines = metro.lines
const_mess = {
  all: 'Вся Москва'
  remote: 'Skype'
}

@parse = (value)->
  value ?= {}

  ret = {}

  #index
  ret.index = value.index
  ret.link = '/tutor?'+yield  Feel.udata.d2u 'tutorProfile',{index:value.index}
  ret.link_comment = '/tutor?'+yield  Feel.udata.d2u 'tutorProfile',{inset:1, index:value.index}
  value.link = ret.link
  value.link_comment = ret.link_comment
  #name
  ret.name = "#{value?.name?.first ? ""} #{value?.name?.middle ? ""}"

  #subject
  ret.subject = ""
  value.subjects ?= {}
  directions = {}
  for key,val of value.subjects
    ret.subject += ', ' if ret.subject
    ret.subject += key?.capitalizeFirstLetter?()
    for i,course of (val.course ? {})
      directions[course] = true
  ret.directions = Object.keys(directions).join(', ')
  sj = ret.subject
  reg_comma = /\s*,\s*/
  sj_array = sj.split(reg_comma)
  
  ret.subject = sj_array

  #exp
  value.experience ?= ""
  exp = value.experience ? ""
  exp += " года" if exp && !exp?.match? /\s/
  #ret.experience = "#{status[value?.status] ? 'Репетитор'}, опыт #{exp}"
  ret.experience = "#{status[value?.status] ? 'Репетитор'}"

  #cours = value.subjects
  #for key of cours
    #console.log cours[key]

  #about
  value.about ?= ""
  ret.about = value.about || ''

  #location
  value.location ?= {}
  l = value.location
  cA = (str="",val,rep=', ')->
    return str unless val
    val = ""+val
    val = val.replace /^\s+/,''
    val = val.replace /\s+$/,''
    return str unless val
    unless str
      str += val
    else
      str += rep+val

  ls1 = ""
  ls1 = cA ls1,l.city
  ls2 = ""
  ls2 = cA ls2,l.street
  ls2 = cA ls2,l.house
  ls2 = cA ls2,l.building
  ls3 = ""
#  ls3 += "м. #{l.metro}" if l.metro
  ls = ""
  ls = cA ls,ls3,'<br><br>'
  ls = cA ls,ls1,'<br>'
  ret.location = ls
  ret.street_loc  = l.street
  ret.area_loc    = l.area

  #price
  value.left_price ?= 0
  ret.left_price = value.left_price

  #photo src
  value.photos ?= {}
  ret.photos = value.photos[Object.keys(value.photos).length-1]?.lurl ? ""
  #metro

  ret.metro_tutors = do ->
    for_show = {type: 'all', data: []}
    where = value.check_out_the_areas ? {}
    where = value.yandex?.metro ? where
    
    regexp = /vsya_moskva/i
    exist = {}
    for own i, place of where
      return for_show if regexp.test _diff.prepare(place)
      place = prepareStr(place)
      for p in place.split(reg_comma) when p = getGuessedMetro(p)

        unless exist[p.metro]?
          exist[p.metro] = true
          for_show.data.push(p)

    exist = null

    if !value.place?.pupil and !value.place?.tutor and value.place?.remote
      for_show.type = 'remote'
      return for_show

    for_show.type = 'metro'
    return for_show if for_show.data.length

    for where in ['area', 'street']
      return for_show if for_show.data = value.location?[for_show.type = where]

    for_show.type = 'all'
    return for_show

  if const_mess[type = ret.metro_tutors.type]?
    ret.metro_tutors.data = const_mess[type]

  #reviews
  
  ret.reviews ?= {}
  reviwersWord = ['отзыв','отзыва','отзывов']
  rewNum = Object.keys(value.reviews ? {}).length
  rewText = rewNum + ' ' + getNumEnding(rewNum, reviwersWord)

  ret.reviews = rewText
  fs = value.filter_stations ? {}
  value.filter_stations = for key,val of fs then val
  ret.metro_tutors ?= {}
  ret.metro_tutors.type ?= 'metro'
  ret.metro_tutors.data ?= []
  value.filter_stations = []
  if value.yandex?.all_moscow
    value.filter_stations.push
      metro :'Вся Москва'
      color : "#FFF"
      key : 'Вся Москва'
  if value.filter_stations
    unless ret.metro_tutors.type == 'metro'
      ret.metro_tutors.data = [{metro:ret.metro_tutors.data,color:"#FFF"}]
      ret.metro_tutors.type = 'metro'
    o = {}
    arr = []
    for f in [value.filter_stations...,ret.metro_tutors.data...]
      continue if o[f.metro]
      arr.push f
      o[f.metro] = true
    ret.metro_tutors.data = arr
  return ret

getGuessedMetro = (str) ->
  return null unless str
  m = metro_stations[key = _diff.metroPrepare(str)]

  unless m
    for w in str.toLowerCase().split(/\s+/g) when metro.means[w]?
      m= metro_stations[key = metro.means[w]]
      break

  if m?.name? and m.lines?[0]?
    return {
      metro : m.name
      color : metro_lines[m.lines[0]].color
      key
    }

  return null

prepareStr = (str) -> str.replace(/^\s+|\s+$/gm, '').replace(/\s+/g, ' ')

emptyObject = (obj={})->
  for own i of obj
    return false
  return true

getNumEnding = (iNumber, aEndings) ->
  sEnding = {}
  i = 0
  iNumber = iNumber % 100
  if (iNumber>=11 && iNumber<=19)
    sEnding=aEndings[2]
  else
    i = iNumber % 10
    switch i
      when 1 then sEnding = aEndings[0]
      when 2 then sEnding = aEndings[1]
      when 3 then sEnding = aEndings[1]
      when 4 then sEnding = aEndings[1]
      else sEnding = aEndings[2]
  return sEnding
