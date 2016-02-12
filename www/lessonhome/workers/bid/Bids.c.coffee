class Bids
  status_flags = {
    'current' : true
    'to_pay' : true
    'payed' : true
  }
  need_first = {'name': 1, 'time': 1, 'subject': 1, 'subjects': 1}
  init: =>
    @db = yield Main.service 'db'
    @bids = yield @db.get 'bids'
    @jobs = yield Main.service 'jobs'
    yield @jobs.client 'getBids', @jobGetBids
    yield @jobs.listen 'getDetailBid', @jobGetDetailBid
#    yield @jobs.listen 'getBids', @jobGetBids

  jobGetBids : (user) =>
    yield @_validUser user
    $find = {}

    unless user.admin
      $find['moderate'] = true

    return yield _invoke @bids.find($find, need_first), 'toArray'

  jobChangeBids : (user, data) =>
    yield @_validUser user, true

  jobGetMyBids : (user) =>
    yield @_validUser user
    bids = yield _invoke @bids.find({moderate: true, app_tutor: user.id}, need_first), 'toArray'
    return yield @_sortBids bids

  jobGetModerBids : (user) =>
    yield @_validUser user, true
    bids = yield _invoke @bids.find({}, need_first), 'toArray'
    return yield @_sortBids bids

  jobGetDetailBid : (user, _id) =>
    yield @_validUser user
    $get = {_id : new (require('mongodb').ObjectID)(_id)}
    $fields = {}

    unless user.admin
      $get['moderate'] = true
      $fields['phone'] = -1
      $fields['email'] = -1
      $fields['linked'] = -1
      $fields['id'] = -1

    bids = yield _invoke @bids.find($get, $fields), 'toArray'
    bids = bids[0] ? null

#    if bids and user.admin
#      bids.linked_detail = yield @_getLinked(bids)

    return bids

#  _getLinked : (bids) =>
#    linked = {}
#
#    for own index of (bids.linked ? {})
#      linked[index] = yield @_getTutor index
#
#    index = bids.id
#
#    if index? and !linked[index]?
#      linked[index] = yield @_getTutor index
#
#    return linked

#  _getTutor : (index) => yield @jobs.solve 'getTutor', {index}

  _sortBids : (bids) =>
    result = {}
    for b in bids
      key = if b.progress? and status_flags[b.progress]? then b.progress else 'new'
      result[key]?=[]
      result[key].push b
    return result

  _validUser: require "../valid_user"

module.exports = Bids