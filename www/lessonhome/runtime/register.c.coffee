


@handler = ($,data)->
  data.type = 'tutor'
  console.log 'handler'.red
  try
    console.log 'register.c',$.user
    yield $.register.newType $.user,$.session,data
    console.log 'register ok'.red
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}
  console.log 'end'
  return {status:'success'}



