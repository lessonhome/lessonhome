@check = (f)=>
  console.log f
  errs = []
  #short
  if 0 < f.mobile_phone.length < 10
    errs.push "bad_mobile"
  if 0 < f.extra_phone.length < 10
    errs.push "bad_extra_phone"
  if 0 < f.post.length < 5
    errs.push "bad_post"
  if 0 < f.skype.length < 3
    errs.push "bad_skype"
  #empty
  #if f.mobile_phone.length == 0
  #  errs.push "empty_mobile"
  #if f.extra_phone.length == 0
  #  errs.push "empty_extra_phone"
  #if f.post.length == 0
  #  errs.push "empty_post"
  #if f.skype.length == 0
  #  errs.push "empty_skype"
  #if f.site.length == 0
  #  errs.push "empty_site"
  if f.country.length == 0
    errs.push "empty_country"
  if f.city.length == 0
    errs.push "empty_city"
  return errs