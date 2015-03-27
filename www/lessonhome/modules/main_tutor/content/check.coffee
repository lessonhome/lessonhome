


@check = (login,pass)=>
  if pass.length < 6
    return err:"short_password"
  else if pass.match /^\w+$/
    return err:"easy_password"
  if login.length < 4
    return err:"short_login"

  return





