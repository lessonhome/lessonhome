

bcrypt = require 'bcryptjs'

time = (str)=>
  t = new Date().getTime()
  #console.log str,t-@t if str
  @t = t


class Register
  constructor : ->
    Wrap @
  init : =>
    time()
    db = yield Main.service 'db'
    @jobs = yield Main.service 'jobs'
    time '1'
    yield @jobs.listen 'registerReload',@jobRegisterReload
    time '2'
    @account  = yield db.get 'accounts'
    @session = yield db.get 'sessions'
    @bills = yield db.get 'bills'
    @dbpersons = yield db.get 'persons'
    @dbpupil  = yield db.get 'pupil'
    @dbtutor  = yield db.get 'tutor'
    @dbuploaded = yield db.get 'uploaded'
    @mail = yield Main.service 'mail'
    @urldata = yield Main.service 'urldata'
    @adminHashs = yield db.get 'adminHashs'
    time '3'
    arr = yield _invoke @adminHashs.find({}),'toArray'
    time '4'
    @adminHashsArr = {}
    for r in arr
      @adminHashsArr[r.hash] = true
    ids = {}
    _ids = (yield _invoke @dbpersons.find({},{account:1}),'toArray')
    time '5'
    ids[row.account] = true for row in _ids
    console.log "persons: ".magenta, _ids?.length
    _ids = (yield _invoke @dbpupil.find({},{account:1}),'toArray')
    time '6'
    ids[row.account] = true for row in _ids
    console.log 'pupils: '.magenta,_ids?.length
    _ids = (yield _invoke @dbtutor.find({},{account:1}),'toArray')
    time '7'
    ids[row.account] = true for row in _ids
    console.log 'tutors: '.magenta, _ids?.length
    
    nids = {}
    d = new Date()
    d.setDate d.getDate()-1
    _ids = (yield _invoke @account.find({$or:[ {accessTime:{$eq:null}},{id:{$nin:Object.keys(ids)},accessTime:{$lt:d}}]},{id:1}),'toArray')
    time '8'
    nids[row.id] = true for row in _ids
    nids = Object.keys nids
    console.log 'illegals: '.magenta,nids.length
    time '9'
    yield _invoke @account,'update',{account:{$exists:true}},{$unset:{account:""}},{multi:true}
    time '21'
    yield _invoke @account,'update',{acc:{$exists:true}},{$unset:{acc:""}},{multi:true}
    time '22'
    yield _invoke @account, 'remove',{id:{$in:nids}}
    time '23'
    yield _invoke @session, 'remove',{account:{$in:nids}}
    time '24'
    yield _invoke @dbpersons, 'remove',{account:{$in:nids}}
    time '25'
    yield _invoke @dbtutor, 'remove',{account:{$in:nids}}
    time '26'
    yield _invoke @dbpupil, 'remove',{account:{$in:nids}}
    time '27'
    d = new Date()
    d.setDate d.getDate()-30
    yield _invoke @session,'remove',{accessTime:{$lt:d}}
    time '28'

    @accounts = {}
    @sessions = {}
    @logins   = {}
    acc  = yield _invoke @account.find(),'toArray'
    time '29'
    sess = yield _invoke @session.find(),'toArray'
    time '30'
    for a in acc
      @accounts[a.id]   = a
      delete a.account
      delete a.acc
      if a.login?
        @logins[a.login] = a
    for s in sess
      @sessions[s.hash] = s
    @aindex = 0
    for id,a of @accounts
      @aindex = a.index if (a?.index?) && (@aindex < a.index)
    d.setDate d.getDate()-100000
    time '31'
    for id,a of @accounts
      unless a?.index?
        a.index = ++@aindex
        yield _invoke @account,'update',{id:id},{$set:{index:a.index}}
      if (Object.keys(a.sessions ? {})?.length>5)
        arr = []
        for s of a.sessions
          arr.push @sessions[s] ? {hash:s,accessTime:d}
        arr.sort (a,b)=> b.accessTime?.getTime?()-a.accessTime?.getTime?()
        arr = arr.splice 5
        arr2 = []
        arr2.push s.hash for s in arr
        for s in arr2
          delete a.sessions[s]
          delete @sessions[s]
        yield _invoke @session, 'remove',{hash:{$in:arr2}}
        yield _invoke @account,'update',{id:id},{$set:{sessions:a.sessions}}
    time '32'
    yield @jobs.listen 'registerMoveSessions',@jobRegisterMoveSessions

  delete_tutor : (id)=>
    for session of @accounts[id].sessions
      delete @sessions[session]
    delete @accounts[id]
  jobRegisterReload : (id)=>
    unless id && typeof id == 'string'
      throw new Error 'job:registerReload(userId) require userId'
    yield @reload id
  reload : (id)=>
    acc  = yield _invoke @account.find(id:id),'toArray'
    sess = yield _invoke @session.find(account:id),'toArray'
    for session of @accounts[id].sessions
      delete @sessions[session]
    for a in acc
      @accounts[a.id]   = a
      delete a.account
      delete a.acc
      if a.login?
        @logins[a.login] = a
    for s in sess
      @sessions[s.hash] = s
    
  register : (session,unknown,adminHash)=>
    o = {}
    created = false
    unless session? && @sessions[session]?.account? && @accounts[@sessions[session].account]?
      session = yield @newAccount()
      created = true
    session = @sessions[session]
    account = @accounts[session.account]
    if typeof unknown == 'string' && (m = unknown.match /^set(.*)$/)
      if m[1] == session.hash.substr 0,8
        delete account.unknown
        acc = {}
        acc[key] = val for key,val of account
        delete acc.account
        yield _invoke(@account,'update',{id:account.id},{$set:acc},{upsert:true})
        yield _invoke(@session,'update',{hash:session.hash},{$set:session},{upsert:true})
    if !created && !account.unknown
      session.accessTime = new Date()
      account.accessTime = new Date()
      acc = {}
      acc[key] = val for key,val of account
      delete acc.account
      _invoke(@account,'update',{id:account.id},{$set:acc},{upsert:true})
      .catch @onError
      _invoke(@session,'update',{hash:session.hash},{$set:session},{upsert:true})
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
    newAcc  = {}
    for key,val of account
      newAcc[key] = val
    newAcc.type = {}
    for key,val of account.type
      newAcc.type[key] = val
    if adminHash && @adminHashsArr[adminHash]
      newAcc.admin = true
      newAcc.type.admin = true
    return {
      session:session.hash
      account:newAcc
    }
  bindAdmin : (session)=>
    return unless @sessions[session]
    @sessions[session].admin = true
    session = @sessions[session]
    yield _invoke(@session,'update',{hash:session.hash},{$set:session},{upsert:true})
    return
  getAdminHash : =>
    hash = _randomHash 30
    yield _invoke @adminHashs,'insert',{hash}
    @adminHashsArr[hash] = true
    return hash
  removeAdminHash : (hash)=>
    delete @adminHashsArr[hash]
    yield _invoke @adminHashs,'remove',{hash}
    return

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
    acc = {}
    acc[key] = val for key,val of user
    delete acc.account
    yield _invoke(@account,'update', {id:user.id},{$set:user},{upsert:true})

    #--------------
    bill = {
      account: user.id
      value: 0
    }

    yield _invoke(@bills,'insert',bill)

    #---------------
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
    #console.log data
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
    acc = {}
    acc[key] = val for key,val of user
    delete acc.account
    qs.push _invoke(@account,'update', {id:user.id},{$set:user},{upsert:true})
    yield Q.all qs
    return {session:@sessions[sessionhash],user:user}
  jobRegisterMoveSessions : (from,to)=>
    accs = []
    for key in from
      if key != to
        accs.push @accounts[key] if @accounts[key]
    toacc = @accounts[to]
    unless toacc
      throw new Error 'unknown account '+to unless to
      yield @newAccount to,false,{pupil:true}
      toacc = @accounts[to]
      throw new Error 'failed newAccount '+to unless toacc
    toacc.pupil = true
    toacc.type ?= {other:true}
    toacc.type.pupil = true
    qs = []
    
    qs.push _invoke @session,'update',{
      account : $in : from
    },{$set:account:toacc.id}
    
    for acc in accs
      for session of acc.sessions
        toacc.sessions[session] = true
      qs.push _invoke @account,'update',{id:acc.id},{$set:sessions:{}}
    accdb = {}
    for key,val of toacc
      accdb[key] = val unless key == 'account'
    qs.push _invoke @account,'update',{id:toacc.id},{$set:accdb},{upsert:true}
    yield Q.all qs
    yield @reload toacc.id
    for acc in accs
      yield @reload acc.id

  passwordUpdate : (user,sessionhash,data,admin=false)=>
    throw err:'bad_query'            unless data?.login? && data?.password? && data?.newpassword?
    throw err:'login_not_exists'      if !@logins[data.login]?
    throw err:'bad_session'           if !@accounts[user.id]?
    throw err:'bad_session'           unless @sessions[sessionhash]?
    user = @accounts[user.id]
    throw err:'not_logined'       unless user.registered
    data_password = data.login+data.password
    throw err:'wrong_password'    unless admin || yield @passwordCompare _hash(data_password), user.hash
    ndata_password = data.login+data.newpassword
    user.hash       = yield @passwordCrypt _hash ndata_password
    user.accessTime = new Date()
    acc = {}
    acc[key] = val for key,val of user
    delete acc.account
    yield _invoke(@account,'update', {id:user.id},{$set:user},{upsert:true})
    return {session:@sessions[sessionhash],user:user}
  passwordRestore: (data) =>
    db = yield Main.service 'db'

    token = _randomHash(10)
    utoken = yield @urldata.d2u 'authToken',{token:token}

    validDate = new Date()
    validDate.setHours(validDate.getHours()+24)
    user = @logins[data.login]
    throw err:'login_not_exists' unless user?
    throw err:'email_not_exists' unless data.email?.length
    restorePassword = {
      token: token
      valid: validDate
    }
    console.log 'save',restorePassword
    user.authToken = restorePassword
    acc = {}
    acc[key] = val for key,val of user
    delete acc.account
    yield _invoke(@account,'update', {id:user.id},{$set:user},{upsert:true})

    persons = yield  _invoke @dbpersons.find({account: user.id}), 'toArray'
    p = persons?[0] ? {}
    name = "#{p?.last_name ? ''} #{p?.first_name ? ''} #{p?.middle_name ? ''}"
    name = name.replace /^\s+/,''
    name = name.replace /\s+$/,''
    name = ', '+ name if name
    for email in data.email ? []
      yield @mail.send(
        'restore_password.html'
        email
        'Восстановление пароля'
        {
          name: name
          login: user.login
          link: 'https://lessonhome.ru/new_password?'+utoken
        }
      )

  newPassword: (user, data) =>
    db = yield Main.service 'db'
    accountsDb = yield db.get 'accounts'

    qstring = data.ref.replace(/.*\?/, '')
    token = yield @urldata.u2d qstring
    token = token.authToken.token
    console.log token
    accounts = yield _invoke accountsDb.find({'authToken.token': token}),'toArray'

    user = {}
    console.log '1'
    ndata_password = accounts[0].login+data.password
    passhash = yield @passwordCrypt _hash ndata_password
    user.hash = passhash
    console.log user
    yield _invoke(@account,'update', {'authToken.token': token},{$set:user},{upsert:true})

    #console.log 'changed pass to '+data.password
    #console.log 'hash', passhash

    accounts = yield _invoke accountsDb.find({'authToken.token': token}),'toArray'
    console.log '2'

    @logins[accounts[0].login] = accounts[0]

    user = @accounts[user.id]
    console.log '4'
    tryto = @logins[accounts[0].login]
    olduser = tryto
    hashs = []
    for hash of olduser.sessions
      hashs.push hash
      delete @sessions[hash]
    qs = []
    yield _invoke @session,'remove',{hash:{$in:hashs}}
    user = @accounts[tryto.id]
    user.accessTime = new Date()
    user.hash = passhash

    #console.log user
    sessionhash = yield @newSession user.id
    acc = {}
    acc[key] = val for key,val of user
    delete acc.account
    console.log user
    yield  _invoke(@account,'update', {id:acc.id},{$set:acc})
    yield  _invoke(@account,'update', {'authToken.token': token},{$unset:{authToken: ''}})
    yield Q.all qs

    return {session:@sessions[sessionhash],user:user}
  relogin : (user,sessionhash,index)=>
    #console.log index
    throw 'err access' unless user.admin
    #throw err:'bad_query'            unless data?.login? && data?.password?
    #throw err:'login_not_exists'      if !@logins[data.login]?
    #throw err:'bad_session'           if !@accounts[user.id]?
    #throw err:'bad_session'           unless @sessions[sessionhash]?
    login = ''
    for key,a of @accounts
      if a.index == index
        #console.log a
        login = a.login
    #console.log login
    throw 'not found' unless login
    user = @accounts[user.id]
    #throw err:'already_logined'       if user.registered
    tryto = @logins[login]
    #console.log tryto
    #data.password = data.login+data.password
    #throw err:'wrong_password'    unless yield @passwordCompare _hash(data.password), tryto.hash
    olduser = user
    hashs = []
    for hash of olduser.sessions
      hashs.push hash
      delete @sessions[hash]
    qs = []
    qs.push _invoke @session,'remove',{hash:{$in:hashs}}
    #qs.push _invoke @account,'remove',{id:olduser.id}
    #delete @accounts[olduser.id]
    user = @accounts[tryto.id]
    user.accessTime = new Date()
    sessionhash = yield @newSession user.id
    acc = {}
    acc[key] = val for key,val of user
    #console.log acc
    delete acc.account
    qs.push _invoke(@account,'update', {id:user.id},{$set:user},{upsert:true})
    yield Q.all qs
    return {session:@sessions[sessionhash],user:user}
  loginExists     : (name)=> @logins[name]?
  loginUpdate : (user,sessionhash,data,admin=false)=>
    throw err:'bad_query'            unless data?.login? && data?.password? && data?.newlogin?
    throw err:'login_not_exists'      if !@logins[data.login]?
    throw err:'login_exists'  if @logins[data.newlogin]?
    throw err:'bad_session'           if !@accounts[user.id]?
    throw err:'bad_session'           unless @sessions[sessionhash]?
    user = @accounts[user.id]
    throw err:'not_logined'       unless user.registered
    data_password = data.login+data.password
    throw err:'wrong_password'    unless admin || yield @passwordCompare _hash(data_password), user.hash
    ndata_password = data.newlogin+data.password

    user.hash       = yield @passwordCrypt _hash ndata_password
    delete @logins[user.login]
    user.login = data.newlogin
    @logins[user.login] = user
    user.accessTime = new Date()
    acc = {}
    acc[key] = val for key,val of user
    delete acc.account
    yield _invoke(@account,'update', {id:user.id},{$set:user},{upsert:true})
    return {session:@sessions[sessionhash],user:user}

  passwordCrypt   : (pass)=> _invoke  bcrypt,'hash',pass,10
  passwordCompare : (pass,hash)=>
    #console.log pass, hash
    bcrypt.compare(pass, hash, (err, res)->
      if err
        throw err
      else
        #console.log res
    )
    _invoke  bcrypt,'compare',pass,hash
  newAccount : (hashid,unknown='need',type={})=>
    hashid ?= _randomHash()
    type.other = true
    try
      account =
        id            : hashid
        index         : ++@aindex
        registerTime  : new Date()
        accessTime    : new Date()
        type          : type
        sessions      : {}
        unknown       : unknown
      for key,val of type
        account[key] ?= true
      @accounts[account.id]   = account
      sessionhash = yield @newSession account.id
      #yield _invoke(@account,'update', {id:account.id},{$set:account},{upsert:true})
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
      unless account.unknown
        yield _invoke(@session,'update', {hash:session.hash},{$set:session},{upsert:true})
    catch e
      delete @sessions[session.hash]  if session?.hash?
      delete @account?.sessions?[session.hash] if session?.hash? && @account?.sessions?[session.hash]?
      throw e
    return session.hash


  onError : (e)=>
    @error e




module.exports = Register



