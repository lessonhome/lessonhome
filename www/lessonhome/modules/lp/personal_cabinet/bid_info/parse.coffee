status =
  student : 'студент'
  school_teacher : 'Преподаватель школы'
  university_teacher : 'Преподаватель ВУЗа'
  private_teacher  :'Частный преподаватель'
  native_speaker : 'Носитель языка'

metro = Feel.const('metro')
metro_stations = metro.stations

@parse = (value)->
  value ?= {}

  bid = {}

  #comments
  bid.comment = ''
  bid.comment = value.bid.comment

  #location
  bid.metro = {}
  bid.metro = value.bid.metro

  #subjects
  bid.subjects = ''
  for key of value.bid.subjects
    bid.subjects += ', ' if bid.subjects
    bid.subjects += value.bid.subjects[key]?.capitalizeFirstLetter?()

  #prices
  bid.prices = ''
  for key of value.bid.prices
    bid.prices += ', ' if bid.prices
    bid.prices += value.bid.prices[key]
  
  #gender
  bid.gender = ''
  switch value.bid.gender
    when '' then bid.gender = ''
    when 'male' then bid.gender = 'Мужской'
    when 'female' then bid.gender = 'Женский'
  
  #tutors status
  bid.status = ''

  console.log value.bid
  console.log '-------------------------------------------------'.red
  console.log bid


  return bid
