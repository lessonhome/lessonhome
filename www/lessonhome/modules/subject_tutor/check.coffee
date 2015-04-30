
@check = (data)=>
  errs = []
  for i,subject of data.subjects_val
    # short
    if subject.duration.length < 1
      errs.push "short_duration":i
    # long
    if subject.duration.length > 100
      errs.push "long_duration":i
    # empty
    if subject.duration.length == 0
      errs.push "empty_duration":i
    if subject.course.length == 0
      errs.push "empty_course":i
    #if f.qualification.length == 0
    #  errs.push "empty_qualification"
    if subject.group_learning.length == 0
      errs.push "empty_group_learning":i
    active = false
    ###
    for val in subject.categories_of_students
      console.log 'val :'
      console.log val
      if val
        active = true
    if !active
      errs.push "empty_categories_of_students":i
    active = false
    for val in subject.place
      if val
        active = true
    if !active
      errs.push "empty_place":i
    ###
  return errs

