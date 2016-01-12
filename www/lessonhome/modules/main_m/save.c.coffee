check = require './check'
@handler = ($, data) =>
  data = check.takeData(data)
  return check.check data