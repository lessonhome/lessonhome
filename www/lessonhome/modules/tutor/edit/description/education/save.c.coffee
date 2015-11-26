
check = require("./check")

@handler = ($,data)=>
  return unless $.user.tutor
  db= yield $.db.get 'persons'
  unless data?.length?
    return (yield _invoke db.find({account:$.user.id},{education:1}),'toArray')?[0]?.education ? []

  errors = check.check data
  return {status: 'failed', errs: errors} if errors.correct is false
  
  result = []
  for el in data
    educ = {}
    educ['name'] = el['name']
    educ['faculty'] = el['faculty']
    educ['country'] = el['country']
    educ['city'] = el['city']
    educ['chair'] = el['chair']
    educ['qualification'] = el['qualification']
    educ['comment'] = el['comment']
    educ['period'] = {}
    educ['period']['start'] = el['period']['start']
    educ['period']['end'] = el['period']['end']
    result.push educ
    
  yield _invoke db,'update',{account:$.user.id},{$set:education:result},{upsert:true}


  #persons = yield _invoke db.find({account:$.user.id},{education:1}), 'toArray'
  #education = persons?[0]?.education ? []

  #for key, value of data
  #  education[key] = value

  #yield _invoke db, 'update',{account:$.user.id},{$set: {education: education}},{upsert:true}

  yield $.status 'tutor_prereg_5', true
  yield $.form.flush '*',$.req,$.res
  return {status:'success'}
