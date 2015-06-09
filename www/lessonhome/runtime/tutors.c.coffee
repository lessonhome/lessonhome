

class Tutors
  constructor : ->
    Wrap @
  handler : ($,data)->
    console.log 'handler'.red
    return $.req.user.id

tutors = new Tutors
module.exports = tutors

