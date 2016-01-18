




class TutorsLoad
  constructor : ->
    $W @
  init : =>
    @jobs = yield Main.service 'jobs'
    
    @db   = yield Main.service 'db'
    @dbAccounts = yield @db.get 'accounts'
    @dbPersons  = yield @db.get 'persons'
    @dbTutor    = yield @db.get 'tutor'
    @dbUploaded = yield @db.get 'uploaded'
    
    @redis = yield Main.service 'redis'
    @redis = yield @redis.get()

    yield @jobs.listen 'reloadTutor', @jobReloadTutor
    yield @jobs.listen 'prefilterTutors', @jobPrefilterTutors
    yield @jobs.onSignal 'loadTutorsFromRedis', @jobLoadTutorsFromRedis
    
  jobReloadTutor          : require './reloadTutor'
  jobLoadTutorsFromRedis  : require './loadTutorsFromRedis'
  jobPrefilterTutors      : require './prefilterTutors'

  


  
  
  

module.exports = new TutorsLoad
