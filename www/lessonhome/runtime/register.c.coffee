


@handler = ($,data)->
  data.type = 'tutor'
  try
    console.log 'register.c',$.user
    yield $.register.newType $.user,$.session,data
  catch e
    return {status:'failed: '+e.message}
  return {status:'success'}



