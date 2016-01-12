




class TutorsMaster
  constructor : ->
    $W @
  init : =>
    @jobs = yield Main.service 'jobs'
    
    @db   = yield Main.service 'db'
    @dbAccounts = yield @db.get 'accounts'
    #@dbPersons  = yield @db.get 'persons'
    #@dbTutor    = yield @db.get 'tutor'

    @redis = yield Main.service 'redis'
    @redis = yield @redis.get()
    
    yield @jobs.listen 'reloadIndexes', @jobReloadIndexes
    @t = new Date().getTime()
    yield @jobs.solve 'reloadIndexes'
    console.log new Date().getTime() - @t
    
  jobReloadIndexes : =>
    console.log new Date().getTime() - @t
    dids = yield _invoke @dbAccounts.find({tutor:true},{id:1}),'toArray'
    rids = yield _invoke @redis,'keys', 'parsedTutor.*'
    o = {}
    o[i.match(/^parsedTutor\.(.*)$/)?[1]]    = true for i in rids
    o[a.id] = true for a in dids
    o = Object.keys o
    console.log new Date().getTime() - @t
    q = []
    #q.push @jobs.solve 'reloadTutor',id for id in o
    n = 8
    step = o.length//n
    for i in [0...n]
      unless i==(n-1) then q.push @jobs.solve 'reloadTutor', o.slice(i*step,(i+1)*step)
      else q.push @jobs.solve 'reloadTutor', o.slice(i*step)
    yield Q.all q
    return

  


  
  
  

module.exports = new TutorsMaster
