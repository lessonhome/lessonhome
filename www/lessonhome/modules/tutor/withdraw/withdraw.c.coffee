check = require('./check')
@handler = ($, data) =>
  try
    if err = check.check(data.value) then throw err
    job = yield Main.service 'jobs'
    {status, bill} = yield job.solve 'withdraw', {id_acc: $.user.id, amount: data.value}
    if status == 'success'
      return {status: 'success', bill}

  catch errs
    err = {status: 'failed'}
    if typeof(errs) == 'string'
      err['err'] =  errs
    else
      err['err'] = 'internal_error'
      console.log "ERROR: #{errs.stack}"
    return err
