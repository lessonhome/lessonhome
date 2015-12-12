@atLeastAll = (func) ->
  result = {
    correct : false
    message : 'error'
  }
  return {
  some : (data) ->
    if func(data) is true then result.correct = true
    return true
  wait : (message) ->
    if message? then result.message = message
    return -> result
  }

@isTrue = (data) -> return if data is true then true else false
@isSelected = (data) -> return if data.selected is true then true else false
@isFill = (data) -> return if data isnt '' then true else false
@isString = (data) -> return if typeof(data) isnt 'string' then 'not_string' else true
@isInt = (data) -> return if data isnt '' and isNaN(+data) then 'not_int' else true

@stud = @atLeastAll @isTrue
@place = @atLeastAll @isSelected
@pr = @atLeastAll @isFill

@required = (data) -> return unless data then 'empty_field' else true
@tag = (data) -> return if (data.length > 285) then 'long_tag' else true
@comments = (data) -> return if (data.length > 30200) then 'long_comments' else true
@price = (data) -> return if data > 99999 then 'so_expensive' else true
@group_count = (data) -> return if data is '' then 'select_group' else true
@isNormalTags = (data) =>

  return 'not_tags' if not data.length?
  if typeof(data) is 'object'
    return 'to_many_tags' if data.length > 50
    for tag in data
      return 'not_tags' if typeof(tag) isnt 'string'
      err = @tag tag
      return err if err isnt true
  else if typeof(data) is 'string'
    return @tag data
  return true

@time_prices = {
  one_hour : [@pr.some, @isInt, @price]
  two_hour : [@pr.some, @isInt, @price]
  tree_hour : [@pr.some, @isInt, @price]
  prices : [@pr.wait("not_fill_price")]
}

@group = {
  price : [@isInt, @price]
  groups : [@isString ,@group_count]
}

@rules = {
  name : [@required, @isString]
  pre_school : [@stud.some]
  junior_school : [@stud.some]
  medium_school : [@stud.some]
  high_school : [@stud.some]
  student : [@stud.some]
  adult : [@stud.some]
  students : [@stud.wait('not_select_stud')]
  course : [@isNormalTags]
  place_tutor : [@place.some, @isSelected, @time_prices]
  place_pupil : [@place.some, @isSelected, @time_prices]
  place_remote : [@place.some, @isSelected, @time_prices]
  group_learning : [@isSelected, @group]
  places : [@place.wait('not_select_place')]
  comments : [@isString, @comments]
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
  for key, result of wait
    if result.correct is false
      errors.correct = false
      errors[key] = result.message
    result.correct = false   # reset
  return errors

@check = (data) =>
  names = []
  errors = {correct: true, empty: "empty_subjects"}
  for key, subject of data.subjects_val
    delete errors['empty'] if errors['empty']?
    error = @check_data subject
    if subject.name isnt ''
      sub_name = subject.name.toLowerCase()
      if names.length == 0
        names.push sub_name
      else
        for name in names
          if name is sub_name
            error.correct = false if error.correct
            error.name = "match_name"
            break
          else names.push sub_name
    if not error.correct
      errors[key] = error
      errors.correct = false if errors.correct
  errors["correct"] = false if errors["empty"]?
  return errors
