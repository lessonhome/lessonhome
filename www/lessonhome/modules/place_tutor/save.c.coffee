
arr = ["country", "city", "area", "street", "house", "building", "flat", "metro"]


@handler = ($,data)=>
  console.log data
  return {status:"failed",errs:["access_failed"]} unless $.user.tutor
  #if errs.length
    #return {status:'failed',errs:errs}
  update = {}
  boo = false
  for el in arr
    if data?[el]?
      update["location."+el] = data[el]
      boo = true
  if boo
    db= yield $.db.get 'persons'
    yield _invoke db, 'update',{account:$.user.id},{$set:update},{upsert:true}
    #yield _invoke db, 'update',{account:$.user.id},{$set:{location: {country:data.country, city:data.city, area:data.area, street:data.street, house:data.house, building:data.building, flat:data.flat, metro:data.metro} }},{upsert:true}
    yield $.form.flush '*',$.req,$.res
  return {status:'success'}
