



class @DataM
  constructor : ->
    $W @
    @conf = {}
    @data = {}
    @tutors =
      filters   : {}
      new_filters: {}
      preps     : {0:{}}

  init : =>
    keys = $.localStorage.keys()
    unless Feel.user?.type?.admin then for key in keys
      continue unless m = key.match /tutorInfo_(.*)/
      prep = $.localStorage.get key
      prep.__storage = true
      @tutors.preps[m[1]] = prep if prep?
    unless Feel.user?.type?.admin then for key in keys
      continue unless m = key.match /tutorsFilter_(.*)/
      indexes = $.localStorage.get key
      indexes.__storage = true
      @tutors.filters[m[1]] = indexes if indexes?
    unless Feel.user?.type?.admin then for key in keys
      continue unless m = key.match /tutorsNewFilter_(.*)/
      indexes = $.localStorage.get key
      indexes.__storage = true
      @tutors.new_filters[m[1]] = indexes if indexes?

  loadConf : =>
    @conf = $.localStorage.get 'dataM' ? {}
    @conf.fields  ?= {}
  loadDataM : =>
    @data = {}
    for key,val of @conf.fields
      @data[key] = $.localStorage.get('dataM_'+key) ? {}
    for name,data of @data[key]
      for field,obj of data
        if obj.time? && obj.exp?
          if (obj.time+obj.exp)<(new Date().getTime())
            delete data[field]
            continue
  request : (file,type,params)=>
    hash = objectHash.sha1 {type,params}
  getBids: (from=0,count=10,hash_)=>
    filter = {}
    filter.hash = hash_ ? yield Feel.urlData.filterHash()
    return @tutors.filters[filter.hash].indexes if @tutors?.filters?[filter.hash]?.indexes?
    filter.data = yield Feel.udata.u2d(filter.hash) #yield Feel.urlData.get 'mainFilter'
    filter.data = filter.data?.mainFilter
    exists = Object.keys(@tutors?.preps ? {}) ? []
    ret = yield Feel.root.tree.class.$send 'm:/main/preview/tutors',{filter,from,count,exists},'quiet'
    for key,indexes of (ret.filters ? {})
      @tutors.filters[key] = indexes ? []
    for key,prep of (ret.preps ? {})
      @tutors.preps[key] = prep
    return @tutors.filters?[filter?.hash]?.indexes ? []
  getTutor : (preps)=>
    return {} if preps?[0] == 0
    req = []
    req2 = []
    for p in preps
      if @tutors.preps[p]?
        if @tutors.preps[p].__storage
          req2.push p
          delete @tutors.preps[p].__storage
        continue
      req.push p
    if req.length
      yield @getTutor_(req)
    if req2.length
      @getTutor_(req2).done()
    return @tutors.preps
  getTutor_ : (req)=>
    ret = yield Feel.root.tree.class.$send 'm:/main/preview/tutors',{preps:req},'quiet'
    for key,prep of (ret.preps ? {})
      @tutors.preps[key] = prep
      continue if Feel.user?.type?.admin
      $.localStorage.set 'tutorInfo_'+key,prep if prep?
  getTutors : (from=0,count=10,hash_)=>
    filter = {}
    filter.hash = hash_ ? yield Feel.urlData.filterHash()
    unless @tutors?.filters?[filter.hash]?.indexes?
      yield @getTutors_ filter,from,count
    else if @tutors?.filters?[filter.hash]?.__storage
      delete @tutors?.filters?[filter.hash]?.__storage
      @getTutors_(filter,from,count).done()
    return @tutors.filters?[filter?.hash]?.indexes ? []
  getTutors_ : (filter,from,count)=>
    filter.data = yield Feel.udata.u2d(filter.hash) #yield Feel.urlData.get 'mainFilter'
    filter.data = filter.data?.mainFilter
    exists = Object.keys(@tutors?.preps ? {}) ? []
    ret = yield Feel.root.tree.class.$send 'm:/main/preview/tutors',{filter,from,count,exists},'quiet'
    for key,indexes of (ret.filters ? {})
      @tutors.filters[key] = indexes ? []
      $.localStorage.set 'tutorsFilter_'+key,indexes if indexes?
    for key,prep of (ret.preps ? {})
      @tutors.preps[key] = prep
      continue if Feel.user?.type?.admin
      $.localStorage.set 'tutorInfo_'+key,prep if prep?
  getNewTutors : (from=0,count=10,hash_)=>
    filter = {}
    filter.hash = hash_ ? yield Feel.urlData.filterHash('tutorsFilter')
    unless @tutors?.new_filters?[filter.hash]?.indexes?
      yield @getNewTutors_ filter,from,count
    else if @tutors?.new_filters?[filter.hash]?.__storage
      delete @tutors?.new_filters?[filter.hash]?.__storage
      @getNewTutors_(filter,from,count).done()
    return @tutors.new_filters?[filter?.hash]?.indexes ? []
  getNewTutors_ : (filter,from,count)=>
    filter.data = yield Feel.udata.u2d(filter.hash) #yield Feel.urlData.get 'mainFilter'
    filter.data = filter.data?.tutorsFilter
    exists = Object.keys(@tutors?.preps ? {}) ? []
    ret = yield Feel.root.tree.class.$send 'm:/main/preview/newTutors',{filter,from,count,exists},'quiet'
    for key,indexes of (ret.filters ? {})
      @tutors.new_filters[key] = indexes ? []
      $.localStorage.set 'tutorsNewFilter_'+key,indexes if indexes?
    for key,prep of (ret.preps ? {})
      @tutors.preps[key] = prep
      continue if Feel.user?.type?.admin
      $.localStorage.set 'tutorInfo_'+key,prep if prep?
  getBest : (count)=>
    indexes = (yield @getTutors 0,count,'')?.slice?(0,count) ? []
    arr = yield @getTutor indexes
    preps = []
    for i in indexes
      preps.push arr[i]
    return preps
  getNewBest : (count)=>
    indexes = (yield @getNewTutors 0,count,'')?.slice?(0,count) ? []
    arr = yield @getTutor indexes
    preps = []
    for i in indexes
      preps.push arr[i]
    return preps
  getByFilter : (count,obj={},from=0)=>
    indexes = (yield @getTutors 0,from+count,(yield Feel.udata.d2u('mainFilter',obj)))?.slice?(from,count) ? []
    arr = yield @getTutor indexes
    preps = []
    for i in indexes
      preps.push arr[i]
    return preps
  getByNewFilter : (count,obj={})=>
    indexes = (yield @getNewTutors 0,count,(yield Feel.udata.d2u('tutorsFilter',obj)))?.slice?(0,count) ? []
    arr = yield @getTutor indexes
    preps = []
    for i in indexes
      preps.push arr[i]
    return preps
    




