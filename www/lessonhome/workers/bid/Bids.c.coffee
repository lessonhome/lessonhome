class Bids
  status_flags = {
    'current' : true
    'to_pay' : true
    'payed' : true
  }
  init: =>
    @db = yield Main.service 'db'
    @bids = yield @db.get 'bids'
    @jobs = yield Main.service 'jobs'
    yield @jobs.listen 'getBids', @jobGetBids

  jobGetBids : (user) =>
    yield @_validUser user
    $find = {}

    unless user.admin
      $find['moderate'] = true

    return yield _invoke @bids.find($find), 'toArray'

  jobChangeBids : (user, data) =>
    yield @_validUser user, true

  jobGetMyBids : (user) =>
    yield @_validUser user
    bids = yield _invoke @bids.find({moderate: true, app_tutor: user.id}), 'toArray'
    return yield @_sortBids bids

  jobGetModerBids : (user) =>
    yield @_validUser user, true
    bids = yield _invoke @bids.find({}), 'toArray'
    return yield @_sortBids bids

  _getLinked : (bids) =>
    l = bids.linked ? []
    linked = if bids.id? and l.indexOf(bids.id) < 0 then [bids.id] else []
    linked.push(index) for index in l
    return linked

  _sortBids : (bids) =>
    result = {}
    for b in bids
      key = if b.progress? and status_flags[b.progress]? then b.progress else 'new'
      result[key]?=[]
      result[key].push b
    return result

  _validUser: require "../valid_user"

module.exports = Bids