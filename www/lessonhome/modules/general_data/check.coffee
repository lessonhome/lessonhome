

@check = (f)=>
  console.log f
  if 0 < f.first_name.length < 3
    return err:"short_first_name"
  if 0 < f.last_name.length < 3
    return err:"short_last_name"
  if 0 < f.patronymic.length < 3
    return err:"short_patronymic"


