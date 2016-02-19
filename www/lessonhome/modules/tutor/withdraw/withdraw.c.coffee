check = require('./check')
@handler = ($, data) =>
  job = yield Main.service 'jobs'

  try
    switch data.type
      when 'save'
        console.log data.data
        throw Error('Wrong arr of trans') unless check.validTrans data.data
        data = yield job.solve 'addTrans', {user: $.user, data: data.data}
        return {status: 'success', data}
      when 'del'
        {residue} = yield job.solve 'delTrans', {user: $.user, number: data.number}
        return {status: 'success', residue}

  catch errs
    console.error Exception errs
    return {status: 'failed', err: errs.message}
