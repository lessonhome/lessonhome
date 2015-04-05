@check = (f)=>
  errs = []
  if 0 < f.mobile_phone.length < 3
    errs.push "wrong_mobile"
  if 0 < f.extra_phone.length < 3
    errs.push "wrong_extra_phone"
  if 0 < f.post.length < 3
    errs.push "wrong_post"
  if 0 < f.skype.length < 3
    errs.push "wrong_skype"
  if 0 < f.site.length < 3
    errs.push "wrong_site"
  return errs