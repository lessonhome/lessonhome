
@checkPassword = (f)=>
  errs = []
  # compare
  if f.new != f.confirm
    errs.push "passwords_do_not_match"
  return errs
