
#pass.match /^\w+$/

@check = (login,pass,check_box)=>
  login_pattern = /^[a-zA-Z](.[a-zA-Z0-9_-]*)$/
  if login.length < 4
    return err: "short_login"

  if !login_pattern.test(login)
    return err: "bad_login"

  if pass.length < 5
    return err: "short_password"

  if !check_box
    return err: "select_agree_checkbox"
  return

