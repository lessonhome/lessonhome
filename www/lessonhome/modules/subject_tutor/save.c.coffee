
check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  errs = check.check errs,data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  tags = []
  if data.pre_school    then tags.push 'school:0'
  if data.junior_school then tags.push 'school:1'
  if data.medium_school then tags.push 'school:2'
  if data.high_school   then tags.push 'school:3'
  if data.student       then tags.push 'student'
  if data.adult         then tags.push 'adult'


  db= yield $.db.get 'tutor'
  yield _invoke db, 'update',{account:$.user.id},{$set:{subjects:{name:data.subject, description:data.list_course, place:[data.place], tags:tags }}},{upsert:true}

  return {status:'success'}

    return {
      subject             : @subject.getValue()
      list_course         : @list_course.getValue()
      place               : @place.getValue()
      students_in_group   : @students_in_group.getValue()
      price               : @price.getValue()
      group_lessons_price : @group_lessons_price.getValue()
      pre_school    : @pre_school   .state
      junior_school : @junior_school.state
      medium_school : @medium_school.state
      high_school   : @high_school  .state
      student       : @student      .state
      adult         : @adult        .state
    }
