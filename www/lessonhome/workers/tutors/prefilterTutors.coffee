




module.exports = (type,word)->
  yield @jobLoadTutorsFromRedis()
  #for index,prep of @tutors

