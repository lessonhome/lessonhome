

@parseMessage = (message,pupil,moderator)=>
  message.type = message.type || ""
  switch message.type
    when 'pupil'
      message.from = pupil
    when 'moderator'
      message.from = moderator
  d = new Date()
  d.setTime(message.time)
  options =
    era: 'narrow'
    year: 'numeric'
    month: '2-digit'
    day: '2-digit'
    weekday: 'narrow'
    timezone: 'Europe/Moscow'
    hour: '2-digit'
    minute: '2-digit'
    second: '2-digit'
  
  message.timestr = d.format "dd.mm.yyyy HH:MM"
  return message

@parse = (value)=>
  for key,message of value.chat.messages
    @parseMessage message,value.pupil,value.moderator

  return value
  



