
fstate = History.getState()



class @urlData
  constructor : ->
    Wrap @
    @_hash    = ""
    @_long    = {}
    @_short   = {}
    @urljson  = {}
    @forms    = {}
    @data     = {}
    @fdata    = {}
  init : =>
    @json = Feel.urldataJson
    for fname,form of Feel.urlforms
      @forms[fname] = {}
      @forms[fname].U2D = Wrap (new form.U2D) if form.U2D?
      @forms[fname].D2U = Wrap (new form.D2U) if form.D2U?
    for key of @forms
      @data[key] ?= {}
    Feel.udata = new Feel.UrlDataFunctions
    @udata = Feel.udata
    yield @udata.init @json,@forms

    @state  = History.getState()
    url = @state?.url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    url2 = url.split '&'
    url = {}
    cook = $.cookie()?.urldata ? ''
    cook = decodeURIComponent cook
    cook = '{}' unless cook
    cook = JSON.parse cook
    cook ?= {}
    for u in url2
      continue unless u
      u = u.split '='
      url[u[0]] = u[1]
    url[key] = val for key,val of cook
    str = ''
    for key,val of url
      str += '&' if str
      str += key if key
      str += '='+val if val?
    @data   = yield @udata.u2d str ? ''
    @fdata  = yield @udata.u2d str ? '' #fstate?.url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    for key of @forms
      @data[key] ?= {}
      @fdata[key] ?= {}
    setTimeout =>
      try
        console.log 'abTest:',@udata.json?.forms?.abTest
    ,1000
  set : (form,key,val)=>
    if val?
      _setKey @data[form],key,val
    else if key?
      for k,v of key
        _setKey @data[form],k,v
      #@data[form] = key
    else
      for k,v of form
        for a,b of v
          _setKey @data[k],a,b
        #@data[key] = val
    yield @setUrl()
  get : (form,key)=>
    return @data unless form?
    return @data[form] unless key?
    return _setKey @data[form],key
  getF : (form,key)=>
    return @fdata unless form?
    return @fdata?[form] unless key?
    return _setKey @fdata?[form],key
  getU : =>
    #@state  = History.getState()
    #@data   = yield @udata.u2d @state?.url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    get = yield @get()
    d2u = yield @udata.d2u get
    return d2u
  toObject : (url)=>
    url = '' unless typeof url == 'string'
    url = url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    url = url.split '&'
    ret = {}
    for u in url
      u = u?.split? '=' ? []
      ret[u[0]]=u[1] if u[0]?
    return ret
  filter : (obj,field,value=true)=>
    string = false
    if typeof obj == 'string'
      obj = yield @toObject obj
      string = true
    ret = {}
    for key,val of obj
      ret[key] = val if @udata.json?.shorts?[key]?[field]==value
    return @objectTo ret if string
    return ret
  objectTo : (obj)=>
    obj = {} unless obj && typeof obj=='object'
    ret = []
    ret.push [key,val] for key,val of obj
    ret.sort (a,b)-> a?[0] < b?[0]
    str = ''
    for r in ret
      continue unless r[0]
      str += '&' if str
      str += r[0]
      str += "="+r[1] if r[1]?
    return str
        

  udataToUrl : (url=window.location.href,...,usecookie='true',skip='not')=>
    params = {}
    unless typeof url == 'string'
      url = window.location.href
      url ?= ""
    purl = url?.match?(/^[^\?]*\??(.*)$/)?[1] ? ""
    purl = purl.split '&'
    for p in purl
      np = p.split '='
      params[np[0]] = np[1]
      if skip=='skip'
        if @udata.json.shorts[np[0]]?
          delete params[np[0]]
    obj = {url}
    urldata = (yield @getU()) ? ""
    purl = urldata.split '&'
    for p in purl
      np = p.split '='
      params[np[0]] = np[1]
    urldata = ""
    purl = []
    if usecookie == 'true'
      cook = $.cookie()?.urldata ? ''
      cook = decodeURIComponent cook
      cook = '{}' unless cook
      cook = JSON.parse cook
      cook ?= {}
      for key,val of @udata.json.shorts
        if val?.cookie
          unless params?[key]?
            delete cook?[key]
          else
            cook[key] = params?[key]
      $.cookie 'urldata', encodeURIComponent( JSON.stringify cook)
    for key,val of params
      purl.push [key,val]
    purl.sort (a,b)-> a[0]<b[0]
    for p in purl
      urldata += '&' if urldata && p[0]
      urldata += p[0] if p[0]
      urldata += '='+p[1] if p[1]? && p[0]
      #if p[0]? && @udata.json.shorts?[p?[0]]?.cookie
      #  cook[p[0]] = p[1]
      #else
    if urldata
      urldata = "?#{urldata}"
    else
      urldata = ""
    obj.url = obj.url.replace /\?.*$/g,""
    obj.url += urldata
    return obj.url
  setUrl : =>
    url = yield @udataToUrl(undefined,'true','skip')
    url = url.replace /^(.*\:\/\/[^\/]*)/, ''
    #url = yield @udata.d2u @data
    #@data = yield @udata.u2d url
    #nurl = url
    #nurl = '?'+nurl if nurl
    @state = History.getState()
    #mnurl = @state.url.match(/^([^\?]*)/)[1]+"#{nurl}"
    return if url == @state.url
    History.replaceState  @data,(@state.title || $('head>title').text()),url
    @state = History.getState()
    @emitChange()
    #@data = yield @udata.u2d url?.match?(/^[^\?]*\??(.*)$/)?[1] ? ""
    #data = @state.url.match /\?(.*)$/
    #for key of @forms
    #  @data[key] ?= {}
  filterHash : (o={})=>
    hash = ''
    o.url ?= History.getState().url
    hash += (yield @filter o.url,'filter') ? ''
    console.log 'urlData.filterHash', hash
    return hash
  ###
  emitChange : =>
    @lastChange ?= 0
    @waitingForChange ?= false
    now = new Date().getTime()
    unless @waitingForChange
      @waitingForChange = true
      time = 100
      if (now-@lastChange)<1000
        time = 1100-(now-@lastChange)
      return setTimeout @_emitChange,time
  _emitChange : =>
    @lastChange = new Date().getTime()
    @waitingForChange = false
    @emit 'change'
  ###
  emitChange : =>
    @lastChange = new Date().getTime()
    setTimeout @_emitChange,200
  _emitChange : =>
    return if (!@lastChange) || (((new Date().getTime())-@lastChange)<200)
    @lastChange = 0
    @emit 'change'
