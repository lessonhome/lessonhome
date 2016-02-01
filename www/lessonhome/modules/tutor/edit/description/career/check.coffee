
@check = (f)=>
  errs = []
  # short
  for w,index in f.work
    if 0 < w.place.length < 3
      errs.push "short_place":index
    if 0 < w.post.length < 3
      errs.push "short_post":index
    # empty
    #if w.place.length == 0
    #  errs.push "empty_place":index
    #if w.post.length == 0
    #  errs.push "empty_post":index
  if f.experience.length == 0
    errs.push "empty_exp"
  return errs



