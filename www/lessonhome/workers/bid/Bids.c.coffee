check = Main.isomorph 'bid/delegate'
class Bids
  status_flags = {
    'current' : true
    'to_pay' : true
    'payed' : true
  }
  need_first = {'name': 1, 'time': 1, 'subject': 1, 'subjects': 1, gender :1, price : 1, prices: 1}
  fields = [
    {
      name: 'price'
      prep: 'float'
    }
    {
      name: 'subjects'
      prep: 'arr:string'
    }
    {
      name : ['name', 'gender', 'email', 'phone', 'index', 'id']
      prep: 'string'
    }
    {
      name : 'moderate'
      prep: 'bool'
    }
    {
      name : 'status'
      prep : 'obj:bool'
    }
  ]
  for_log = [
    {
      name: ['desc', 'index']
      prep: 'string'
    }
  ]
  init: =>
    @db = yield Main.service 'db'
    @bids = yield @db.get 'bids'
    @tutor = yield @db.get 'tutor'
    @jobs = yield Main.service 'jobs'

    yield @jobs.client 'getBids', @jobGetBids
    yield @jobs.listen 'getDetailBid', @jobGetDetailBid
#    yield @jobs.client 'setExecutor', @jobSetExecutor
    yield @jobs.client 'changeBid', @jobChangeBid
    yield @jobs.client 'addLog', @jobAddLog

  _getID : (_id) => new (require('mongodb').ObjectID)(_id)

  jobGetBids : (user) =>
    yield @_validUser user
    $find = {}

    unless user.admin
      $find['moderate'] = true

    return yield _invoke @bids.find($find, need_first), 'toArray'

  jobGetMyBids : (user) =>
    yield @_validUser user
    throw new Error('not tutor') unless user.index
    bids = yield _invoke @bids.find({moderate: true, id: user.index}, need_first), 'toArray'
    return yield @_sortBids bids

  jobGetModerBids : (user) =>
    yield @_validUser user, true
    bids = yield _invoke @bids.find({}, need_first), 'toArray'
    return yield @_sortBids bids

  jobSetExecutor : (user, _id, index) =>
    try
      yield @_validUser user, true

      if index
        tut = yield @jobs.solve 'getTutor', {index}
        # TODO: make check on the test tutor

        if tut
          $get = _id : yield @_getID(_id)
          {result} = yield _invoke @bids, 'update', $get, $set : id : index, {upsert:false}
          console.log result
          throw new Error('wrong _id') unless result.n
          return {status: 'success'}

      throw new Error("Invalid index")
    catch errs
      console.error Exception errs
      return {status: 'failed', err: 'internal error'}

  jobGetDetailBid : (user, _id) =>
    yield @_validUser user
    $get = {_id : yield @_getID(_id)}
    $fields = {}

    unless user.admin
      $get['moderate'] = true
      $fields['phone'] = -1
      $fields['email'] = -1
      $fields['linked'] = -1
      $fields['id'] = -1

    bids = yield _invoke @bids.find($get, $fields), 'toArray'
    bids = bids[0] ? null

    return bids

  _sortBids : (bids) =>
    result = {}
    for b in bids
      key = if b.progress? and status_flags[b.progress]? then b.progress else 'new'
      result[key]?=[]
      result[key].push b
    return result

  getData : (data) =>

  _addLog : (_id, desc) =>
    $get = _id : yield @_getID _id
    {result} = yield _invoke @bids, 'update', $get, '$push' : 'log' : {time : new Date(), desc}
    throw new Error('wrong _id') unless result.nModified

  jobAddLog : (user, params = {}) =>
    try
      yield @_validUser user, true
      params = check.prepare params, for_log
      throw new Error('bad params') unless params?.index? and params.desc?
      yield @_addLog params.index, params.desc
    catch errs
      console.error Exception errs
      return {status: 'failed', err: 'internal error'}

  jobChangeBid : (user, params = {}) =>
    try
      yield @_validUser user, true
      params = check.prepare(params, fields)
      throw new Error('bad params') unless params
      throw new Error('index not exist') unless params?.index?
      $get = _id : yield @_getID(params.index)
      delete params.index
      {result} = yield _invoke @bids, 'update', $get, {$set: params}, {upsert: false}
      throw new Error('wrong _id') unless result.n
      yield @jobs.solve 'flushForm', user.id
      return {status: 'success'}
    catch errs
      console.error Exception errs
      return {status: 'failed', err: 'internal error'}

  _validUser: require "../valid_user"

module.exports = Bids