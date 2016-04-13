



class Pupil
  constructor : (@main)->
    $W @
    @locker = $Locker()

  ###################################################
  init : (data)=> @locker.$lock =>
    @data = yield @checkData data

  getData : => @locker.$free => @data

  update : (data)=> @locker.$lock =>
    @data = yield @checkData @data,data

  extraInfo : (from)=> @locker.$lock =>
    to = {}
    to[key] = val for key,val of @data

    if to.registerTime.getTime() > from.registerTime.getTime()
      to.registerTime = from.registerTime
    for key,val of from
      to[key] = val unless to[key]
    to.accounts.push from.accounts...
    to.phones.push from.phones...
    to.emails.push from.emails...
    
    @data = yield @checkData @data,to

  remove : => @locker.$lock =>
    return unless @data._id
    yield _invoke @main.dbPupil,'remove',_id:@main._getID(@data._id)

  ###################################################
  checkData : (data=@data,updateObj)=>
    startHash = _object_hash data
    #********************    
    if updateObj?
      for key,val of updateObj
        data[key] = val
        
    #********************
    endHash = _object_hash data
    if (startHash != endHash) || (!data._id)
      yield @_write()
    return data

  _write : (data=@data)=>
    f = state:$exists:true
    if data._id
      f._id = @main._getID data._id
    else
      f.account = data.account
    yield _invoke @main.dbPupil,'update',f,{$set:data},{upsert:true}
    unless data._id
      ret = yield _invoke @main.dbPupil.find(f,{_id:1}),'toArray'
      data._id = ret?[0]?._id

  ########## static ############  
  _preparePupil : (pupil)->
    phones    = {}
    emails    = {}

    pupil.accounts ?= []
    pupil.accounts.push pupil.account if pupil.account
    accs = {}
    for acc in pupil.accounts
      accs[acc] = true unless accs[acc]
    pupil.accounts = Object.keys(accs)
    unless pupil.accounts.length
      throw new Error 'empty accounts in pupil'
    pupil.account  = pupil.accounts[0]
    
    pp = {}
    pupil.phones ?= []
    for key,val of pupil.phones
      if pupil.phones.length
        pp[val] = true if val
      else
        pp[key] = true if key
    pp[pupil.phone] = true if pupil.phone
    delete pupil.phone
    if pupil.phone_call?.phones?
      for key,val of pupil.phone_call.phones
        if pupil.phone_call.phones.length
          pp[val] = true if val
        else
          pp[key] = true if key
    delete pupil.phone_call
    pupil.phones = Object.keys pp
    pp = {}
    for phone in pupil.phones
      phone = phone.replace(/\D/g,'')
      if phone.length == 11
        phone = phone.replace(/^[7|8]/,'')
      if phone.length>=7
        pp[phone] = true unless pp[phone]
    pupil.phones = Object.keys pp
  
    pupil.emails ?= []
    ee = {}
    ee[email] = true for email in pupil.emails
    ee[pupil.email] = true if pupil.email
    delete pupil.email
    pupil.emails = []
    for email of ee
      email = email.replace /\s/g,''
      pupil.emails.push email if email.match(/\@/) && (email.length>=6)

    pupil.registerTime ?= new Date()

    pupil.state ?= 'inited'

    return pupil



module.exports = Pupil


