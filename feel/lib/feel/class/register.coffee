



class Register
  constructor : ->
    Wrap @
  init : =>
    db = yield Main.service 'db'
    @accaunt  = yield db.get 'accaunt'
    @session = yield db.get 'sessions'
    @accaunts = {}
    @sessions = {}
    acc  = yield _invoke @accaunt.find(),'toArray'
    sess = yield _invoke @session.find(),'toArray'
    for a in acc
      @accaunts[a.id]   = a
    for s in sess
      @sessions[s.hash] = s
  register : (session)=>
    o = {}
    unless session? && @sessions[session]?
      session = yield @newAccaunt()
      created = true
    session = @sessions[session]
    accaunt = @accaunts[session.accaunt]
    unless created
      session.accessTime = new Date()
      accaunt.accessTime = new Date()
      _invoke(@accaunt,'update',{id:accaunt.id},{$set:{accessTime:(new Date())}},{upsert:true})
      .catch @onError
      _invoke(@session,'update',{hash:session.hash},{$set:{accessTime:(new Date())}},{upsert:true})
      .catch @onError
    return {
      session:session.hash
      accaunt:accaunt
    }
  newAccaunt : =>
    accaunt =
      registered    : false
      tutor         : false
      pupil         : false
      id            : _randomHash()
      registerTime  : new Date()
      accessTime    : new Date()
      sessions      : {}
    session =
      hash          : _randomHash()
      accaunt       : accaunt.id
      createTime    : new Date()
      accessTime    : new Date()
    accaunt.sessions[session.hash] = true
    @accaunts[accaunt.id]   = accaunt
    @sessions[session.hash] = session
    _invoke(@accaunt,'update', {id:accaunt.id},{$set:accaunt},{upsert:true}).catch @onError
    _invoke(@session,'update', {hash:session.hash},{$set:session},{upsert:true}).catch @onError
    return session.hash
  onError : (e)=>
    @error e




module.exports = Register



