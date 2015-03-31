
@check = (errs, f)=>
  if 0 < f.first_name.length < 3
    errs.push "short_first_name"
  if 0 < f.last_name.length < 3
    errs.push "short_last_name"
  if 0 < f.patronymic.length < 3
    errs.push "short_patronymic"
  if (f.day=="") && (f.month=="") && (f.year=="")
    errs.push "empty_date"
  return errs


