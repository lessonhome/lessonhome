
@check = (f)=>
  errs = []
  # short
  if 0 < f.place.length < 3
    errs.push "short_place"
  if 0 < f.post.length < 3
    errs.push "short_post"
  # empty
  if f.place.length == 0
    errs.push "empty_place"
  if f.post.length == 0
    errs.push "empty_post"
  if f.experience.length == 0
    errs.push "empty_exp"
  return errs



