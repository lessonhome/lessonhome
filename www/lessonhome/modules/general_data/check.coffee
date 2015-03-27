

@check = (name,val)=>
  switch name
    when 'first_name'
      if val.length < 3
        return err:'Слишком короткое имя'




