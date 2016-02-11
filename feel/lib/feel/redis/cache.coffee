


class RedisCache
  constructor : ->
    $W @
    @inited = 0
    @cache = {}
    @id = _randomHash()
  init : =>
    return if @inited == 2
    return yield _waitFor @,'init' if @inited == 1
    @inited = 1
    @jobs = yield _Helper 'jobs/main'
    @redis = yield _Helper('redis/main').get()
    yield @jobs.onSignal 'new_redis_cache',@onSignal
    cache = yield _invoke @redis,'hgetall','redis_cache'
    time = new Date().getTime()
    for hash,val of cache
      try @cache[hash] = JSON.parse(val || "{}")
      if (@cache[hash]?.time ? 0) < time
        delete @cache[hash]
        do (hash)=> Q.spawn => yield _invoke @redis,'hdel','redis_cache',hash
    @inited = 2
    @emit 'init'
  onSignal : (id,hash,val)=>
    console.log 'redis cache signal'.grey,hash.grey
    return if id==@id
    @cache[hash] = val
  get : (hash)=>
    yield @init()
    return unless @cache[hash]?.time
    time = new Date().getTime()
    if @cache[hash].time < time
      delete @cache[hash]
      Q.spawn => yield _invoke @redis,'hdel','redis_cache',hash
      return
    return @cache[hash]
  set : (hash,data,time,etag,encoding='gzip')=>
    data = data.toString('hex')
    yield @init()
    ntime = new Date().getTime()+(time*1000)
    val = {data,time:ntime,d:time,encoding,etag}
    @cache[hash] = val
    Q.spawn => yield @jobs.signal 'new_redis_cache',@id,hash,val
    Q.spawn => yield _invoke @redis,'hset','redis_cache',hash,JSON.stringify val


module.exports = RedisCache

