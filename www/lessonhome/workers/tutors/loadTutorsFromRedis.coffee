




module.exports = ->
  version = yield _invoke @redis,'get','tutorsVersion'
  return if version == @tutorsVersion
  @tutorsVersion = version
  arr = yield _invoke @redis, 'hvals','parsedTutors'
  @tutors = {}
  for tutor,i in arr
    tutor = JSON.parse tutor
    @tutors[tutor.index] = tutor

