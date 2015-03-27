
#pass.match /^\w+$/

@check = (login,pass)=>
  login_pattern = /^[a-zA-Z](.[a-zA-Z0-9_-]*)$/
  if login.length < 4
    return err: "short_login"
  else
    if login_pattern.test(login)
      return err: "bad_login"
    else
      if @loginExists login
        return err: "login_exists"

  if pass.length < 5
    return err: "short_password"

  return


@loginExists = (login)=>
  $.register.login_exists

###
login:
  - length
  - characters
  - exists
password:
  - length
  - characters
###
