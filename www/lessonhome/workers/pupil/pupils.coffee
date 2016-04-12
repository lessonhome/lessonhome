
Pupil = require './pupil'


class Pupils
  constructor : (@main)->
    @pupils = {}
  init : =>
    yield @reloadDb()

  reloadDb : =>
    db = yield _invoke @main.dbPupil.find({}),'toArray'
    db ?= []
    pupils = {}
    for pupildb in pupils
      pupil = new Pupil @main
      yield pupil.init pupildb
      pupils[pupil.data.account] = pupil
    @pupils = pupils
  getPupil : (userId)=>
    return @pupils[userId] if @pupils?[userId]?
    throw new Error 'unknown pupil with account '+userId

  pupilUpdate : (auth,data)=>
    throw new Error unless @pupils[auth?.id]?
    pupil = yield @getPupil auth.id
    yield pupil.update data
  

module.exports = Pupils



