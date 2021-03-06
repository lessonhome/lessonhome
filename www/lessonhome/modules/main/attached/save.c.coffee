
check = require("./check")

os = require 'os'
hostname = os.hostname()

phones = [
  '79254688208'
  '79152292244'
  '79267952303'
  '79263672997'
  '79651818071'
]
checkHistAdd = (m)=> do Q.async =>
  m = m.replace(/повторная заявка/gmi,'').replace(/заявка/gmi,'')
  redis = yield _Helper('redis/main').get()
  ret = yield _invoke redis,'sadd','sms-history',m
  return ret>0


other = ($,data,second)-> do Q.async =>
  sms = yield Main.service 'sms'
  @jobs ?= yield _Helper 'jobs/main'
  text = ''
  if data.id > 0
    text += 'заявка(сообщение преподу)\n'
  else if second
    text += 'повторная заявка\n'
  else text += 'заявка\n'
  text += data?.name || ''
  text += '\n' unless !text || (text.substr(-1)=='\n')
  text += data.subject || ''
  text += '\n' unless !text || (text.substr(-1)=='\n')
  text += data.phone || ''
  text += '\n' unless !text || (text.substr(-1)=='\n')
  text += data.email || ''
  text += '\n' unless !text || (text.substr(-1)=='\n')
  if data.linked?
    for key,val of data.linked
      text += 'https://lessonhome.ru/tutor?x='+key+"\n"
  if data.id
    text += 'to: https://lessonhome.ru/tutor?x='+data.id+"\n"
  text += data.comments || ''
  text += '\n' unless !text || (text.substr(-1)=='\n')
  text += data.comment || ''
  text += '\n' unless !text || (text.substr(-1)=='\n')
  #return console.log text if $.user.admin || !_production
  #return unless yield checkHistAdd text
  messages = []
  for p in phones
    messages.push
      phone :p
      text : text
  yield @jobs.solve 'telegramSendAll',text
  #console.log yield sms.send messages
 

@handler = ($,data)=>
  data = check.takeData data
  #  return {status:'success'} unless data.phone
  errs = [] #check.check data
  if errs['phone']? then return {status:'failed', errs}
  if errs.correct is false then data = {phone: data['phone']}
  data.account = $.user.id
  data['phone'] = data['phone'].replace /^\+7/, '8'
  data['phone'] = data['phone'].replace /[^\d]/g, ''
  data['time'] = new Date()
  console.log 'save bid'
  db = yield $.db.get 'bids'
  saved = yield _invoke db.find({$or:[{account:$.user.id},{phone:data.phone}]}),'toArray'
  if data.id>0
    yield _invoke db,'insert',data
  else
    yield _invoke db,'update',{account:$.user.id},{$set:data},{upsert:true}
  other.call(@,$,data,second=(saved[0]?)).done()
  return {status:'success'}
