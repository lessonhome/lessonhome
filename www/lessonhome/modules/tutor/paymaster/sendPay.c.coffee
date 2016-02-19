check = require('./check')
@handler = ($, data) =>
  try
    if err = check.check(data.value) then throw new Error(err)
    job = yield Main.service 'jobs'
    {status, url} = yield job.solve 'makeCheck', {user: $.user, amount: data.value}

    if status == 'success'
      return {status: 'success', get: url}

  catch errs
    console.error Exception errs
    return {status: 'failed', err: 'internal error'}
