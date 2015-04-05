
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