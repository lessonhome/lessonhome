@form = [
  'name'
  'phone'
  'linked'
  'id'
  'comment'
  'comments'
  'gender'
  'experience'
  'place'
  [
    'calendar'
    ['11','12','13','21','22','23','31','32','33','41','42','43','51','52', '53','61','62','63', '71', '72', '73']
  ]
  [
    'status'
    [
      'high_school_teacher'
      'native_speaker'
      'school_teacher'
      'student'
    ]
  ]
  [
    'price'
    ['left','right']
  ]
  [
    'duration'
    ['left','right']
  ]
#  'subject_comment'
  'subject'
  'email'
#  'phone_comment'
#  'comments'

]

@takeData = (data, form = @form) =>
  result = {}
  for key in form
    if typeof key is 'string' and data[key]? then result[key] = data[key]
    else if typeof key is 'object' and data[key[0]]? then result[key[0]] = @takeData data[key[0]], key[1]
  return result

@isBool = (data) -> return if typeof(data) isnt 'boolean' then "not_bool" else true
@boolAll = (data) =>
  for key, value of data
    return 'wrong_type' if @isBool(value) isnt true
  return true

@isString = (data) -> return if typeof(data) isnt 'string' then 'not_string' else true
@isInt = (data) -> return if data isnt '' and isNaN(parseInt data) then 'not_int' else true
@required = (data) ->
  return 'empty_field' if data is undefined || data is ''
  return true
@correctName = (data) ->
  if data is '' then return true
  reg = /^[_a-zA-Z0-9а-яА-ЯёЁ ]{1,35}$/
  return if reg.test(data) then true else 'wrong_name'
@isPhone = (data) ->
  if data is '' then return true
  if 6 <= data.replace(/\D/g, '').length <= 11 then return true
  return 'wrong_phone'
@isEmail = (data) ->
  if data is '' then return true
  reg = /^\w+@\w+\.\w+$/
  return if reg.test(data) then true else 'wrong_email'


@left_right = {
  left : [@isInt]
  right : [@isInt]
}



@rules = {
#  subject_comment: [@isString]
#  phone_comment: [@isString]
  gender: [@isString]
  experience: [@isString]
  price: [@left_right]
  duration: [@left_right]
  subject: [@isString]
  email: [@isString, @isEmail]
  phone: [@required, @isString, @isPhone]
  name: [@isString, @correctName]
  status: [@boolAll]
  linked: [@boolAll]
  calendar: [@boolAll]
  place: [@boolAll]
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
