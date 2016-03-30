

@parseMessage = (message,pupil,moderator)=>
  message.type = message.type || ""
  switch message.type
    when 'pupil'
      message.from = pupil
    when 'moderator'
      message.from = moderator
  d = new Date()
  d.setTime(message.time)
  
  message.timestr = d.format "dd.mm.yyyy HH:MM"
  return message

@parse = (value)=>
  for key,message of value.chat.messages
    @parseMessage message,value.pupil,value.moderator

  return value
  



