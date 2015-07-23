
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
    @data   = yield @udata.u2d @state?.url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    @fdata  = yield @udata.u2d fstate?.url?.match(/^[^\?]*\??(.*)$/)?[1] ? ''
    for key of @forms
      @data[key] ?= {}
      @fdata[key] ?= {}
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
    @udata.d2u yield @get()
  udataToUrl : (url=window.location.href,...,skip='not')=>
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
    for key,val of params
      purl.push [key,val]
    purl.sort (a,b)-> a[0]<b[0]
    for p in purl
      urldata += '&' if urldata && p[0]
      urldata += p[0] if p[0]
      urldata += '='+p[1] if p[1]? && p[0]
    if urldata
      urldata = "?#{urldata}"
    else
      urldata = ""
    obj.url = obj.url.replace /\?.*$/g,""
    obj.url += urldata
    return obj.url
  setUrl : =>
    url = yield @udataToUrl(undefined,'skip')
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

    
