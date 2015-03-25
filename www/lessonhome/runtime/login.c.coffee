


@handler = ($,data)->
  try
    obj = yield $.register.login $.user,$.session,data
    $.cookie.set 'sessoin',obj.session.hash,{overwrite:true}
  catch e
    return 'failed: '+e.message
  return 'success'



