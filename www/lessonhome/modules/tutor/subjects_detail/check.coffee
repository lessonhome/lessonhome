
@check = (f)=>
  errs = []
  # short
  if f.duration.length < 3
    errs.push "short_duration"
  # long
  if f.duration.length > 100
    errs.push "long_duration"
  # empty
  if f.duration.length == 0
    errs.push "empty_duration"
  if f.course.length == 0
    errs.push "empty_course"
  if f.qualification.length == 0
    errs.push "empty_qualification"
  if f.group_learning.length == 0
    errs.push "empty_group_learning"
  return errs


