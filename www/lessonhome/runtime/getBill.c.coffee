


@handler = ($, data)->

  db = yield Main.service 'db'
  billsDb = yield db.get 'bills'

  switch data.action
    when 'get_balance'
      try
        bills = yield _invoke billsDb.find({id: $.user.id}),'toArray'

      catch err
        console.log 'err',err
        err.err ?= 'internal_error'
        return {status:'failed',err:err.err}

      return {
        status:'success'
        balance: bills[0].value
      }
    when 'pay'
      console.log data
    when 'refill'
      try
        yield _invoke(billsDb,'update', {id:$.user.id},{$inc:{value: 1000}},{upsert:true})
        bills = yield _invoke billsDb.find({id: $.user.id}),'toArray'
      catch err
        console.log 'err',err
        err.err ?= 'internal_error'
        return {status:'failed',err:err.err}

      return {
        status:'success'
        balance: bills[0].value
      }