



class Pupil
  constructor : (@main)->
    $W @
    @locker = $Locker()
    @unset =
      phone : ""
      email : ""
      phone_call : ""
      subjects : ""
      status : ""
      bids : ""

  ###################################################
  init : (data)=> @locker.$lock =>
    @data = yield @checkData data

  destruct : => @locker.$lock =>

  getData : => @locker.$free => @data

  update : (data)=> @locker.$lock =>
    @data = yield @checkData @data,data

  extraInfo : (from)=> @locker.$lock =>
    if from?.account || from?.accounts?.length
      if from.account != @data.account
        depends = true
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
   
    yield @updateDepends() if depends

  remove : => @locker.$lock =>
    return unless @data._id
    yield _invoke @main.dbPupil,'remove',_id:@main._getID(@data._id)

  ###################################################
  updateDepends : =>
    accsfrom = []
    for key in @data.accounts
      accsfrom.push key unless key == @data.account
    console.log 'update depends'.red,accsfrom,@data.account
    yield @main.bids.updatedPupil   @data
    yield @main.chats.updatedPupil  @data
    yield @main.jobs.solve 'registerMoveSessions',accsfrom,@data.account

  checkData : (data=@data,updateObj)=>
    if updateObj?
      for key,val of updateObj
        data[key] = val

    data = yield @_preparePupil data
        
    yield @_write data
    return data

  _write : (data=@data)=>
    __hash = @main.hash data
    return if data.__hash == __hash
    data.__hash = __hash
    #f = state:$exists:true
    f = {}
    if data._id
      f._id = @main._getID data._id
    else
      f.account = data.account

    yield _invoke @main.dbPupil,'update',f,{$set:data,$unset:@unset},{upsert:true}
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
    if pupil.phone_call?.phones?
      for key,val of pupil.phone_call.phones
        if pupil.phone_call.phones.length
          pp[val] = true if val
        else
          pp[key] = true if key
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
    pupil.emails = []
    for email of ee
      email = email.replace /\s/g,''
      pupil.emails.push email if email.match(/\@/) && (email.length>=6)

    pupil.registerTime ?= new Date()

    pupil.state ?= 'inited'
    
    delete pupil[key] for key of @unset

    return pupil



module.exports = Pupil


