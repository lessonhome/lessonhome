
fstate = History.getState()


class @urlData
  constructor : ->
    console.log 'urlData.constructor()'
    Wrap @
    @_hash    = ""
    @_long    = {}
    @_short   = {}
    @urljson  = {}
    @forms    = {}
    @data     = {}
    @fdata    = {}
  init : =>
    console.log 'urlData.init()'
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
    cook = $.cookie('urldata') ? ''
    cook = decodeURIComponent cook
    cook = '{}' unless cook
    cook = JSON.parse cook
    cook ?= {}
    for u in url2
      continue unless u
      u = u.split '='
      url[u[0]] = u[1]
    url[key] ?= val for key,val of cook
    str = ''
    for key,val of url
      str += '&' if str
      str += key if key
      str += '='+val if val?
    console.log {str}
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
    console.log 'get',form,key
    return @data unless form?
    return @data[form] unless key?
    return _setKey @data[form],key
  getF : (form,key)=>
    return @fdata unless form?
    return @fdata?[form] unless key?
    return _setKey @fdata?[form],key
  getU : =>
    console.log "getU",arguments
    #@state  = History.getState()
    #@data   = yield @udata.u2d @state?.url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    get = yield @get()
    console.log 'getU...get',get
    d2u = yield @udata.d2u get
    console.log 'getU...d2u',d2u
    return d2u
  udataToUrl : (url=window.location.href,...,usecookie='true',skip='not')=>
    console.log "udataToUrl",arguments
    console.log 'url',url
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
    console.log urldata
    purl = urldata.split '&'
    for p in purl
      np = p.split '='
      params[np[0]] = np[1]
    console.log params
    urldata = ""
    purl = []
    if usecookie == 'true'
      cook = $.cookie('urldata') ? ''
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
      $.cookie 'urldata', encodeURIComponent( JSON.stringify cook), {path:'/'}
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
    @emit 'change'
    #@data = yield @udata.u2d url?.match?(/^[^\?]*\??(.*)$/)?[1] ? ""
    #data = @state.url.match /\?(.*)$/
    #for key of @forms
    #  @data[key] ?= {}

    
