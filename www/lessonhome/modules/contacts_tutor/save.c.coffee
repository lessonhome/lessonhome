
arr = ["country", "city"]
check = require("./check")

@handler = ($,data)=>
  console.log data
  errs = check.check data
  return unless $.user.tutor
  if errs.length
    return {status:'failed',errs:errs}

  update = {}
  boo = false
  for el in arr
    if data?[el]?
      update["location."+el] = data[el]
      boo = true
  if boo
    db= yield $.db.get 'persons'
    yield _invoke db, 'update',{account:$.user.id},{$set:update},{upsert:true}
    yield _invoke db, 'update',{account:$.user.id},{$set:{phone: [data.mobile_phone, data.extra_phone], email:[data.post], social_networks: {skype:[data.skype]}}},{upsert:true}

    #yield _invoke db, 'update',{account:$.user.id},{$set:{location: {country:data.country, city:data.city, area:data.area, street:data.street, house:data.house, building:data.building, flat:data.flat, metro:data.metro} }},{upsert:true}
    #yield $.form.flush ['person'],$.req,$.res
  yield $.status 'tutor_prereg_2',true
  yield $.form.flush ['person','account'],$.req,$.res

  #yield _invoke db, 'update',{account:$.user.id},{$set:{phone: [data.mobile_phone, data.extra_phone], email:[data.post], social_networks: {skype:[data.skype]}, location: {country:data.country, city:data.city}  }},{upsert:true}
  #yield $.status 'tutor_prereg_2',true
  #yield $.form.flush ['person','account'],$.req,$.res
  return {status:'success'}


