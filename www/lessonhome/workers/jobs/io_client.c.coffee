


class JobsIOClient
  constructor : ->
    $W @
  init : =>

  handler : ($,jobName,jobData...)=>
    @jobs ?= yield Main.service 'jobs'
    user =
      id   : $.user.id
      registered : $.user.registered
      login : $.user.login
      index : $.user.index
      type  : $.user.type
    user[key] = val for key,val of $.user.type
    [ret,error] = [null,null]
    t = new Date().getTime()
    try
      ret = yield @jobs.solve_as_client jobName,user,jobData...
    catch e
      error =  ExceptionJson e
    return {ret,error}


module.exports = new JobsIOClient


