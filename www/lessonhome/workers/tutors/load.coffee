



class TutorsLoad
  constructor : ->

  init : =>
    @jobs = yield Main.service 'jobs'
    
    @db   = yield Main.service 'db'
    @dbAccounts = yield @db.get 'accounts'
    @dbPersons  = yield @db.get 'persons'
    @dbTutor    = yield @db.get 'tutor'
    
    @jobs.listen 'reloadIndexes', @reloadIndexes
    @jobs.listen 'reloadTutor',   @reloadTutor

  reloadTutor : (id)=>
  reloadIndexes : =>

  


  
  
  

module.exports = new TutorsLoad
