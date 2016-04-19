
TelegramApi = require './telegram.api'


class Telegram
  constructor : ->
    $W @
    
  init : =>
    @api = new TelegramApi
    yield @api.init()
    @jobs = yield Main.service 'jobs'

    @jobs.listen 'telegramMessage',@jobTelegramMessage

  jobTelegramMessage : (phone,message)=> @api.msg phone,message


  
  

module.exports = Telegram




