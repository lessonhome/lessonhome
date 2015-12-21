



class PayMaster
  constructor : ->
    $W @
  init : =>
    @jobs = yield Main.service 'jobs'
    yield @jobs.listen 'pay',@pay
    yield @jobs.solve 'pay',{amount:2000}
  pay : (data)=>
    console.log data



module.exports = new PayMaster




