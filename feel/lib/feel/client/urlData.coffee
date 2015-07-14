
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
    @data   = yield @udata.u2d @state?.url?.match(/\?(.*)$/)?[1]
    @fdata  = yield @udata.u2d fstate?.url?.match(/\?(.*)$/)?[1]
    for key of @forms
      @data[key] ?= {}
      @fdata[key] ?= {}
  set : (form,key,val)=>
    if val?
      _setKey @data[form],key,val
    else if key?
      @data[form] = key
    else
      for key,val of form
        @data[key] = val
    yield @setUrl()
  get : (form,key)=>
    return @data unless form?
    return @data[form] unless key?
    return _setKey @data[form],key
  getF : (form,key)=>
    return @fdata unless form?
    return @fdata?[form] unless key?
    return _setKey @fdata?[form],key
  getU : => @udata.d2u @data
  udataToUrl : (url=window.location)=>
    obj = {url}
    urldata = yield @getU()
    if urldata
      urldata = "?#{urldata}"
    else
      urldata = ""
    obj.url = obj.url.replace /\?.*$/g,""
    obj.url += urldata
    return obj.url
  setUrl : =>
    url = yield @udata.d2u @data
    @data = yield @udata.u2d url
    nurl = url
    nurl = '?'+nurl if nurl
    mnurl = @state.url.match(/^([^\?]*)/)[1]+"#{nurl}"
    return if mnurl == @state.url
    History.replaceState  @data,(@state.title || $('head>title').text()),mnurl
    @state = History.getState()
    @emit 'change'
    #data = @state.url.match /\?(.*)$/
    #@data = yield @udata.u2d data
    #for key of @forms
    #  @data[key] ?= {}

    
