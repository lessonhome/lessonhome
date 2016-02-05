


class Core
  init : =>
    @std = {}
    @redis = yield _Helper('redis/main').get()
    @redis_cache = {}
  run  : =>
    
  loadStd : =>

  
  compileCoffeeDir : (dir)=>
    # _readdirp 
    cache = yield cache
  loadRedisCache : (name)=>
    return @redis_cache[name] if @redis_cache[name] == undefined
    if @redis_cache[name] == 'loading'
      yield _waitFor @,'redis_cache_'+name
      return @redis_cache[name]
    @redis_cache[name] = 'loading'
    red = yield _invoke @redis,'hgetall','redis_cache_'+name
    red ?= []
    @redis_cache[name] = {}
    for i in [0...red.length] by 2
      @redis_cache.coffee[red[i]] = JSON.parse(red[i+1] ? "{}") ? {}
    return @redis_cache[name]



module.exports = Core


