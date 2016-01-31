
check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = check.check data
  #return {status:'failed'} unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}
  db= yield $.db.get 'backcall'
  objtoset = {
    name    : check.getText(data.your_name)
    phone   : check.getPhone(data.tel_number)
    comment : check.getText(data.comments)
    type    : check.getText(data.type)
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

@sendSms = (o,isadmin)->
  return if isadmin || !_production

  text = "Обратный звонок\n"
  text += "#{o.name}\n" if o.name
  text += "#{o.phone}\n" if o.phone
  text += "#{o.comment}\n" if o.comment
  text += "#{o.type}\n" if o.type

  @jobs = yield Main.service 'jobs'
  messages = []
  for phone in _phones
    messages.push
      phone:phone
      text :text
  yield @jobs.solve 'sendSms',messages

