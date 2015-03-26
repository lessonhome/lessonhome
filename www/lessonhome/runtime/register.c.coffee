


@handler = ($,data)->
  data.type = 'tutor'
  try
    console.log 'register.c',$.user
    yield $.register.newType $.user,$.session,data
  catch err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}
  return {status:'success'}



