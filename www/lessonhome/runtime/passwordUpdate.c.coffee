
# data:{login,password,newpassword}

@handler = ($,data)->
  if data.password.match /\%/
    data.password = unescape data.password
    data.newpassword = unescape data.newpassword
  else
    data.password = _LZString.decompressFromBase64 data.password
    data.newpassword = _LZString.decompressFromBase64 data.newpassword
 
  data.login ?= $.user.login
  try
    obj = yield $.register.passwordUpdate $.user,$.session,data
  catch err
    console.log err
    err.err     ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.updateUser()
  yield $.form.flush '*',$.req,$.res
  return {status:'success',session:obj.session.hash}


