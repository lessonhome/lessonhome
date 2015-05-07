
@checkPassword = (f)=>
  errs = []
  # compare
  if f.new != f.confirm
    errs.push "passwords_do_not_match"
  return errs


#pass.match /^\w+$/

@check = (login,pass)=>
  login_pattern = /^[a-zA-Z](.[a-zA-Z0-9_-]*)$/

  if login.length == 0
    return err: "empty_login_form"

  if login.length < 7
    return err: "bad_login"

  unless @checkEmail login
    unless login = @checkPhone login
      return err: "bad_login"


  if pass.length == 0
    return err: "empty_password_form"

  if pass.length < 5
    return err: "short_password"

  return {login:login}
@checkEmail = (login)=>
  re = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
  re.test login
@checkPhone = (login)=>
  return null unless login.match /^[-\+\d\(\)\s]+$/
  p = login.replace /\D/g,""
  return null if p.length > 11
  if p.length == 11
    if p.match /^[7|8]/
      p = p.substr 1
    else return null
  if p.length == 7 || p.length == 10
    return p
  return null

