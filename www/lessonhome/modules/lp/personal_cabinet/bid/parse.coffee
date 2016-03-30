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
  bid.metro.station = ''
  
  for a of value.bid.metro
    metro_line = a.split(':')[0]
    metro_station = a.split(':')[1]
    bid.metro.color = metro.for_select[metro_line].color
    bid.metro.station += ', ' if bid.metro.station
    bid.metro.station += 'м. ' + metro.for_select[metro_line].stations[metro_station]

  #subjects
  bid.subjects = ''
  for key of value.bid.subjects
    bid.subjects += ', ' if bid.subjects
    bid.subjects += value.bid.subjects[key]?.capitalizeFirstLetter?()

  #prices
  bid.prices = ''
  for key of value.bid.prices
    bid.prices += ',<br />' if bid.prices
    bid.prices += value.bid.prices[key]
  
  #gender
  bid.gender = ''
  switch value.bid.gender
    when '' then bid.gender = ''
    when 'male' then bid.gender = 'Мужской'
    when 'female' then bid.gender = 'Женский'

  #create date
  bid.create_date = ''
  d = new Date(value.bid.time)
  bid.create_date = d.format "dd.mm.yyyy HH:MM"
  
  #tutors status
  bid.tutor_status = ''
  for key of value.bid.status
    bid.tutor_status += ', ' if bid.tutor_status
    bid.tutor_status += status[key]?.capitalizeFirstLetter?()

  #bid index
  bid.number_id = ''
  bid.number_id = value.bid.index
  return bid
