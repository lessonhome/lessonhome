check = require('./check')
@handler = ($, data) =>
  try
    job = yield Main.service 'jobs'
    if err = check.check(data.value) then throw err

    switch data.type
      when 'pay'
        {status, bill} = yield job.solve 'withdraw', {user: $.user, amount: data.value}
        if status == 'success'
          return {status: 'success', bill}
      when 'fill'
        {status, bill} = yield job.solve 'refill', {user: $.user, amount: data.value}
        if status == 'success'
          return {status: 'success', bill}
      when 'del'
        {status, bill} = yield job.solve 'delTrans', {user: $.user, number: data.value}
        if status == 'success'
          return {status: 'success', residue}

  catch errs
    return {status: 'failed', err: errs.stack}
