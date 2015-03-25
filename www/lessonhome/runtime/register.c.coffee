


@handler = ($,data)->
  data.type = 'tutor'
  try
    console.log 'register.c',$.user
    yield $.register.newType $.user,$.session,data
  catch e
    return 'failed: '+e.message
  return 'success'



