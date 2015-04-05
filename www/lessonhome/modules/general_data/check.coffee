
@check = (f)=>
  errs = []
  # short
  if 0 < f.first_name.length < 3
    errs.push "short_first_name"
  if 0 < f.last_name.length < 3
    errs.push "short_last_name"
  if 0 < f.middle_name.length < 3
    errs.push "short_patronymic"
  # empty
  if f.first_name.length == 0
    errs.push "empty_first_name"
  if f.last_name.length == 0
    errs.push "empty_last_name"
  if f.patronymic.length == 0
    errs.push "empty_patronymic"
  if (f.day.length==0) || (f.month.length==0) || (f.year.length==0)
    errs.push "empty_date"
  if f.status.length == 0
    errs.push "empty_status"
  return errs


