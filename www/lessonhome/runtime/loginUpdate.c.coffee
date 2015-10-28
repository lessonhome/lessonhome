
# data:{login,password,newlogin}


@handler = ($,data)->
  return $.user.login if data.getLogin
  if data?.password?.match? /\%/
    data.password = unescape data.password
  else
    data.password = _LZString.decompressFromBase64 data.password

  data.login ?= $.user.login
  try
    obj = yield $.register.loginUpdate $.user,$.session,data
  catch err
    err.err     ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.updateUser()
  yield $.form.flush '*',$.req,$.res
  return {status:'success',session:obj.session.hash}


