
Pupil = require './pupil'


class Pupils
  constructor : (@main)->
    @pupils = {}
    @locker = $Locker()
    @toMerge = []

  ########################################
  init : => @locker.$lock =>
    yield @reloadDb()

  run : => @locker.$free =>
    yield @runMerge()

  getPupil : (userId)=> @locker.$free =>
    return @pupils[userId] if @pupils?[userId]?
    throw new Error 'unknown pupil with account '+userId
  
  pupilUpdate : (auth,data)=> @locker.$free =>
    throw new Error unless @pupils[auth?.id]?
    pupil = yield @getPupil auth.id
    yield pupil.update data
  
  mergePupilInfo : (pupil)=> @locker.$free =>
    return yield @_mergePupilInfo pupil
 
  #########################################
  reloadDb : =>
    @toMerge = []
    db = yield _invoke @main.dbPupil.find({}),'toArray'
    for acc,pupil of @pupils
      yield pupil.destruct()
    @pupils = {}
    for pupildb in (db ? [])
      unless pupildb?.state
        @toMerge.push pupildb
        continue
      yield @initPupil pupildb

  runMerge : =>
    for pupildb in @toMerge
      yield @_mergePupilInfo pupildb
    @toMerge = []

  _mergePupilInfo : (pupil)=>
    oldId = pupil._id
    pupil = Pupil::_preparePupil pupil
    
    found = yield @findPupil pupil
    if found.length
      other = found.pop()
      while one = found.pop()
        console.log 'one to other'.red
        other = yield @mergeOneToOther one,other
      yield other.extraInfo pupil
    else
      other = yield @initPupil pupil
    yield @_checkOldForRemove other.data._id,oldId
    return other
  
  _checkOldForRemove : (now,old)=>
    return unless old
    return if now == old
    yield _invoke @main.dbPupil,'remove',{_id:@main._getID(old)}
  findPupil : (pupil)=>
    fo = {$or:[],state:{$exists:true}}
    fo.$or.push emails:$in:pupil.emails if pupil.emails.length
    fo.$or.push phones:$in:pupil.phones if pupil.phones.length
    fo.$or.push accounts:$in:pupil.accounts if pupil.accounts.length
    
    throw new Error 'bad pupil for find similar '+JSON.stringify(pupil) unless fo.$or.length

    found = yield _invoke @main.dbPupil.find(fo).sort(registerTime:-1),'toArray'
    found ?= []
    ret = []
    for p in found
      p = @pupils[p.account]
      throw new Error "unknown pupil" unless p?
      ret.push p
    return ret

  mergeOneToOther : (one,other)=>
    yield other.extraInfo yield one.getData()
    yield one.remove()
    return other

  initPupil : (pupildb)=>
    pupil = new Pupil @main
    yield pupil.init pupildb
    pdata = yield pupil.getData()
    for acc in pdata.accounts
      @pupils[acc] = pupil
    return pupil


module.exports = Pupils



