

class Tutors
  constructor : ->
    Wrap @
  init : ($)=>
    @inited = true
    @tutor = yield $.db.get 'tutor'
  handler : ($,data)->
    yield @init($) unless @inited
    console.log 'handler'.red
    return yield _invoke @tutor.find({}), 'toArray'

tutors = new Tutors
module.exports = tutors

