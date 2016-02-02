module.exports = (indexes) =>
  indexes = [indexes] unless indexes instanceof Array
  data = yield @_getById indexes, ['account', 'tutor', 'person', 'uploaded']
  for d in data
    d = @prepare d
    id = d.account?.id
    yield @saveData(d) if id
