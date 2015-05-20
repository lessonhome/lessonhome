
check = require("./check")

@handler = ($,data)=>
  errs = check.check data
  return {status:"failed",errs:["access_failed"]} unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  tags = []
  tags.push data.course
  for val, key in data.categories_of_students
    console.log 'AAron'
    console.log val
    if val
      switch key
        when 0
          tags.push "school:0"
        when 1
          tags.push "school:1"
        when 2
          tags.push "school:2"
        when 3
          tags.push "school:3"
        when 4
          tags.push "student"
        when 5
          tags.push "adult"

  price_range = []
  price_range.push data.price_from
  price_range.push data.price_till

  place = []
  for val, key in data.place
    if val
      switch key
        when 0
          place.push "tutor"
        when 1
          place.push "pupil"
        when 2
          place.push "remote"
        when 3
          place.push "other"

  db= yield $.db.get 'tutor'
  yield _invoke db, 'update',{account:$.user.id},{$set:{subjects:{name:data.subject_tag, description:data.comments, tags:tags, price:[{range:price_range, duration:data.duration}],place:place, groups:[{description:data.group_learning}] }}},{upsert:true}
  yield $.form.flush ['tutor'],$.req,$.res
  return {status:'success'}


