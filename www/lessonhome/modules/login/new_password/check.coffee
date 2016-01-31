


@check = (password)=>
  unless password
    return err:"empty_password"
  unless password?.length > 4
    return err:"short_password"