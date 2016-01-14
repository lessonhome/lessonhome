




module.exports = (type,word)->
  yield @jobLoadTutorsFromRedis()
  console.log 'prefilterBy'.red,type,word
  for index,prep of @tutors
    console.log prep.index

