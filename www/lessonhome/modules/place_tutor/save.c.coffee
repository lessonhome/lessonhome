
@handler = ($,data)=>
  console.log data
  return {status:"failed",errs:["access_failed"]} unless $.user.tutor
  #if errs.length
    #return {status:'failed',errs:errs}

  db= yield $.db.get 'persons'
  yield _invoke db, 'update',{account:$.user.id},{$set:{location: {country:data.country, city:data.city, area:data.area, street:data.street, house:data.house, building:data.building, flat:data.flat, metro:data.metro} }},{upsert:true}
  yield $.form.flush ['person'],$.req,$.res
  return {status:'success'}
