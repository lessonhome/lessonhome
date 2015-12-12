

@handler = ($,messages,sender)=>
  return unless $.user.admin
  sms = yield Main.service 'sms'
  return yield sms.send messages,sender


