
_fs = require 'fs'
_util = require 'util'

class Output
  constructor : ->
    $W @
  init : =>
    @cliStream = _fs.createWriteStream './client.out',flags:'a'
    @jobs = yield Main.service 'jobs'
    yield @jobs.listen 'error',@jobError
    yield @jobs.listen 'log',@jobLog
    yield @jobs.client 'error',@jobCliError
    yield @jobs.client 'log',@jobCliLog
  jobError : (err,args...)=>
    if typeof err == 'string'
      console.error arguments...
    else if err?._jsoned
      console.error Exception(ExceptionUnJson err),args...
    else if err?.name || err?.message
      console.error Exception(err),args...
    else
      console.error arguments...
  jobLog : =>
    console.log arguments...
  jobCliError : (err,args...)=>
    if typeof err == 'string'
      str = [arguments...]
    else if err?._jsoned
      str = [Exception(ExceptionUnJson err),args...]
    else if err?.name || err?.message
      str = [Exception(err),args...]
    else
      str = [arguments...]
    @cliStream.write _util.format(str...)+'\n'
  jobCliLog : =>
    @cliStream.write _util.format(arguments...)+'\n'




module.exports = Output



