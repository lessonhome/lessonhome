


@handler = ($, data)->

  db = yield Main.service 'db'
  accountsDb = yield db.get 'accounts'

  accounts = yield _invoke accountsDb.find({'login': data.login}),'toArray'

  return {status:'failed'} unless accounts[0]?

  try
    yield $.register.passwordRestore data
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.form.flush '*',$.req,$.res

  return {status:'success'}
