
@check = (f)=>
  errs = []
  # short
  if 0 < f.your_name.length < 3
    errs.push "short_your_name"
  # empty
  if f.your_name.length == 0
    errs.push "empty_your_name"
  if f.type == 'unselect'
    errs.push "empty_type"

  return errs
