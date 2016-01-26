




class TutorsMaster
  init : =>
    @jobs = yield Main.service 'jobs'
    
    @db   = yield Main.service 'db'
    @dbAccounts = yield @db.get 'accounts'
    #@dbPersons  = yield @db.get 'persons'
    #@dbTutor    = yield @db.get 'tutor'

    @redis = yield Main.service 'redis'
    @redis = yield @redis.get()
    
    #yield @jobs.listen 'reloadIndexes', @jobReloadIndexes
    #yield @jobs.solve 'reloadIndexes'
    yield @load()
  load : => Q.spawn =>
    yield @jobReloadIndexes()
    yield @jobs.signal 'loadTutorsFromRedis'
    @const = yield @jobs.solve 'getConsts','filter'
    q = []
    for key,arr of @const.filter.subjects
      for subject in arr
        q.push @jobs.solve 'prefilterTutors','subject',subject
    yield Q.all q

  jobReloadIndexes : =>
    dids = yield _invoke @dbAccounts.find({tutor:true},{id:1}),'toArray'
    rids = yield _invoke @redis,'hkeys', 'parsedTutors'
    o = {}
    o[i.match(/^parsedTutor\.(.*)$/)?[1]]    = true for i in rids
    o[a.id] = true for a in dids
    o = Object.keys o
    q = []
    n = 8
    step = o.length//n
    for i in [0...n]
      unless i==(n-1) then q.push @jobs.solve 'reloadTutor', o.slice(i*step,(i+1)*step)
      else q.push @jobs.solve 'reloadTutor', o.slice(i*step)
    yield Q.all q
    yield _invoke @redis,'set','tutorsVersion',_randomHash()
    return

  


module.exports = TutorsMaster
  
  
  

