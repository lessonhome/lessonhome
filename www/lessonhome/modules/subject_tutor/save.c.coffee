
#check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  #errs = check.check errs,data

  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  tags = []

  tags.push data.list_course
  if data.pre_school    then tags.push 'school:0'
  if data.junior_school then tags.push 'school:1'
  if data.medium_school then tags.push 'school:2'
  if data.high_school   then tags.push 'school:3'
  if data.student       then tags.push 'student'
  if data.adult         then tags.push 'adult'

  range = []
  range.push data.price_from
  range.push data.price_till

  place = []
  if data.place_tutor  then place.push 'tutor'
  if data.place_pupil  then place.push 'pupil'
  if data.place_remote then place.push 'remote'
  if data.place_cafe   then place.push 'cafe'

  db= yield $.db.get 'tutor'
  yield _invoke db, 'update',{account:$.user.id},{$set:{subjects:{name:data.name, description:data.description, place:place, tags:tags, price: {duration:data.duration, range:range } }}},{upsert:true}
  ###
  return {status:'success'}

