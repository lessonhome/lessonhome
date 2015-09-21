
check = require("./check")

typetoteach = {"school:0":'pre_school','school:1':'junior_school','school:2':'medium_school','school:3':'high_school','student':'student','adult':'adult'}

@handler = ($,data)=>
#  errs = check.check data
  console.log data
  return {status:"failed",errs:["access_failed"]} unless $.user.tutor
  console.log data.subjects_val.subjects
  if errs?.length
    return {status:'failed',errs:errs}
  subjects_db = {}
  tags = {}
  for i,subject of data.subjects_val
    subject ?= {}
    subjects_db[i] = {}
    subjects_db[i].name = subject?.name
    subjects_db[i].description = subject.comments
    subject.course = {0:subject.course} if typeof subject.course == 'string'
    subject.course = {} unless subject?.course || (typeof subject.course == 'object')
    subjects_db[i].tags ?= {}
    for key,val of subject.course
      subjects_db[i].tags[val] = 1.0
    subjects_db[i].course = subject.course
    for key,val of typetoteach
      subjects_db[i].tags[key] = if subject[val] then true else false
    subjects_db[i].tags[subject.name] = true
#    if subject.pre_school then subjects_db[i].tags.push "school:0"
#    if subject.junior_school then subjects_db[i].tags.push "school:1"
#    if subject.medium_school then subjects_db[i].tags.push "school:2"
#    if subject.high_school then subjects_db[i].tags.push "school:3"
#    if subject.student then subjects_db[i].tags.push "student"
#    if subject.adult then subjects_db[i].tags.push "adult"
#    price_range = []
#    price_range.push subject.price_from
#    price_range.push subject.price_till
#    subjects_db[i].price = {}
#    subjects_db[i].price.range = price_range
#    subjects_db[i].price.duration = {left:+subject?.duration?.left,right:+subject?.duration?.right}
    subjects_db[i].place ?= []
    if subject.place_tutor.selected then subjects_db[i].place.push "tutor"
    if subject.place_pupil.selected then subjects_db[i].place.push "pupil"
    if subject.place_remote.selected then subjects_db[i].place.push "remote"
    subjects_db[i].place_prices = {}
    for place in subjects_db[i].place
      subjects_db[i].place_prices[place] = [
        subject['place_' + place]?.one_hour
        subject['place_' + place]?.two_hour
        subject['place_' + place]?.tree_hour
      ]
#    if subject.place_cafe.selected then subjects_db[i].place.push "other"
    if subject.group_learning.selected
      subjects_db[i].groups = [{
        description: subject.group_learning.groups
        price: subject.group_learning.price
      }]
    for key,val of subjects_db[i].tags
      tags[key] = val
  db= yield $.db.get 'tutor'
  dataToSet = {}
  for key,val of tags
    dataToSet['tags.'+key] = val if key
  dataToSet.subjects = subjects_db
  yield _invoke db, 'update',{account:$.user.id},{$set:dataToSet},{upsert:true}
  console.log dataToSet
  yield $.status 'tutor_prereg_3', true
  yield $.form.flush ['tutor','account'],$.req,$.res
  return {status:'success'}
