
check = require("./check")

status =
  'Студент':'student'
  'Преподаватель школы':'school_teacher'
  'Преподаватель ВУЗа':'university_teacher'
  'Частный преподаватель':'private_teacher'
  'Носитель языка':'native_speaker'


@handler = ($,data)=>
  console.log data
  errs = check.check data
  return {status:"failed",errs:["access_failed"]} unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  month = yield @convertMonthToNumber data.month
  birthday = new Date(data.year,month,data.day)
  console.log birthday,data.year,month,data.day
  db= yield $.db.get 'persons'
  console.log data.status
  yield _invoke db, 'update',{account:$.user.id},{$set:{first_name:data.first_name, middle_name:data.middle_name,last_name:data.last_name, sex:data.sex , birthday:birthday }},{upsert:true}


  #status = yield @convertStatus data.status
  db= yield $.db.get 'tutor'
  yield _invoke db, 'update',{account:$.user.id},{$set:{status:(status[data?.status] ? "other")}},{upsert:true}
  yield $.status 'tutor_prereg_1',true
  yield $.form.flush ['tutor','person','account'],$.req,$.res
  return {status:'success'}

@convertMonthToNumber= (month_str)=>
  switch month_str
    when 'январь'
      return 0
    when 'февраль'
      return 1
    when 'март'
      return 2
    when 'апрель'
      return 3
    when 'май'
      return 4
    when 'июнь'
      return 5
    when 'июль'
      return 6
    when 'август'
      return 7
    when 'сентябрь'
      return 8
    when 'октябрь'
      return 9
    when 'ноябрь'
      return 10
    when 'декабрь'
      return 11

