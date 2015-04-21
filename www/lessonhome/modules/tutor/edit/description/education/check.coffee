
@check = (f)=>
  errs = []
  console.log f
  # empty
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
  if f.status.length == 0
    errs.push "empty_status"
  if f.day.length==0 && f.month.length==0 && f.year.length==0
    errs.push "empty_date"
  # not correct
  if f.day*1<1 && f.day*1>32
    errs.push "bad_day"
  if f.year*1<1930 && f.day*1>1997
    errs.push "bad_year"
  return errs



