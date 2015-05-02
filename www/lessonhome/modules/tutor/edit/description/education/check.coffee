
@check = (f)=>
  errs = []
  # empty
  ###
  if f.country.length == 0
    errs.push "empty_country"
  if f.city.length == 0
    errs.push "empty_city"
  if f.university.length == 0
    errs.push "empty_university"
  if f.faculty.length == 0
    errs.push "empty_faculty"
  if f.chair.length == 0
    errs.push "empty_chair"


  ###
  # not correct

  return errs



