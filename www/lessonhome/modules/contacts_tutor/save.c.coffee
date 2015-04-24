
check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = check.check data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:{phone: [data.mobile_phone, data.extra_phone], email:[data.post], social_networks: {skype:[data.skype]}, site:[data.site], location: {country:data.country, city:data.city}  }},{upsert:true}
  yield $.status 'tutor_prereg_2',true
  return {status:'success'}


