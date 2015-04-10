
@check = (f)=>
  errs = []
  # short
  if 0 < f.first_name.length < 3
    errs.push "short_first_name"
  if 0 < f.last_name.length < 3
    errs.push "short_last_name"
  if 0 < f.middle_name.length < 3
    errs.push "short_middle_name"
  # empty
  if f.first_name.length == 0
    errs.push "empty_first_name"
  if f.last_name.length == 0
    errs.push "empty_last_name"
  if f.middle_name.length == 0
    errs.push "empty_middle_name"
  if f.day.length==0 && f.month.length==0 && f.year.length==0
    errs.push "empty_date"
  if f.status.length == 0
    errs.push "empty_status"
  if f.sex == 'unselect'
    errs.push "unselect sex"
  return errs
  # not correct
  if f.day*1<1 && f.day*1>32
    errs.push "bad_day"
  if f.year*1<1930 && f.day*1>1997
    errs.push "bad_year"


