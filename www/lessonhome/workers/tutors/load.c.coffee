




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
    
  jobReloadTutor   : require './reloadTutor'

  


  
  
  

module.exports = new TutorsLoad
