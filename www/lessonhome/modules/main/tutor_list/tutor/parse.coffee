status =
  student : 'студент'
  school_teacher : 'Преподаватель школы'
  university_teacher : 'Преподаватель ВУЗа'
  private_teacher  :'Частный преподаватель'
  native_speaker : 'Носитель языка'

#metro = Feel.const('metro').metro

@parse = (value)->
  console.log JSON.stringify value

  value ?= {}

  ret = {}

  #name
  value.name = "#{value?.name?.first ? ""} #{value?.name?.middle ? ""}"

  #subject
  value.subject = ""
  value.subjects ?= {}

  for key of value.subjects
    value.subject += ', ' if value.subject
    value.subject += key?.capitalizeFirstLetter?()

  #exp
  value.experience ?= ""
  exp = ""
  exp += " года" if exp && !exp?.match? /\s/
  value.experience = "#{status[value?.status] ? 'Репетитор'}, опыт #{exp}"

  #about
  value.about ?= ""
  value.about = value.about || ''

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
  ls3 += "м. #{l.metro}" if l.metro
  ls = ""
  ls = cA ls,ls3,'<br><br>'
  ls = cA ls,ls1,'<br>'
  value.location = ls

  #price
  value.left_price ?= 0
  value.left_price = value.left_price

  #photo src
  value.photos ?= {}
  value.photos = value.photos[Object.keys(value.photos).length-1].lurl

  ret.name = value.name
  ret.subject = value.subject
  ret.experience = value.experience
  ret.location = value.location
  ret.left_price = value.left_price
  ret.photos = value.photos
  ret.about = value.about

  return ret