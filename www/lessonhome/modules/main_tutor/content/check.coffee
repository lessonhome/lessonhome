
#pass.match /^\w+$/

@check = (login,pass,check_box)=>
  login_pattern = /^[a-zA-Z](.[a-zA-Z0-9_-]*)$/


  if login.length == 0
    return err: "empty_login_form"

  if login.length < 4
    return err: "short_login"

  if !login_pattern.test(login)
    return err: "bad_login"

  if pass.length == 0
    return err: "empty_password_form"

  if pass.length < 5
    return err: "short_password"

  if !check_box
    return err: "select_agree_checkbox"
  return

