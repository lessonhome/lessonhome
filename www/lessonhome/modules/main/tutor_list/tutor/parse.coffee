status =
  student : 'студент'
  school_teacher : 'Преподаватель школы'
  university_teacher : 'Преподаватель ВУЗа'
  private_teacher  :'Частный преподаватель'
  native_speaker : 'Носитель языка'

metro = Feel.const('metro')
metro_stations = metro.stations
metro_lines = metro.lines

@parse = (value)->
  value ?= {}

  ret = {}

  #index
  ret.index = value.index
  ret.link = '/tutor_profile?'+yield  Feel.udata.d2u 'tutorProfile',{index:value.index}
  value.link = ret.link
  #name
  ret.name = "#{value?.name?.first ? ""} #{value?.name?.middle ? ""}"

  #subject
  ret.subject = ""
  value.subjects ?= {}

  for key of value.subjects
    ret.subject += ', ' if ret.subject
    ret.subject += key?.capitalizeFirstLetter?()

  sj = ret.subject
  re = /\s*,\s*/
  sj_array = sj.split(re)
  
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
  _location          = value.location
  _location.metro   ?= ""
  _location.area    ?= ""

  split_station       = _location.metro.split(',').map (a) -> a.trim()
  this_station = []
  users_metro = {}

  split_station.forEach (item, i, split_station) =>
    this_station = _diff.metroPrepare(item)

    unless metro_stations[this_station]?
      for w in item.toLowerCase().split ' '
        if metro.means[w]?
          this_station = metro.means[w]
          break

    if metro_stations[this_station]?
      users_metro[this_station] = {
        metro  :  metro_stations[this_station].name
        color : metro_lines[metro_stations[this_station].lines[0]].color
      }

  if emptyObject(users_metro) == true
    ret.metro_tutors = users_metro
  else
    ret.metro_tutors = {}
  
  #reviews
  
  ret.reviews ?= {}
  reviwersWord = ['отзыв','отзыва','отзывов']
  rewNum = Object.keys(value.reviews ? {}).length
  rewText = rewNum + ' ' + getNumEnding(rewNum, reviwersWord)

  ret.reviews = rewText

  return ret

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
