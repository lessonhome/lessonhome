
crypto  = require 'crypto'
_cookies = require 'cookies'
rand  = (num)-> crypto.createHash('sha1').update(num).digest('hex').substr 0,10
get_ip = require('ipware')().get_ip
useragent = require('useragent')
class RouteState
  constructor : (@statename,@req,@res,@site)->
    @time()
    @rand = "1"
    @reqHash =
      url     : @req.url
      session : @req.session
    sha1 = require('crypto').createHash('sha1')
    sha1.update JSON.stringify @reqHash
    @reqHash = sha1.digest('hex')
    @reqEtag = @req.headers['if-none-match']
    @o =
      res : @res
      req : @req
    @time "constr"
  time : (str="")=>
    if !@_time?
      @_time = new Date().getTime()
    else
      t = new Date().getTime()
      console.log "time: #{t-@_time}ms ".grey+str.red,(new Date().getTime()-@req.time)
      @_time = t
  getField : (obj,field)->
    a = field?.split? '.'
    a ?= [null]
    obj = obj?[f] for f in a
    return obj
  getTopNode : (node,force=false)=>
    return node if node?._isModule
    return node if node.__gotted
    node.__gotted = true
    return node unless node.__state?.parent?
    p = @getTopNode node.__state.parent.tree
    if force
      o = node
    else
      o = {}
      for key,val of node
        o[key] = val if key.match /^_.*/
    #o._smart = true
    for key,val of o
      delete o[key] unless key.match /^_.*/
    for key,val of p
      o[key] ?= val
    #return @getTopNode node.__state.parent.tree
    #
    #else
    #  return node
    return o
  getTop : (node)=>
    return @top if @top?
    node ?= @state
    if node.parent?
      return @getTop node.parent
    else
      return @top = node.tree
  getTree : (top)=>
    return if top.__inner
    top.__inner = true
    tree = {}
    for key,val of top
      if val && (typeof val == 'function' || typeof val == 'object') && !val._smart
        tree[key] = @getTree val
      else
        tree[key] = val
    delete tree.__inner
    delete top.__inner
    return tree
  walk_tree_down : (node,pnode,key,foo)=>
    if node && (typeof node == 'object' || typeof node == 'function') && !node?._smart
      foo node,pnode,key
      for key,val of node
        @walk_tree_down node[key],node,key,foo
  go : => do Q.async =>
    @res.on 'finish', =>
      agent = ""
      ip = get_ip(@req)?.clientIp
      ip?= ""
      ua = useragent.parse @req.headers['user-agent']
      ua.family ?= ""
      ua.major  ?= ""
      ua.minor  ?= ""
      host = @req?.headers?.host
      host ?= ""
      console.log process.pid+":time".yellow+"\t#{new Date().getTime() - @req.time}ms".cyan+
        " #{host}#{@req.url}:#{ip}:#{ua.family}:#{ua.major}:#{ua.minor}".grey
    sclass = @site.state[@statename].class
    sclass::access ?= []
    sclass::access = sclass::access() if typeof sclass::access =='function'
    sclass::access ?= []
    if typeof sclass::access == 'string'
      sclass::access = [sclass::access]
    if sclass::access.length
      s = {}
      for el in sclass::access
        s[el] = true
      sclass::access = s
    sclass::redirect ?= {}
    access = false
    for key,val of @req.user.type
      continue unless val
      if sclass::access[key]
        access = true
        break
    unless access
      for key,val of sclass::redirect
        if @req.user.type[key]
          return @redirect @req,@res,val
      if sclass::redirect.default
        return @redirect @req,@res,sclass::redirect.default
      return @redirect @req,@res,'/403'
    if sclass::status?
      qs = []
      for key,val of sclass::status
        neg  = false
        name = key
        if name.match /^\!/
          neg = true
          name = name.substr 1
        do (key,val,neg,name)=>
          qs.push @req.status(name).then (status)=>
            if typeof val == 'string'
              val = {
                value     : true
                redirect  : val
              }
            unless neg
              if status == val.value
                return redirect:val.redirect
            else
              if status != val.value
                return redirect:val.redirect
      arr = yield Q.all qs
      for el in arr
        if el?.redirect?
          return @redirect @req,@res,el.redirect
    @time "go s"
    @state = yield @site.state[@statename].make(null,null,@req,@res)
    @time 'make'
    @tags = {}
    @$forms = {}
    #@access   = {}
    #@redirect = {}
    @getTop()
    qforms = []

    @walk_tree_down @top,@,'top',(node,pnode,key)=>
      if node._isState
        if node.__states
          o = node.__states
        else
          o = {}
          o[node._statename] = node.__state
        for sn,s of o
          if s.forms?
            if typeof s.forms == 'function'
              s.forms = s.forms()
            if typeof s.forms == 'string'
              s.forms = [s.forms]
            for f in s.forms
              fname = f
              fields = undefined
              if typeof f == 'object'
                fname   = Object.keys(f)[0]
                fields  = f[fname]
                if typeof fields == 'string'
                  fields = [fields]
              #unless @$forms[f]
              @$forms[fname] ?= {}
              boo = false
              if fields then for field in fields
                boo = true
                @$forms[fname][field] = true
              @$forms[fname].__all = true unless boo
              #  @$forms[f] ?= @site.form.get f,@req,@res
              #  do (f)=>
              #    qforms.push @$forms[f].then (data)=>
              #      @$forms[f] = data
          for k of s.tag
            @tags[k] = true
          #for a in s.access
          #  @access[a] = true
          #for k,v of s.redirect
          #  @redirect[k] = v
        for sn,s of o
          s.page_tags = @tags
        #node = pnode[key] = @getTopOfNode node
    @time 'walk tree'
    for form,fields of @$forms
      do (form,fields)=> qforms.push do Q.async =>
        unless fields?.__all
          fields = Object.keys fields
          fields = undefined unless fields?.length > 0
        else
          fields = undefined
        @$forms[form] = yield @site.form.get form,@req,@res,fields
    if @top._isState
      if @top.__states
        o = @top.__states
      else
        o = {}
        o[node._statename] = @top.__state
      for sn,s of o
        s.page_tags = @tags
    @modules    = {}
    @modulesExt = {}
    @css      = ""
    @jsModules = ""
    @jsClient = Feel.clientJs
    @stack = []
    yield Q.all qforms
    @time 'forms get'
    
    @walk_tree_down @top,@,'top',(node,pnode,key)=>
      do =>
        return unless node?._isModule
        return unless node.$form && (typeof node.$form == 'object')
        fname = Object.keys(node.$form)?[0]
        return console.error "bad form"+_inspect(node.$form) unless fname && @$forms[fname]?
        field = node.$form[fname]
        place = 'value'
        func = undefined
        if typeof field == 'object'
          t = Object.keys(field)[0]
          if typeof field[t] == 'function'
            func = field[t]
            field = t
          else
            place = field[t]
            field = t
            if typeof place == 'object'
              t = Object.keys(place)[0]
              func = place[t] if typeof place[t] == 'function'
              place = t
        delete node.$form
        node[place] = @getField @$forms[fname],field
        node[place] = func? node[place] if func
      do =>
        for k,val of node
          continue if val?._isModule
          continue unless typeof val == 'object'
          continue unless val
          continue unless val.$form
          continue unless typeof val.$form == 'object'
          fname = Object.keys(val.$form)?[0]
          unless fname && @$forms[fname]?
            console.error "bad form"+_inspect(val.$form)
            continue
          field = val.$form[fname]
          place = 'value'
          func = undefined
          boo = false
          if typeof field == 'object'
            t = Object.keys(field)[0]
            if typeof field[t] == 'function'
              func = field[t]
              field = t
            else
              boo = true
              place = field[t]
              field = t
              if typeof place == 'object'
                t = Object.keys(place)[0]
                func = place[t] if typeof place[t] == 'function'
                place = t
          delete node[k]
          unless boo
            node[k] = @getField @$forms[fname],field
            node[k] = func? node[k] if func
          else
            node[place] = @getField @$forms[fname],field
            node[place] = func? node[place] if func
    @time 'forms set'
    @parse @top,null,@top,@top,@,'top'
    if @site.modules['default'].allCss && !@modules['default']?
      @cssModule 'default'
    for modname of @modules
      if @site.modules[modname].allCss
        @cssModule modname
    for modname,val of @modulesExt
      @cssModuleExt modname,val
      for key of val
        @modules[key] = true
    #for modname of @modules
    #  if @site.modules[modname]?.allCoffee
    #    @jsModules += "$Feel.modules['#{modname}'] = #{@site.modules[modname].allCoffee};"
    @time 'parse'
    title   = @state.title
    title  ?= @statename
    end  = ""
    end += '<!DOCTYPE html><html><head><meta charset="utf-8">'
    end += '<meta name="viewport" content="width=device-width">'
    end += '<title>'+title+'</title>'
    end += '<link rel="shortcut icon" href="'+Feel.static.F(@site.name,'favicon.ico')+'" />'
    end += @css+'</head><body>'+@top._html
    @removeHtml @top
    @time "remove html"
    json_tree = _toJson(@getTree(@top))
    @time "stringify"
    end +=
      "<script>
      'use strict';
      window.StopIteration = undefined;
      #{Feel.clientRegenerator}</script>"+
      @site.moduleJsTag('lib/jquery')+
      @site.moduleJsTag('lib/jquery/plugins')+
      @site.moduleJsTag('lib/q')+
      @site.moduleJsTag('lib/event_emitter')+
      @site.moduleJsTag('lib/jade')+
      '
      <script id="feel-js-client">
      "use strict";
      '+('
          window.EE = EventEmitter;
          var $Feel = {}; 
          $Feel.root = {
              "tree" : InfiniteJSON.parse(decodeURIComponent("'+encodeURIComponent(json_tree)+'"))
          };
          $Feel.modules = {};
          (function(){
            '+@jsClient+'
            
            }).call($Feel); ')+'
      </script>'+
      '<script id="feed-js-modules">
      "use strict";
          console.log("Feel",$Feel); 
      '+@jsModules+'</script>'
    for modname of @modules
      if @site.modules[modname]?.allCoffee
        end += "<script>window._FEEL_that = $Feel.modules['#{modname}'] = {};</script>"
        names =  @site.modules[modname].jsNames()
        for n in names
          end += @site.moduleJsFileTag modname,n
    end +=  '<script id="feel-js-startFeel">
      "use strict";
      Feel.init();</script>'+
      '</body></html>'
    @time "end str finish"
    sha1 = require('crypto').createHash('sha1')
    sha1.update end
    resHash = sha1.digest('hex').substr 0,8
    @time "create hash"
    if resHash == @reqEtag
      @res.writeHead 304
      console.log "state #{@statename}",304
      return @res.end()

    zlib    = require 'zlib'
    zlib.deflate end,{level:9},(err,resdata)=>
      if err?
        @res.writeHead 404
        return @res.end err
      @time 'zlib'
      @res.setHeader 'Access-Control-Allow-Origin', '*'
      @res.setHeader 'Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE'
      @res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type'
      @res.setHeader 'Access-Control-Allow-Credentials', true
      @res.setHeader 'ETag',resHash
      @res.setHeader 'Cache-Control', 'public, max-age=1'
      @res.setHeader 'content-encoding', 'deflate'
      @res.setHeader 'content-length',resdata.length
      @res.statusCode = 200
      d = new Date()
      d.setTime d.getTime()+1
      @res.setHeader 'Expires',d.toGMTString()
      @res.end resdata
      console.log process.pid+":state #{@statename}",200,resdata.length/1024,end.length/1024,Math.ceil((resdata.length/end.length)*100)+"%"
  removeHtml : (node)=>
    if node.req?
      delete node.req
    if node.res?
      delete node.res

    return if node?._smart
    for key,val of node
      if key == '_html'
        delete node[key]
      else if typeof val == 'object' && val
        @removeHtml val
  cssModule : (modname)=>
    @css += "<style id=\"f-css-#{modname}\">#{@site.modules[modname].allCss}</style>"
  cssModuleExt    : (modname,exts)=>
    css = @site.modules[modname].getAllCssExt exts
    @css += "<style id=\"f-css-#{modname}-exts\">#{css}</style>"
  parse : (now,uniq,module,state,_pnode,_pkey)=>
    #return if now.__parsed
    if now?.__state?.parent?.tree?
      @getTopNode now, true
      #_pnode[_pkey] = now
    new_module = module
    new_state  = state
    if now._isModule
      uniq = @rand = rand(@rand) #Math.floor Math.random()*10000
      now._uniq?= uniq
      uniq = now._uniq
      m = now._name.match /^\/\/(.*)$/
      if m
        unless @stack.length
          throw new Error "can't find parent module for // in modname '#{now._name}' 
                            in state '#{@statename}'"
        now._name = @stack[@stack.length-1]+"/#{m[1]}"
      @stack.push now._name
    for key,val of now
      if val && typeof val == 'object' && !val._smart
        if val.__state?
          new_state = val
        else
          new_state = state
        if val._isModule
          new_module = val
        else
          new_module = module
        #console.log val
        #now.__parsed = true
        @parse val,uniq,new_module,new_state,now,key
        #delete now.__parsed
    if now._isModule
      @modules[now._name] = true
      if now._extends_modules.length
        @modulesExt[now._name] ?= {}
        for ext in now._extends_modules
          @modulesExt[now._name][ext] = true
      o = @getO now,uniq
      if !@site.modules[now._name]?
        throw new Error "can't find module '#{now._name}' in state '#{@statename}'"
      now._html = @site.modules[now._name].doJade o,@,state.__state
      ms = now._html.match /js-\w+--{{UNIQ}}/mg
      now._domregx = {}
      if ms then for m in ms
        m = m.match(/js-(\w+)--/)[1]
        now._domregx[m] = true
      now._html = now._html.replace /{{UNIQ}}/mg,uniq
      @stack.pop()

  getO  : (obj,uniq)=>
    ret = {}
    for key,val of obj
      ret[key] = val
      if val && typeof val == 'object' && !val._smart
        #if val.__getO
        #  delete obj[key]
        #  delete ret[key]
        #else
        #val.__getO = true
        ret[key] = @getO val,uniq
        #delete val.__getO
      if ret[key]?._isModule
        ret[key]._uniq?= @rand = rand(@rand)#Math.floorMath.random()*10000
        html = ""
        if ret[key]._html?
          idn = ret[key]._name.replace /\//g, '-'
          ret[key] = ret[key]._html.replace "m-#{idn}", "m-#{idn}\" uniq=\"#{uniq}:#{ret[key]._uniq}\" class=\"m-#{uniq}-#{idn}"
    return ret
  redirect : (req,res,val)=>
    if @site.state[val]?
      val = @site.state[val].class::route
    unless val
      val = '/403'
    res.statusCode = 301
    res.setHeader 'location', val
    res.setHeader 'Cache-Control','no-cache'
    res.end()

module.exports = RouteState


