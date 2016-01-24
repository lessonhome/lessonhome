
_filter = require './filter.c'
_reload = require './reload.c'


class Tutors
  constructor : ->
    $W @
    @timereload = 0
    @inited = 0
  init : =>
    return _waitFor @,'inited' if @inited == 1
    return if @inited > 1
    @jobs = yield Main.service 'jobs'
    @jobs.listen 'filterTutors',@jobFilterTutors
    @jobs.listen 'getTutor',@jobGetTutor
    @jobs.listen 'getTutorsOnMain',@jobGetTutorsOnMain
    @redis = yield Main.service('redis')
    @redis = yield @redis.get()
    @inited = 1
    @urldata = yield Main.service 'urldata'
    @dbtutor = yield @$db.get 'tutor'
    @dbpersons = yield @$db.get 'persons'
    @dbaccounts = yield @$db.get 'accounts'
    @dbuploaded = yield @$db.get 'uploaded'
    @onmain = {}
    try
      @persons = JSON.parse yield _invoke @redis, 'get', 'persons'
      for key,val of (@persons ? {})
        @index?= {}
        @index[val.index] = val
        @onmain ?= {}
        @onmain[val.index]=true if val.onmain
      @filters = JSON.parse yield _invoke @redis, 'get', 'filters'
    catch e
      console.error e
    finally
      unless @persons? && @index? && @filters?
        @persons ?= {}
        @index   ?= {}
        @onmain   ?= {}
        @filters ?= {}
        yield @reload()
        @inited = 2
        @emit 'inited'
      else
        @inited = 2
        @emit 'inited'
        Q.spawn =>
          yield @reload()
    setInterval =>
      Q.spawn => yield @reload()
    , 15*60*1000
    setInterval =>
      Q.spawn => yield @writeFilters()
    , 2*60*1000
  writeFilters  : =>
    return unless @filterChange
    @filterChange = false
    yield _invoke @redis, 'set','filters',JSON.stringify @filters

  refilterRedis : =>
    return if @refiltering
    @refiltering = true
    time = @refilterTime = new Date().getTime()
    filters = for f,o of (@filters ? {}) then [f,(o.num ? 0)]
    filters = filters.sort (a,b)-> b[1]-a[1]
    for f,i in filters
      f = f[0]
      o = @filters[f]
      continue unless o.redis
      unless (o.num > 1) || (i<50)
        break
      unless (o.num > 2) || (i<120)
        break
      continue unless o?.data?
      t_ = new Date().getTime()
      yield @filter {hash:f,data:o.data}
      nt_ = new Date().getTime()
      console.log "refilter #{i}/#{filters.length} #{nt_-t_} #{o.num}".grey
      return @refiltering = false if time < @refilterTime
      yield Q.delay (nt_-t_)
    filters = filters.slice i
    for f,i in filters
      f = f[0]
      delete @filters[f]
    return @refiltering = false
  jobFilterTutors : ({filter,preps,from,count,exists})->
    return @handler {},{filter,preps,from,count,exists}
  jobGetTutor : ({index})=>
    return @index?[index] ? (@index?[99637] ? {})
  jobGetTutorsOnMain : (num)=>

    arr2 = Object.keys (@onmain ? {})
    arr = []
    for i in [1..num]
      break unless arr2.length
      ind = arr2.splice(Math.floor(Math.random()*arr2.length),1)?[0]
      ind = @index?[ind] ? null
      arr.push ind if @index
    return arr
  handler : ($, {filter,preps,from,count,exists})->
    exists?=[]
    yield @init() unless @inited == 2
    ret = {}
    ret.preps = {}
    if preps?
      for p in preps
        ret.preps[p] = @index[p]
    if filter?
      ex = {}
      ex[k] = true for k in exists
      ret.filters = {}
      f = ret.filters[filter.hash] = {}
      unless @filters?[filter.hash]?.indexes?
        yield @filter filter,true
      else
        @filters?[filter.hash]?.num++
      f.indexes = @filters?[filter.hash]?.indexes ? []
      count ?= 10
      if from?
        inds = f?.indexes?.slice? from,from+count
        for i in inds
          ret.preps[i] = @index[i] unless ex[i]
    return ret
  filter : (filter,inc = false)=>
    f = @filters[filter.hash] ? {}
    f.data  = filter.data
    f.num   ?= 0
    f.num++ if inc
    delete f.redis

    f.indexes = yield _filter.filter @persons,filter.data
    @filters[filter.hash] = f
    @filterChange = true
    return f
    
  reload : =>$W( _reload.reload).apply @



tutors = new Tutors
module.exports = tutors
