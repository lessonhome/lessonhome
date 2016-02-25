
check = require("./check")

os = require 'os'
hostname = os.hostname()

@handler = ($,data)=>
  errs = check.check data
  #return {status:'failed'} unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'backcall'
  objtoset = {
    name    : data.your_name
    phone   : data.tel_number
    comment : data.comments
    type    : data.type
    account : $.user.id
    time    : new Date()
  }

  yield _invoke db, 'update',{account:$.user.id},{$set:objtoset},{upsert:true}
  Q.spawn => @sendSms objtoset,$.user.admin
  #yield $.status 'tutor_prereg_2',true
  #yield $.form.flush ['tutor','person','account'],$.req,$.res
  return {status:'success'}

_phones = [
  '79254688208'
  '79152292244'
  '79267952303'
  '79651818071'
]
checkHistAdd = (m)=> do Q.async =>
  m = m.replace(/повторная заявка/gmi,'').replace(/заявка/gmi,'')
  redis = yield _Helper('redis/main').get()
  ret = yield _invoke redis,'sadd','sms-history',m
  return ret>0


@sendSms = (o,isadmin)->
  #return if isadmin || !_production

  text = "Обратный звонок\n"
  text += "#{o.name}\n" if o.name
  text += "#{o.phone}\n" if o.phone
  text += "#{o.comment}\n" if o.comment
  text += "#{o.type}\n" if o.type
  #return unless yield checkHistAdd text

  @jobs = yield Main.service 'jobs'
  messages = []
  for phone in _phones
    messages.push
      phone:phone
      text :text
  yield @jobs.solve 'telegramSendAll',text
  #yield @jobs.solve 'sendSms',messages


