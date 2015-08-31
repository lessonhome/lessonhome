
# data:{login,password,newlogin}


@handler = ($,data)->

  return $.user.login if data.getLogin

  data.login ?= $.user.login
  try
    obj = yield $.register.loginUpdate $.user,$.session,data
  catch err
    err.err     ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.updateUser()
  yield $.form.flush '*',$.req,$.res
  return {status:'success',session:obj.session.hash}


