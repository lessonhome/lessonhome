status =
  student : 'студент'
  school_teacher : 'Преподаватель школы'
  university_teacher : 'Преподаватель ВУЗа'
  private_teacher  :'Частный преподаватель'
  native_speaker : 'Носитель языка'

metro_map = Feel.const('metro').metro_map

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

  #exp
  value.experience ?= ""
  exp = value.experience ? ""
  exp += " года" if exp && !exp?.match? /\s/
  ret.experience = "#{status[value?.status] ? 'Репетитор'}, опыт #{exp}"

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

  split_station       = _location.metro.split(', ')
  this_station = []
  users_metro = {}

  split_station.forEach (item, i, split_station) =>
    this_station = _diff.metroPrepare(item)
    if metro_map[this_station] != undefined
      users_metro[this_station] = {
        metro  :  metro_map[this_station].name
        color : metro_map[this_station].color
      }

  if emptyObject(users_metro) == true
    ret.metro_tutors = users_metro
  return ret

emptyObject = (obj) ->
  for i in obj
    if Obj.hasOwnProperty(i)
      return false
  return true
