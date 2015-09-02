


@check = (login)=>
  unless login
    return err:"empty_login"
  unless @checkEmail login
    unless login = @checkPhone login
      return err:"bad_login"
  return login:login
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




