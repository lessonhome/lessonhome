


class DataHelper
  constructor : ->
    $W @
  init : =>
    @redis = yield Main.service('redis')
    @redis = yield @redis.get()

  getTutors : (count,req)=>


  






module.exports = DataHelper




