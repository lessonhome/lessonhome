

bcrypt = require 'bcryptjs'



class Register
  constructor : ->
    Wrap @
  init : =>
    db = yield Main.service 'db'
    @account  = yield db.get 'accounts'
    @session = yield db.get 'sessions'
    @accounts = {}
    @sessions = {}
    @logins   = {}
    acc  = yield _invoke @account.find(),'toArray'
    sess = yield _invoke @session.find(),'toArray'
    for a in acc
      @accounts[a.id]   = a
      if a.login?
        @logins[a.login] = a
    for s in sess
      @sessions[s.hash] = s

  register : (session)=>
    o = {}
    created = false
    unless session? && @sessions[session]?.account? && @accounts[@sessions[session].account]?
      session = yield @newAccount()
      created = true
    session = @sessions[session]
    account = @accounts[session.account]
    unless created
      session.accessTime = new Date()
      account.accessTime = new Date()
      _invoke(@account,'update',{id:account.id},{$set:{accessTime:(new Date())}},{upsert:true})
      .catch @onError
      _invoke(@session,'update',{hash:session.hash},{$set:{accessTime:(new Date())}},{upsert:true})
      .catch @onError
    types = ""
    for key,val of account.type
      if val
        types += ":" if types
        types += key
    idstr = 'user'.red+':'.grey+('('+types+')').yellow
    idstr += ':'.grey+account.login.cyan if account.login?
    idstr += ':'.grey+account.id.substr(0,5).blue
    idstr += ':'.grey+session.hash.substr(0,5).blue
    return {
      session:session.hash
      account:account
    }

  newType : (user,sessionhash,data)=>
    throw err:'bad_query'     unless data?.login? && data?.password? && data?.type?
    throw err:'login_exists'  if @logins[data.login]?
    throw err:'bad_session'   if !@accounts[user.id]?
    user = @accounts[user.id]
    
    throw err:'already_logined'       if user.registered
    throw err:'bad_session'           if !@sessions[sessionhash]?
    user = @accounts[user.id]
    user.registered = true
    user.login      = data.login
    @logins[user.login]   = user
    user[data.type]       = true
    user.other      = false
    user.type       ?= {}
    user.type[data.type]  = true
    user.type['other']    = false
    data.password = data.login+data.password
    user.hash       = yield @passwordCrypt _hash data.password
    user.accessTime = new Date()
    yield _invoke(@account,'update', {id:user.id},{$set:user},{upsert:true})
    return {session:@sessions[sessionhash],user:user}
  login : (user,sessionhash,data)=>
    throw err:'bad_query'            unless data?.login? && data?.password?
    throw err:'login_not_exists'      if !@logins[data.login]?
    throw err:'bad_session'           if !@accounts[user.id]?
    throw err:'bad_session'           unless @sessions[sessionhash]?
    user = @accounts[user.id]
    throw err:'already_logined'       if user.registered
    tryto = @logins[data.login]
    data.password = data.login+data.password
    throw err:'wrong_password'    unless yield @passwordCompare _hash(data.password), tryto.hash
    olduser = user
    hashs = []
    for hash of olduser.sessions
      hashs.push hash
      delete @sessions[hash]
    qs = []
    qs.push _invoke @session,'remove',{hash:{$in:hashs}}
    qs.push _invoke @account,'remove',{id:olduser.id}
    delete @accounts[olduser.id]
    user = @accounts[tryto.id]
    user.accessTime = new Date()
    sessionhash = yield @newSession user.id
    qs.push _invoke(@account,'update', {id:user.id},{$set:user},{upsert:true})
    yield Q.all qs
    return {session:@sessions[sessionhash],user:user}
  loginExists     : (name)=> @logins[name]?
  passwordCrypt   : (pass)=> _invoke  bcrypt,'hash',pass,10
  passwordCompare : (pass,hash)=> _invoke  bcrypt,'compare',pass,hash
  newAccount : =>
    try
      account =
        id            : _randomHash()
        registerTime  : new Date()
        accessTime    : new Date()
        other         : true
        type          :
          other       : true
        sessions      : {}
      @accounts[account.id]   = account
      sessionhash = yield @newSession account.id
      yield _invoke(@account,'update', {id:account.id},{$set:account},{upsert:true})
    catch e
      delete @accounts[account.id]  if account?.id?
      delete @sessions[sessionhash] if sessionhash?
      throw e
    return sessionhash
  newSession : (userid)=>
    account = @accounts[userid]
    session =
      hash          : _randomHash()
      account       : account.id
      createTime    : new Date()
      accessTime    : new Date()
    try
      account.sessions[session.hash] = true
      @sessions[session.hash] = session
      yield _invoke(@session,'update', {hash:session.hash},{$set:session},{upsert:true})
    catch e
      delete @sessions[session.hash]  if session?.hash?
      delete @account?.sessions?[session.hash] if session?.hash? && @account?.sessions?[session.hash]?
      throw e
    return session.hash


  onError : (e)=>
    @error e




module.exports = Register



