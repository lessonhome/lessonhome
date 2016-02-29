_name = Main.isomorph 'std/name'
_short_string = Main.isomorph 'std/short_string'
_phone = Main.isomorph 'std/phone'
_email = Main.isomorph 'std/email'



module.exports = ({person,account, tutor, uploaded})->
  person ?= {}
  account ?= {}
  tutor ?= {}
  uploaded?=[]

  person.phone = (_phone.prepare(phone) for phone in (person.phone ? []) when phone.length)
  person.email = (_email.prepare(email) for email in (person.email ? []) when email.length)
  person[key] = _name.prepare(person[key]) for key in ['first_name', 'middle_name', 'last_name'] when person[key]?

  places = []
  l = person.location ? {}
  places.push l.city if l.city
  places.push l.area if l.area
  places.push "метро "+l.metro if l.metro
  places.push l.metro if l.metro
  places.push "#{l.street} #{l.house || ""} #{l.building || ""}" if l.street
  for cata in tutor.check_out_the_areas ? []
    if cata.length > 40
      places.push cata.split(/\s+/)...
    else
      places.push cata
  for p,i in places
    places[i] = p.replace(/[^\wа-яё]+$/gmi).replace(/^[^\wа-яё]+/gmi)
  person.yandex = yield @jobs.solve 'yandexParsePlaces', places
  found = person.yandex?.areas?.length || person.yandex?.metro?.length
  joined = places.join ' '
  if !found || joined.match(/вся\s+москва/gmi)
    person.yandex.all_moscow = true
  
  return {person, account, tutor, uploaded}

