
check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = check.check data
  return {status:"failed",errs:["access_failed"]} unless $.user.tutor
  if errs?.length
    return {status:'failed',errs:errs}

  subjects_db = {}
  for i,subject in data.subjects_val
    subjects_db[i] = {}
    #subjects_db[i].name = subject.subject_tag
    subjects_db[i].description ?= []
    subjects_db[i].description.push subject.comments
    subjects_db[i].tags ?= []
    subjects_db[i].tags.push subject.course
    if subject.pre_school then subjects_db[i].tags.push "school:0"
    if subject.junior_school then subjects_db[i].tags.push "school:1"
    if subject.medium_school then subjects_db[i].tags.push "school:2"
    if subject.high_school then subjects_db[i].tags.push "school:3"
    if subject.student then subjects_db[i].tags.push "student"
    if subject.adult then subjects_db[i].tags.push "adult"
    price_range = []
    price_range.push subject.price_from
    price_range.push subject.price_till
    subjects_db[i].price = {}
    subjects_db[i].price.range = price_range
    subjects_db[i].price.duration = subject.duration
    subjects_db[i].place ?= []
    if subject.place_tutor then subjects_db[i].place.push "tutor"
    if subject.place_pupil then subjects_db[i].place.push "pupil"
    if subject.place_remote then subjects_db[i].place.push "remote"
    if subject.place_cafe then subjects_db[i].place.push "other"
    subjects_db[i].groups = [description:subject.group_learning]

  db= yield $.db.get 'tutor'
  yield _invoke db, 'update',{account:$.user.id},{$set:{subjects:subjects_db}},{upsert:true}
  yield $.status 'tutor_prereg_3', true

  return {status:'success'}
