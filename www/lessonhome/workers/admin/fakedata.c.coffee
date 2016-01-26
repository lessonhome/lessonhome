class FakeData
  constructor : ->
    $W @
  init : =>

    @jobs = yield Main.service 'jobs'

    yield @jobs.listen 'getFakeTutors',@jobGetFakeTutors
    yield @jobs.listen 'getFakeBids',@jobGetFakeBids
    setInterval => Q.spawn =>
      yield @jobs.signal 'fakeTutorsChange'
      yield @jobs.signal 'fakeBidsChange'
    ,100000
  jobGetFakeTutors : =>
    return [
      {
        name: 'some',
        phone: '123',
        photo: 'link/'
      }
    ]

  jobGetFakeBids : => []


module.exports = new FakeData