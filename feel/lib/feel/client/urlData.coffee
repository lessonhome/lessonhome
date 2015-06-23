class @urlData
  constructor : ->
    Wrap @
    @_hash = ""
    @_long  = {}
    @_short = {}
    @urljson = {}
    @forms   = {}
  init : =>
    @json = Feel.urldataJson
    for fname,form of Feel.urlforms
      @forms[fname] = {}
      @forms[fname].U2D = Wrap new form.U2D if form.U2D?
      @forms[fname].D2U = Wrap new form.D2U if form.D2U?
    Feel.udata = new Feel.UrlDataFunctions
    @udata = Feel.udata
    yield @udata.init @json,@forms

    @state = History.getState()
    udata = @state.url.match /\?(.*)$/
    if udata
      udata = udata.split '&'
      arr = {}
      for el in udata
        el = el.split '='
        arr[el[0]] = el[1] ? true if el[0]
    if arr.s
      @_short = yield @getDataByHash arr.s
    delete arr.s
    @_long = arr
  Short : (key,val)=>
    return @_short       unless key?
    return @_short[key]  unless val?
    @_short[key] = val
    console.log key,val
    yield @setDataByHash @_short
    yield @setUrl()
    return val

  Long  : (key,val)=>

  getDataByHash : (hash)=>
    data = $.localStorage.get hash
    return data

  setDataByHash  : (data)=>
    data = JSON.stringify data
    switch data
      when '','undefined','null','{}','[]','""'
        @_hash = ""
      else
        data = JSON.parse data
        hash = objectHash(data,{encoding: 'base64'}).substr(0,8)
        @_hash = hash
        $.localStorage.set hash,data
  setUrl : =>
    url = ""
    url += "s=#{@_hash}" if @_hash
    keys = Object.keys @_long
    keys.sort()
    for k in keys
      v = @_long[k]
      continue unless v?
      url += "&" if url
      url += k
      url += "=#{v}" unless v == true
    History.pushState  {_hash:@_hash,_long:@_long,_short:@_short},@state.title,@state.url.match(/^([^\?]*)/)[1]+"?#{url}"
    @state = History.getState()

    
