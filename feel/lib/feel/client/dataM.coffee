



class @DataM
  constructor : ->
    Wrap @
    @conf = {}
    @data = {}
    @tutors =
      filters  : {}
      preps    : {}
  init : =>
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
  getTutor : (preps)=>
    req = []
    for p in preps
      continue if @tutors.preps[p]?
      req.push p
    return @tutors.preps unless req.length

    ret = yield Feel.root.tree.class.$send 'm:/main/preview/tutors',{preps:req}
    for key,prep of (ret.preps ? {})
      @tutors.preps[key] = prep
    return @tutors.preps
  getTutors : (from=0,count=10)=>
    filter = {}
    filter.hash = yield Feel.urlData.filterHash()
    return @tutors.filters[filter.hash].indexes if @tutors?.filters?[filter.hash]?.indexes?
    filter.data = yield Feel.urlData.get 'mainFilter'

    exists = Object.keys(@tutors?.preps ? {}) ? []
    ret = yield Feel.root.tree.class.$send 'm:/main/preview/tutors',{filter,from,count,exists}
    for key,indexes of (ret.filters ? {})
      @tutors.filters[key] = indexes ? []
    for key,prep of (ret.preps ? {})
      @tutors.preps[key] = prep
    return @tutors.filters?[filter?.hash]?.indexes ? []
 
    
