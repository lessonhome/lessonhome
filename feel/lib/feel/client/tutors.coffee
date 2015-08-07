

class @Tutors
  constructor : ->
    Wrap @
    @sending = 0
    @tutors = $.localStorage.get 'tutors'
    @tutors ?= {}
    @itutors  = {}
    @indexes = {}
    @itutors[val.index] = val for key,val of @tutors
    @tutorsCache = {}
    
  #update : (persons)=>
  #  return unless persons && (typeof persons=='object')
  request :  (o={})=>
    if o == 'reload' then o = @o
    else @o = {prep:o.prep,count:o.count,form:o.from}

    hash = yield Feel.urlData.filterHash o
    return if @tutorsCache[hash] == true
    o.hash = hash
    @sending = 2 if @sending == 1
    return _waitFor @,'request' if @sending > 1

    console.log 'loading tutors'
    {tutors,indexes} = yield @$send '/main/preview/tutors',o,'quiet'
    if indexes
      for key,val of indexes
        @indexes[key] = val
    storage = $.localStorage.get 'tutors'
    storage ?= {}
    tutors  ?= []
    for val in tutors
      val.receive = new Date().getTime()
      storage[val.account] = val
    @itutors = {}
    for key,val of storage
      unless val.receive && (val.index>0)
        delete storage[key]
        continue
      if (new Date().getTime()-val.receive)>1000*60*5
        delete storage[key]
        continue
      @itutors[val.index] = val
      @tutorCache[''+val.index] = true
    $.localStorage.set 'tutors',storage
    @tutors = storage
    @tutorsCache[hash] = true

    if @sending == 2
      @sending = 0
      return @request 'reload'
    @sending = 0
    @emit 'request'
  
