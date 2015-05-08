


@handler = ($,data)->
  data.type = 'tutor'
  try
    yield $.register.newType $.user,$.session,data
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.form.flush '*',$.req,$.res
  return {status:'success'}



