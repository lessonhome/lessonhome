check = require './check'
@handler = ($, data) =>
  data = check.takeData(data)
  errs = check.check data
  return {errs, status: 'failed'} if errs.length
  jobs = yield Main.service 'jobs'
  console.log r = yield jobs.solve 'saveBid', $, data
  return r
