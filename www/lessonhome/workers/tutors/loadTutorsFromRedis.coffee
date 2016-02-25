


tutorChanged = (tutor,base)-> do Q.async => # tutor == tutor or id
  base ?= @base
  unless tutor?.index
    console.log 'read redis'
    tutor = yield _invoke @redis, 'hget','parsedTutors',tutor
    tutor = JSON.parse tutor ? "{}"
  base.tutors.byid[tutor.account.id] = tutor
  base.tutors.byindex[tutor.index]   = tutor



tutorDeleted = (id)-> do Q.async =>
  tutor =  @base?.tutors?.byid?[id]
  return unless tutor?.index
  delete @base.tutors.byindex[tutor.index]
  delete @base.tutors.byid[tutor.id]


module.exports = ->
  unless @_onTutorChange
    #yield @jobs.onSignal 'reloadTutor-changed', => tutorChanged.apply @, arguments
    #yield @jobs.onSignal 'reloadTutor-deleted', => tutorDeleted.apply @, arguments
    @_onTutorChange = true

  version = yield _invoke @redis,'get','tutorsVersion'
  return if version == @tutorsVersion
  @tutorsVersion = version
  base = tutors:
    byid    : {}
    byindex : {}
  base.tutors.byid = yield _invoke @redis, 'hgetall','parsedTutors'
  base.tutors.byid ?= {}
  for id,tutor of base.tutors.byid
    tutor = JSON.parse tutor ? "{}"
    yield tutorChanged tutor,base
  @base = base



