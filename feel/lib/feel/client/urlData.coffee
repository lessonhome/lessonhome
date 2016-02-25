
fstate = History.getState()



class @urlData
  constructor : ->
    $W @
    @_hash    = ""
    @_long    = {}
    @_short   = {}
    @urljson  = {}
    @forms    = {}
    @data     = {}
    @fdata    = {}
    @id       = ""+Math.random()
    @lastUpdate = new Date().getTime()
    @first = true
  init : =>
    @json = Feel.urldataJson
    for fname,form of Feel.urlforms
      @forms[fname] = {}
      @forms[fname].U2D = $W (new form.U2D) if form.U2D?
      @forms[fname].D2U = $W (new form.D2U) if form.D2U?
    for key of @forms
      @data[key] ?= {}
    Feel.udata = new Feel.UrlDataFunctions
    @udata = Feel.udata
    yield @udata.init @json,@forms
    yield @initFromUrl(true)
    setTimeout =>
      try console.log 'abTest:',@udata.json?.forms?.abTest
    ,1000
    Q.spawn =>
      yield Q.delay 100
      time = $.localStorage.get('UrlCookieTime')
      unless time?
        $.localStorage.set('UrlCookieTime',@lastUpdate)
        $.localStorage.set('UrlCookieId',@id)
      else if time > @lastUpdate
        console.log @lastUpdate,$.localStorage.get('UrlCookieTime'),@id,$.localStorage.get('UrlCookieId')
        return if $.localStorage.get('UrlCookieId') == @id
        @readCookie = true
        return if @readingCookie > 1
        if @readingCookie == 1
          @readingCookie = 2
        else
          @readingCookie = 1
        console.log 'ok'
        #yield @loadCookie()
        while @readingCookie == 1
          @lastUpdate = new Date().getTime()
          yield @initFromUrl()
          yield @setUrl()
          @readingCookie--
        yield Q.delay 2000
        if (@readingCookie == 0) && (((new Date().getTime())-@lastUpdate)>2000)
          @readCookie = false
        return
    @first = false

  initFromUrl : (first=false)=>
    @state  = History.getState()
    url = @state?.url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    url2 = url.split '&'
    url = {}
    cook = $.cookie()?.urldata ? ''
    cook = decodeURIComponent cook
    cook = '{}' unless cook
    cook = JSON.parse cook
    if !@readCookie
      @lastUpdate = new Date().getTime()
    cook ?= {}
    for u in url2
      continue unless u
      u = u.split '='
      if @first || !@udata.json.shorts?[u?[0]]?.cookie
        url[u[0]] = u[1]
    for key,val of cook
      url[key] = val
    str = ''
    for key,val of url
      str += '&' if str
      str += key if key
      str += '='+val if val?
    @data   = yield @udata.u2d str ? ''
    if first
      @fdata  = yield @udata.u2d str ? '' #fstate?.url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    for key of @forms
      @data[key] ?= {}
      @fdata[key] ?= {} if first
  loadCookie : =>
    cook = $.cookie()?.urldata ? ''
    cook = decodeURIComponent cook
    cook = '{}' unless cook
    cook = JSON.parse cook
    cook ?= {}
    if !@readCookie
      @lastUpdate = new Date().getTime()
    url = {}
    for key,val of cook
      url[key] = val
    str = (yield @getU()) || ""
    for key,val of url
      str += '&' if str
      str += key if key
    @data = yield @udata.u2d str || ''
  set : (form,key,val)=>
    #yield @initFromUrl()
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
  get : (form,key,...,reload)=>
    #yield @loadCookie() if reload == 'reload'
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
  udataToUrl : (url,...,usecookie='true',skip='not',remove=false)=>
    params = {}
    firstu  = (window.location.href || "").match?(/^[^\?]*\??(.*)$/)?[1] ? ""
    secondu = yield @getU()
    thirdu  = (url || "").match?(/^[^\?]*\??(.*)$/)?[1] ? ""
    if false
      purl = firstu.split '&'
      for p in purl
        np = p.split '='
        if @first || !@udata.json.shorts?[np?[0]]?.cookie
          params[np[0]] = np[1]
    purl = secondu.split '&'
    for p in purl
      np = p.split '='
      params[np[0]] = np[1]
    
    if url
      purl = thirdu.split '&'
      for p in purl
        np = p.split '='
        if @first || !@udata.json.shorts?[np?[0]]?.cookie
          params[np[0]] = np[1]
          if skip=='skip'
            if @udata.json.shorts[np[0]]?
              delete params[np[0]]
    unless url?
      url = window.location.href
      url ?= ""

    obj = {url}
    urldata = ""
    purl = []
    if !@readCookie
      @lastUpdate = new Date().getTime()
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
      oldCookie = $.cookie 'urldata'
      newCookie = encodeURIComponent JSON.stringify cook
      if (oldCookie != newCookie) && (!@readCookie)
        if @lastUpdate > $.localStorage.get('UrlCookieTime')
          $.cookie 'urldata', newCookie
          $.localStorage.set 'UrlCookieTime',@lastUpdate
          $.localStorage.set 'UrlCookieId',  @id
    for key,val of params
      if remove && @udata.json.shorts?[key]?.cookie
        console.log key,val
        continue
      purl.push [key,val]
    purl.sort (a,b)-> a[0] < b[0]
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
  filterHash : (o={},field='filter')=>
    if typeof o == 'string'
      field = o
      o = {}
    hash = ''
    o.url ?= History.getState().url
    hash += (yield @filter o.url,field) ? ''
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
    url = History.getState().url
    return if url == @lastEmitUrl
    @lastEmitUrl = url
    @emit 'change'
