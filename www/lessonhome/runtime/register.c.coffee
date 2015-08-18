


@handler = ($,data)->
  data.type = 'tutor'
  try
    yield $.register.newType $.user,$.session,data
  catch err
    console.log 'err',err
    err.err ?= 'internal_error'
    return {status:'failed',err:err.err}
  yield $.form.flush '*',$.req,$.res

  mail = yield Main.service 'mail'

  console.log 'login', $.user

  #if $.user.login?.match? '@'
  mail.send(
    'example.html'
    'arsereb@gmail.com'
    'Тест'
    {
      name: 'test'
      login: 'test'
    }
  ).done()

  return {status:'success'}



