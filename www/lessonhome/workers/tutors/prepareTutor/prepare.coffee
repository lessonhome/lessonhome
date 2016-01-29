_short_string = Main.isomorph 'std/short_string'
_phone = Main.isomorph 'std/phone'
_email = Main.isomorph 'std/email'



module.exports = ({person,account, tutor})->
  person ?= {}
  person.phone = (_phone.prepare(phone) for phone in (person.phone ? []) when phone.length)
  person.email = (_email.prepare(email) for email in (person.email ? []) when email.length)
  person[key] = _short_string.prepare(person[key]) for key in ['first_name', 'middle_name', 'last_name']

