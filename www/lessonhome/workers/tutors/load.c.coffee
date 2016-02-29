




class TutorsLoad
  init : =>
    @jobs = yield Main.service 'jobs'
    
    @db   = yield Main.service 'db'
    @dbAccounts = yield @db.get 'accounts'
    @dbPersons  = yield @db.get 'persons'
    @dbTutor    = yield @db.get 'tutor'
    @dbUploaded = yield @db.get 'uploaded'
    
    @redis = yield Main.service 'redis'
    @redis = yield @redis.get()

    @base  = {}
    yield @jobLoadTutorsFromRedis()
    yield @jobs.listen 'reloadTutor',           => @jobReloadTutor arguments...
    yield @jobs.listen 'prefilterTutors',       => @jobPrefilterTutors arguments...
    yield @jobs.listen 'getTutor',@jobGetTutor
    yield @jobs.onSignal 'loadTutorsFromRedis', => @jobLoadTutorsFromRedis arguments...
    
  jobReloadTutor          : require './reloadTutor'
  jobLoadTutorsFromRedis  : require './loadTutorsFromRedis'
  jobPrefilterTutors      : require './prefilterTutors'
  jobGetTutor : ({index})=>
    ret = @base?.tutors?.byindex?[index]
    ret ?= @base?.tutors?.byindex?[99637] ? {}
    ret = ret._client if ret?._client?
    return ret





module.exports = TutorsLoad
