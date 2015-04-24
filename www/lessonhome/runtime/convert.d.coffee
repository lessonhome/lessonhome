
@convertNumberToMonth =(month)=>
  switch month
    when 0
      return 'январь'
    when 1
      return 'февраль'
    when 2
      return 'март'
    when 3
      return 'апрель'
    when 4
      return 'май'
    when 5
      return 'июнь'
    when 6
      return 'июль'
    when 7
      return 'август'
    when 8
      return 'сентябрь'
    when 9
      return 'октябрь'
    when 10
      return 'ноябрь'
    when 11
      return 'декабрь'


@convertStatusToRus =(status)=>
  switch status
    when 'schoolboy'
      return 'школьник'
    when 'student'
      return 'студент'
    when 'graduate'
      return  'аспирант/выпускник'
    when 'phd'
      return 'кандидат наук'
    when 'phd2'
      return 'доктор наук'

# convert ISO to date (example: ISO to 12.2.2002)

@convertToDate =(birthday)=>
  day   = birthday.getDate?()
  month = birthday.getMonth?() + 1
  year  = birthday.getFullYear?()
  return day+'.'+month+'.'+year

@convertTutorStatusToRus =(status)=>
  switch status
    when 'schoolboy'
      return 'школьник'
    when 'student'
      return 'студент'
    when 'graduate'
      return 'аспирант/выпускник'
    when 'phd'
      return 'кандидат наук'
    when 'phd2'
      return 'доктор наук'

###

@getWork =(work)=>
  return work.pop().name if work?.pop().name?
  console.log 'start'
  console.log work
  console.log 'end'
  return 'заполнить'


###


@getLinkToFill =(href)=>
  return "<a href=#{href}>заполнить</a>"


@tutorTagToCheckbox = (tags,checkbox)=>
  return false unless tags?.length? && checkbox?
  for val in tags
    if val == checkbox then return true
  return false
