
@check = (subjects)=>
  errs = []
  i = 0
  for subject in subjects.val
    # short
    if subject.duration.length < 1
      errs[i].push "short_duration"
    # long
    if subject.duration.length > 3
      errs[i].push "long_duration"
    # empty
    if subject.duration.length == 0
      errs[i].push "empty_duration"
    if subject.course.length == 0
      errs[i].push "empty_course"
    #if f.qualification.length == 0
    #  errs.push "empty_qualification"
    if subject.group_learning.length == 0
      errs[i].push "empty_group_learning"
    active = false
    for val in subject.categories_of_students
      console.log 'val :'
      console.log val
      if val
        active = true
    if !active
      errs[i].push "empty_categories_of_students"
    active = false
    for val in subject.place
      if val
        active = true
    if !active
      errs[i].push "empty_place"
    i++
  return errs

