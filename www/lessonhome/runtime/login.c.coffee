


@handler = ($,data)->
  try
    obj = yield $.register.login $.user,$.session,data
    $.cookie.set 'session'
    $.cookie.set 'session',obj.session.hash
  catch e
    return {status:'failed: '+e.message}
  return {status:'success',session:obj.session.hash}



