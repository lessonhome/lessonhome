


@handler = ($,direction,index,indata)=>
  console.log $.user.admin
  return {status:'failed'} unless $.user.admin
  pdb = yield $.db.get 'persons'
  adb = yield $.db.get 'accounts'
  account = (yield _invoke adb.find({index:index},{id:1}),'toArray')?[0]?.id ? 0
  switch direction
    when 'up','down'
      console.log account
      ratio = 1.3 if direction == 'up'
      ratio = 0.76 if direction == 'down'
      yield _invoke pdb,'update',{account:account},{$set:{ratio:ratio}}
    when 'ratio'
      ratio = indata
      yield _invoke pdb,'update',{account:account},{$set:{ratio:ratio}}
    when 'landing'
      yield _invoke pdb,'update',{account:account},{$set:{landing:indata}}
    when 'filtration'
      yield _invoke pdb,'update',{account:account},{$set:{filtration:indata}}
    when 'mcomment'
      yield _invoke pdb,'update',{account:account},{$set:{mcomment:indata}}
  return {status:'success'}



