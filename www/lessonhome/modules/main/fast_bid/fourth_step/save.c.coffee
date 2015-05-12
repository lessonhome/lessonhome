
#check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = []
  #errs = check.check data

  if errs.length
    return {status:'failed',errs:errs}

  age = []
  age.push data.age_slider.left
  age.push data.age_slider.right

  requirements_for_tutor = {}
  requirements_for_tutor.status = data.status
  requirements_for_tutor.experience = data.experience
  requirements_for_tutor.sex = data.sex
  requirements_for_tutor.age = age

  db= yield $.db.get 'pupil'
  yield _invoke db, 'update',{account:$.user.id},{$set:{'subjects.0.requirements_for_tutor':requirements_for_tutor}},{upsert:true}

  yield $.form.flush ['pupil'],$.req,$.res
  return {status:'success'}


