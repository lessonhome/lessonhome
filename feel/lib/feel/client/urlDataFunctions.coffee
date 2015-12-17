


class @UrlDataFunctions
  constructor : ->
    $W @
  init : (@json,@forms)=>
  d2o : (fname,data)=>
    form = @forms[fname]
    throw new Error "bad urlform #{fname}" unless form?.D2U?
    ret = []
    for key,foo of form.D2U
      continue unless m = key.match /^\$(.*)$/
      field = yield foo data
      field.key = m[1]
      field.fname = fname
      #continue unless field.value?
      switch field.type
        when 'int'
          field.value = +field.value
          continue unless field.value || (field.value==0)
          field.value = Math.floor field.value
          continue if field.value == field.default
        when 'bool'
          field.value = field.value == true
          def = field.default
          def = def == true
          continue if field.value == def
          field.value = true
        when 'string'
          continue unless field.value
          field.value = ''+field.value
          continue unless typeof field.value == 'string'
          continue if field.value == field.default
          field.value = encodeURIComponent field.value
        when 'string[]'
          continue unless field.value && (typeof field.value == 'object')
          s = ''
          for key,v of field.value
            s += '~' if s
            s += ''+v
          field.value = encodeURIComponent s
          continue if field.value == field.default
        when 'obj'
          continue unless field.value?
          try
            field.value = encodeURIComponent JSON.stringify field.value
            def = encodeURIComponent JSON.stringify field.def
          catch e
            continue
          continue unless field.value
          continue if field.value == def
        else
          throw new Error "wrong type in field #{field.key} in urlform #{fname}"
      ret.push field
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
    url = "" unless url && (typeof url == 'string')
    url = url.replace /^.*\?/gmi,''
    fields = url.split '&'
    udata = {}
    ffields = {}
    for f in fields
      f = f.split('=')
      field = @json.shorts?[f?[0]]
      continue unless field?.field
      continue unless @forms?[field?.form]?.D2U?['$'+field?.field]?
      value = f[1] ? true
      ffields[field?.form]?= {}
      ffields[field?.form][field?.field] = value

    for fname of @forms
      for key of @forms[fname].D2U
        continue unless m = key.match /^\$(.*)$/
        continue unless m[1]
        field = m[1]
        o = @json.shorts?[@json?.forms?[fname]?[field]]
        continue unless o.default?
        unless ffields?[fname]?[field]?
          ffields[fname] ?= {}
          if o.type == 'bool'
            ffields[fname][field] = false
          else
            ffields[fname][field] = o.default
    for fname,fform of ffields then for field,value of fform
      #for f in fields
      #f = f.split('=')
      #field = @json.shorts?[f?[0]]
      #continue unless field?.field
      f = [@json?.forms?[fname]?[field],value]
      field = @json.shorts?[f?[0]]
      continue unless field?.field
      type  = field.type ? 'string'
      form  = field.form
      def   = field.default
      field = field.field
      continue unless @forms?[form]?.D2U?['$'+field]?
      value = f[1] ? true
      switch type
        when 'int'
          value = +value
          value = def unless value == 0 || value
        when 'string'
          try
            value = decodeURIComponent value
            value = ''+value
          catch e
            value = def
          value = def unless typeof value == 'string'
          value = '' unless typeof value == 'string'
        when 'string[]'
          try
            value = decodeURIComponent value
            value = value.split '~'
            value.shift() if value?[0] == ''
          catch e
            value = []
          value = def unless value && typeof value == 'object'
          value = []  unless typeof value == 'object'
        when 'obj'
          try
            value = JSON.parse decodeURIComponent value
          catch e
            value = def
          value = def unless typeof value == 'object'
          value = undefined unless typeof value == 'object'
        when 'bool'
          value = value == true
          if def == true
            value = !value
        else
          continue
      #continue if JSON.stringify value == JSON.stringify def
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


