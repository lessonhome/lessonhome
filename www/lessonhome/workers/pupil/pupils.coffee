
Pupil = require './pupil'

GLO = {}
GLO2 = {}

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
 
  #########################################
  reloadDb : =>
    db = yield _invoke @main.dbPupil.find({}),'toArray'
    pupils = {}
    @pupils = {}
    for pupildb in (db ? [])
      unless pupildb?.state
        @toMerge.push pupildb
        continue
      yield @createPupil pupildb

  runMerge : =>
    for pupildb in @toMerge
      yield @_mergePupilInfo pupildb
    @toMerge = []

  _mergePupilInfo : (pupil)=>
    pupil = Pupil::_preparePupil pupil
    delete pupil.subjects
    delete pupil.status
    delete pupil.bids

    found = yield @findPupil pupil
    if found.length
      other = found.pop()
      while one = found.pop()
        other = yield @mergeOneToOther one,other
      yield other.extraInfo pupil
    else
      other = yield @createPupil pupil

  findPupil : (pupil)=>
    found = yield _invoke @main.dbPupil.find({$or:[
      {email:$in:pupil.email},{phone:$in:pupil.phone},{accounts:$in:pupil.accounts}
    ],{state:$exists:true} }).sort(registerTime:-1),'toArray'
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
    yield @main.bids.updatedPupil   other
    yield @main.chats.updatedPupil  other
    data = yield other.getData()
    yield @main.jobs.solve 'registerMoveSessions',data.accounts,data.account

  createPupil : (pupildb)=>
    pupil = new Pupil @main
    yield pupil.init pupildb
    pdata = yield pupil.getData()
    for acc in pdata.accounts
      @pupils[acc] = pupil
    return pupil


module.exports = Pupils



