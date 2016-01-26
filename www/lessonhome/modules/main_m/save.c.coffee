check = require './check'
@handler = ($, data) =>
  try
    data = check.takeData(data)
    errs = check.check data
    return {errs, status: 'failed'} if errs.length
    jobs = yield Main.service 'jobs'
    data['subject'] = data.subjects[0] if data.subjects?.length
    return yield jobs.solve 'saveBid', $.user, data
  catch errs
    return {status: 'failed', err: 'internal_error'}