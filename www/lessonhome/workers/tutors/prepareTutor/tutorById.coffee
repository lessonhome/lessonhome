module.exports = (indexes) =>
  indexes = [indexes] unless indexes instanceof Array
  data = yield @_getById indexes, ['account', 'tutor', 'person', 'uploaded']
  for d in data
    d = @prepare d
    id = d.account?.id

    if id
      yield _invoke @accounts, 'update', {id}, {$set: d.account}, {$upset: true}
      yield _invoke @persons, 'update', {account: id}, {$set: d.person}, {$upset: true}
      yield _invoke @tutors, 'update', {account: id}, {$set: d.tutor}, {$upset: true}
