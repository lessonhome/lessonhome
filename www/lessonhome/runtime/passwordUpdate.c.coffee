
# data:{login,password,newpassword}

@handler = ($,data)->

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


