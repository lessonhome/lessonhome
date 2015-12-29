




module.exports = (id)->
  account = _invoke @dbAccounts .find id:id     ,'toArray'
  person  = _invoke @dbPersons  .find account:id,'toArray'
  tutor   = _invoke @dbTutor    .find account:id,'toArray'
  [account,person,tutor] = yield Q.all [account,person,tutor]
  
  


