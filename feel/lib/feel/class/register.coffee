

bcrypt = require 'bcrypt'



class Register
  constructor : ->
    Wrap @
  init : =>
    db = yield Main.service 'db'
    @accaunt  = yield db.get 'accaunt'
    @session = yield db.get 'sessions'
    @accaunts = {}
    @sessions = {}
    @logins   = {}
    acc  = yield _invoke @accaunt.find(),'toArray'
    sess = yield _invoke @session.find(),'toArray'
    for a in acc
      @accaunts[a.id]   = a
      if a.login?
        @logins[a.login] = a
    for s in sess
      @sessions[s.hash] = s

  register : (session)=>
    o = {}
    created = false
    unless session? && @sessions[session]?
      session = yield @newAccaunt()
      created = true
    session = @sessions[session]
    accaunt = @accaunts[session.accaunt]
    console.log 'regcheck',session,accaunt,created
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

  newType : (user,sessionhash,data)=>
    throw new Error 'wrong data'            unless data?.login? && data?.password? && data?.type?
    throw new Error 'login already exists'  if @logins[data.login]?
    throw new Error 'bad user id'           if !@accaunts[user.id]?
    user = @accaunts[user.id]
    console.log 'newType',user
    
    throw new Error 'already logined'       if user.registered
    throw new Error 'bad session'           if !@sessions[sessionhash]?
    user = @accaunts[user.id]
    user.registered = true
    user.login      = data.login
    @logins[user.login] = user
    user[data.type]      = true
    user.hash       = yield @passwordCrypt _hash data.password
    user.accessTime = new Date()
    yield _invoke(@accaunt,'update', {id:user.id},{$set:user},{upsert:true})
    return {session:@sessions[sessionhash],user:user}
  login : (user,sessionhash,data)=>
    throw new Error 'wrong data'            unless data?.login? && data?.password?
    throw new Error 'login not exists'      if !@logins[data.login]?
    throw new Error 'bad user id'           if !@accaunts[user.id]?
    throw new Error 'bad session'           unless @sessions[sessionhash]?
    user = @accaunts[user.id]
    console.log user
    throw new Error 'already logined'       if user.registered
    tryto = @logins[data.login]
    throw new Error 'wrong pass' unless yield @passwordCompare _hash(data.password), tryto.hash
    olduser = user
    hashs = []
    for hash of olduser.sessions
      hashs.push hash
      delete @sessions[hash]
    qs = []
    qs.push _invoke @session,'remove',{hash:{$in:hashs}}
    qs.push _invoke @accaunt,'remove',{id:olduser.id}
    delete @accaunts[olduser.id]
    user = @accaunts[tryto.id]
    user.accessTime = new Date()
    sessionhash = yield @newSession user.id
    qs.push _invoke(@accaunt,'update', {id:user.id},{$set:user},{upsert:true})
    yield Q.all qs
    return {session:@sessions[sessionhash],user:user}
  passwordCrypt : (pass)=> _invoke  bcrypt,'hash',pass,10
  passwordCompare : (pass,hash)=> _invoke  bcrypt,'compare',pass,hash
  newAccaunt : =>
    try
      accaunt =
        id            : _randomHash()
        registerTime  : new Date()
        accessTime    : new Date()
        sessions      : {}
      @accaunts[accaunt.id]   = accaunt
      sessionhash = yield @newSession accaunt.id
      yield _invoke(@accaunt,'update', {id:accaunt.id},{$set:accaunt},{upsert:true})
    catch e
      delete @accaunts[accaunt.id]  if accaunt?.id?
      delete @sessions[sessionhash] if sessionhash?
      throw e
    return sessionhash
  newSession : (userid)=>
    accaunt = @accaunts[userid]
    session =
      hash          : _randomHash()
      accaunt       : accaunt.id
      createTime    : new Date()
      accessTime    : new Date()
    try
      accaunt.sessions[session.hash] = true
      @sessions[session.hash] = session
      yield _invoke(@session,'update', {hash:session.hash},{$set:session},{upsert:true})
    catch e
      delete @sessions[session.hash]  if session?.hash?
      delete @accaunt?.sessions?[session.hash] if session?.hash? && @accaunt?.sessions?[session.hash]?
      throw e
    return session.hash


  onError : (e)=>
    @error e




module.exports = Register



