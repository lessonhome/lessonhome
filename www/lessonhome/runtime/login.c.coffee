


@handler = ($,data)->
  try
    obj = yield $.register.login $.user,$.session,data
    $.cookie.set 'session'
    $.cookie.set 'session',obj.session.hash
  catch err
    err.err     ?= 'internal_error'
    return {status:'failed',err:err.err}
  return {status:'success',session:obj.session.hash}



