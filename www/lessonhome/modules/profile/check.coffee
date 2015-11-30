
@check = (f)=>
  phone = f.phone.replace(/^\+7/, '8').replace(/[^\d]/g, '')
  errs = []
  #if !f.agree_checkbox
    #errs.push "disagree_checkbox"
  #if 0 < f.name.length < 2
    #errs.push "short_name"
  if (f.phone.length > 0 and phone.length == 0) or 0 < phone.length < 10
    errs.push "short_phone"
  #if f.name.length == 0
    #errs.push "empty_name"
  if f.phone.length == 0
    errs.push "empty_phone"
  #if f.subject.length == 0
    #errs.push "empty_subject"
  return errs

