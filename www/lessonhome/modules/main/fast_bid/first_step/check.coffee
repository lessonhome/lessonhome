
@check = (f)=>
  errs = []
  # short
  #if 0 < f.name.length < 2
  #  errs.push "short_name"
  if 0 < f.phone.length < 10
    errs.push "short_phone"
  # empty
  #if f.name.length == 0
  #  errs.push "empty_name"
  if f.phone.length == 0
    errs.push "empty_phone"
  #if f.subject.length == 0
  #  errs.push "empty_subject"

  return errs
