
@check = (f)=>
  errs = []
  # short
  if f.duration.length < 1
    errs.push "short_duration"
  # long
  if f.duration.length > 3
    errs.push "long_duration"
  # empty
  if f.duration.length == 0
    errs.push "empty_duration"
  if f.course.length == 0
    errs.push "empty_course"
  #if f.qualification.length == 0
  #  errs.push "empty_qualification"
  if f.group_learning.length == 0
    errs.push "empty_group_learning"
  active = false
  for val in f.categories_of_students
    console.log 'val :'
    console.log val
    if val
      active = true
  if !active
    errs.push "empty_categories_of_students"
  active = false
  for val in f.place
    if val
      active = true
  if !active
    errs.push "empty_place"
  return errs


