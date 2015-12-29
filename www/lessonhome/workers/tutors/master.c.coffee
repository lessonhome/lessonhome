




class TutorsLoad
  constructor : ->
    $W @
  init : =>
    @jobs = yield Main.service 'jobs'
    
    @db   = yield Main.service 'db'
    @dbAccounts = yield @db.get 'accounts'
    @dbPersons  = yield @db.get 'persons'
    @dbTutor    = yield @db.get 'tutor'

    @redis = yield Main.service 'redis'
    @redis = yield @redis.get()
    
    yield @jobs.listen 'reloadIndexes', @reloadIndexes
    yield @jobs.listen 'reloadTutor',   @reloadTutor
    
  reloadTutor   : require './reloadTutor'
  reloadIndexes : require './reloadIndexes'

  


  
  
  

module.exports = new TutorsLoad
