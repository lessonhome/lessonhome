


@handler = ($, data)->

  data.ref = $.req.headers.referer

  try
    yield $.register.newPassword data
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.form.flush '*',$.req,$.res

  return {status:'success'}