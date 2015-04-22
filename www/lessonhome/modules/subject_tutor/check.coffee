
@check = (f)=>
  errs = []
  # empty
  if f.subject.length==0
    errs.push "empty_subject"
# empty