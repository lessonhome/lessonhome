
#@check = (data)=>
#  errs = []
#
#  if JSON.stringify(data).length > 32000
#    errs.push 'long_data'
#  else
#    if typeof(data.phone) is 'string'
#      phone = data.phone.replace(/[^\d]/g, '')
#      if 0 < phone.length < 10
#        errs.push 'wrong_phone'
#    else
#      errs.push 'wrong_phone'
#  return errs

#@isBool = (data) -> return if typeof(data) isnt 'boolean' then "not_bool" else true
#@isFill = (data) -> return if data isnt '' then true else false
@isString = (data) -> return if typeof(data) isnt 'string' then 'not_string' else true
#@isInt = (data) -> return if data isnt '' and isNaN(parseInt data) then 'not_int' else true
@required = (data) -> return if data is '' then 'empty_field' else true
@isLinked = (data) ->
  i = 0
  for a, value of data then i++
  if i is 0 then return 'empty'
  return true
@correctName = (data) ->
  if data is '' then return true
  reg = /^[_a-zA-Z0-9а-яА-ЯёЁ ]{1,15}$/
  return if reg.test(data) then true else 'wrong_name'
@isPhone = (data) ->
  if data is '' then return true
  if 0 < data.replace(/[^\d]/g, '').length <= 11 then return true
  return 'wrong_phone'
@isEmail = (data) ->
  if data is '' then return true
  reg = /^\w+@\w+\.\w+$/
  return if reg.test(data) then true else 'wrong_email'

#@status = {
#  high_school_teacher:[@isBool]
#  native_speaker:[@isBool]
#  school_teacher:[@isBool]
#  student:[@isBool]
#}

#@price = {
#  left : [@isInt]
#  right : [@isInt]
#}

#@duration = {
#  left : [@isInt]
#  right : [@isInt]
#}

@rules = {
  gender: [@isString]
  experience: [@isString]
#  status: [@status]
#  price: [@price]
#  duration: [@duration]
#  subject_comment: [@isString]
  subject: [@isString]
  email: [@isString, @isEmail]
#  phone_comment: [@isString]
  phone: [@required, @isString, @isPhone]
  name: [@isString, @correctName]
  linked: [@required, @isLinked]
}

@check = (data, rules = @rules) =>
  errors = {correct : true}
  wait = {}
  for key, elem of rules
    for rule in elem
      if typeof(rule) is 'function'
        result = rule data[key]
        if result is true then continue
        if result is false then break
        if typeof(result) is 'string'
          errors[key] = result
          errors.correct = false
          break
        if typeof(result) is 'object'
          wait[key] = result
      if typeof(rule) is 'object'
        _errors = @check data[key], rule
        if _errors.correct is false
          errors[key] = _errors
          errors.correct = false
  for key, result of wait
    if result.correct is false
      errors.correct = false
      errors[key] = result.message
    result.correct = false   # reset
  return errors