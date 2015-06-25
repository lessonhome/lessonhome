


class @UrlDataFunctions
  constructor : ->
    Wrap @
  init : (@json,@forms)=>
    #console.log @json,@forms
  d2o : (fname,data)=>
    #console.log 'd2o',fname,data
    form = @forms[fname]
    throw new Error "bad urlform #{fname}" unless form?.D2U?
    ret = []
    for key,foo of form.D2U
      continue unless m = key.match /^\$(.*)$/
      field = yield foo data
      field.key = m[1]
      field.fname = fname
      continue unless field.value?
      switch field.type
        when 'int'
          field.value = +field.value
          continue unless field.value || (field.value==0)
          field.value = Math.floor field.value
        when 'bool'
          continue unless field.value
          field.value = true
        when 'string'
          continue unless filed.value
          field.value = ''+field.value
          continue unless typeof field.value == 'string'
          field.value = encodeURIComponent field.value
        when 'obj'
          try
            field.value = encodeURIComponent JSON.stringify field.value
          catch e
            continue
          continue unless field.value
        else
          throw new Error "wrong type in field #{field.key} in urlform #{fname}"
      ret.push field
    #console.log 'd2o',ret
    return ret
  d2u : (fname,data)=>
    return "" unless fname && ((typeof data == 'object')||(typeof fname=='object'))
    if data
      o = {}
      o[fname] = data
      data = o
    else
      data = fname
    ret = []
    for fname,obj of data
      ret = ret.concat yield @d2o(fname,obj)
    ret.sort (a,b)-> a.key<b.key
    url = ''
    for f in ret
      url +=  '&' if url
      key = @json.forms?[f.fname]?[f.key]
      throw new Error "bad field #{f.key}:#{key} in form #{f.fname}" unless key
      url +=  key
      url +=  '='+f.value unless f.value == true
    return url
  u2d : (url)=>
    return {} unless url && (typeof url == 'string')
    console.log url
    fields = url.split '&'
    udata = {}
    for f in fields
      f = f.split('=')
      field = @json.shorts?[f?[0]]
      continue unless field?.field
      type  = field.type ? 'string'
      form  = field.form
      field = field.field
      continue unless @forms?[form]?.D2U?['$'+field]?
      value = f[1] ? true
      switch type
        when 'int'
          value = +value
          value = undefined unless value == 0 || value
        when 'string'
          try
            value = decodeURIComponent value
            value = ''+value
          catch e
            value = ''
          value = '' unless typeof value == 'string'
        when 'obj'
          try
            value = JSON.parse decodeURIComponent value
          catch e
            value = undefined
          value = undefined unless typeof value == 'object'
        when 'bool'
          value = value == true
        else
          continue
      udata[form] ?= {}
      udata[form][field] = value
    data = {}
    for fname,obj of udata
      data[fname] ?= {}
      for key,foo of @forms[fname].U2D
        continue unless m = key.match /^\$(.*)$/
        continue unless m[1]
        data[fname][m[1]] = yield foo obj
    return data


