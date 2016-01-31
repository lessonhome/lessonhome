
@isFill = (data) -> return if data isnt '' then true else false
@isString = (data) -> return if typeof(data) isnt 'string' then 'not_string' else true
@isInt = (data) -> return if data isnt '' and isNaN(+data) then 'not_int' else true
@required = (data) -> return unless data then 'empty_field' else true
#@atLeastAll = (func) ->
#  result = {
#    correct : false
#    message : 'error'
#  }
#  return {
#  some : (data) ->
#    if func(data) is true then result.correct = true
#    return true
#  wait : (message) ->
#    if message? then result.message = message
#    return -> result
#  }

@period = {
  start : [@isFill, @isInt]
  end : [@isFill, @isInt]
}

@rules = {
  name : [@required, @isString]
  faculty : [@isFill, @isString]
  country :[@isFill, @isString]
  city :[@isFill, @isString]
  chair :[@isFill, @isString]
  qualification :[@isFill, @isString]
  comment :[@isFill, @isString]
  period : [@period]
}

@check_data = (data, rules = @rules) =>
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
        _errors = @check_data data[key], rule
        if _errors.correct is false
          errors[key] = _errors
          errors.correct = false
#  for key, result of wait
#    if result.correct is false
#      errors.correct = false
#      errors[key] = result.message
#    result.correct = false   # reset
  return errors

@check = (data) =>
  exist = {}
  errors = correct: true
  for v, i in data
    error = @check_data v
    if error.correct is false
      errors.correct = false
      errors[i] = error
  return errors

