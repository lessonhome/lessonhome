
crypto  = require 'crypto'
_cookies = require 'cookies'
rand  = (num)-> crypto.createHash('sha1').update(num).digest('hex').substr 0,10
get_ip = require('ipware')().get_ip
useragent = require('useragent')

urldataLinks = ""

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

  getMaxAge : (req,res)=>
    sess = req.uniqHash.split(':')[0]
    if @statename.match /^tutor\//
      return 10
    return 10*60
  time : (str="")=>
    if !@_time?
      @_time = new Date().getTime()
    else
      t = new Date().getTime()
      #console.log "time: #{t-@_time}ms ".grey+str.red,(new Date().getTime()-@req.time)
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
    @req.user ?= {}
    @req.user.type ?= {other: true}
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
    if sclass::access['all']
      access = true

    unless access || @req.user.admin
      _setKey @req.udata,'accessRedirect.redirect',@req.url
      for key,val of sclass::redirect
        if @req.user?.type?[key]?
          return @redirect @req,@res,val
      if sclass::redirect.default
        return @redirect @req,@res,sclass::redirect.default
      return Feel.res403 @req,@res #@redirect @req,@res,'/403'
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
    @$urlforms = []
    @$durlforms = []
    @w8defer = []
    @walk_tree_down @top,@,'top',(node,pnode,key)=>
      return unless node["$defer"]
      deffoo = node["$defer"]
      delete pnode[key]
      @w8defer.push do Q.async =>
        pnode[key] = yield $W(deffoo)()
    yield Q.all @w8defer
    _custom = {}
    @walk_tree_down @top,@,'top',(node,pnode,key)=>
      do =>
        return unless node?._isModule
        return unless node?.value?
        _objRelativeKey node?.value,'$urlform',(obj,part,fkf)=>
          #node.$urlforms ?= {}
          #node.$urlforms[part] = fkf
          uform = {node,part,fkf}
          vv = _setKey @req?.udata?[uform?.fkf?.form],uform?.fkf?.key
          vv = uform.fkf.foo vv if typeof uform.fkf.foo == 'function'
          vd = _setKey @req?.udatadefault?[uform?.fkf?.form],uform?.fkf?.key
          vd = uform.fkf.foo vd if typeof uform.fkf.foo == 'function'
          vv ?= vd
          uform.node.$urlforms ?= {}
          uform.node.$urlforms[uform.part] = uform.fkf
          path = 'value'
          path += "."+uform.part if uform.part
          _setKey uform.node,path,vv,true
          if vd?
            path = 'default'
            path += "."+uform.part if uform.part
            _setKey uform.node,path,vd,true
        _objRelativeKey node?.value,'$durlform',(obj,part,fkf)=>
          uform = {node,part,fkf}
          vv = _setKey @req?.udata?[uform?.fkf?.form],uform?.fkf?.key
          vv = uform.fkf.foo vv if typeof uform.fkf.foo == 'function'
          vd = _setKey @req?.udatadefault?[uform?.fkf?.form],uform?.fkf?.key
          vd = uform.fkf.foo vd if typeof uform.fkf.foo == 'function'
          vd ?= vv
          vv = vd
          uform.node.$durlforms ?= {}
          uform.node.$durlforms[uform.part] = uform.fkf
          path = 'value'
          path += "."+uform.part if uform.part
          _setKey uform.node,path,vv,true
          if vd?
            path = 'default'
            path += "."+uform.part if uform.part
            _setKey uform.node,path,vd,true
      do =>
        return unless node?._isModule
        if node?.default?
          unless typeof node.default == 'object'
            node.value ?= node.default
            return
          for key,val of node.default
            v = _setKey node.value,key
            _setKey node.value, key,val unless v?
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
      do =>
        for k,val of node
          if m = k.match /^_custom_(.+)/
            _custom[m[1]] = val
    for uform in @$urlforms
      vv = _setKey @req?.udata?[uform?.fkf?.form],uform?.fkf?.key
      uform.node.$urlforms ?= {}
      uform.node.$urlforms[uform.part] = uform.fkf
      vv = uform.fkf.foo vv if typeof uform.fkf.foo == 'function'
      path = 'value'
      path += "."+uform.part if uform.part
      _setKey uform.node,path,vv,true
      if uform.fkf.default?
        path = 'default'
        path += "."+uform.part if uform.part
        _setKey uform.node,path,uform.fkf.default,true
    for uform in @$durlforms
      vv = _setKey @req?.udata?[uform?.fkf?.form],uform?.fkf?.key
      uform.node.$urlforms ?= {}
      uform.node.$urlforms[uform.part] = uform.fkf
      vv = uform.fkf.foo vv if typeof uform.fkf.foo == 'function'
      path = 'value'
      path += "."+uform.part if uform.part
      if uform.fkf.default?
        _setKey uform.node,path,uform.fkf.default,true
        path = 'default'
        path += "."+uform.part if uform.part
        _setKey uform.node,path,uform.fkf.default,true
    @time 'forms set'
    yield @parse @top,null,@top,@top,@,'top'
    if @site.modules['default'].allCss && !@modules['default']? && (!@state.page_tags['skip:default'])
      @cssModule 'default'
    for modname of @modules
      if @site.modules[modname].allCss && (!@state.page_tags['skip:'+modname])
        @cssModule modname
    for modname,val of @modulesExt
      if @site.modules[modname].allCss && (!@state.page_tags['skip:'+modname])
        yield @cssModuleExt modname,val
      for key of val
        @modules[key] = true
    #for modname of @modules
    #  if @site.modules[modname]?.allCoffee
    #    @jsModules += "$Feel.modules['#{modname}'] = #{@site.modules[modname].allCoffee};"
    @time 'parse'
    title   = @state.title
    title  ?= @statename
    end  = ""
    end += '<!DOCTYPE html><html><head>'
    if _custom.title
      end += '<title>'+_custom.title+'</title>'
    else
      end += '<title>'+title+'</title>'
    if _custom.description
      end += "<meta name='description' content='#{_custom.description}'>"
    end += '<link rel="shortcut icon" href="'+Feel.static.F(@site.name,'favicon.ico')+'" />'
    end += @site.router.head
    end += _custom.head if _custom.head
    end += @css+'</head><body>'
    end += @top._html
    end += @site.router.body
    @removeHtml @top
    @time "remove html"
    json_tree = @getTree @top
    try
      json_ = JSON.stringify json_tree
    catch e
      json_ = "InfiniteJSON.parse(decodeURIComponent('#{encodeURIComponent _toJson json_tree}'))"
    json_tree = json_
    @time "stringify"
    end +=
      "<script>
      'use strict';
      window.StopIteration = undefined;</script>
      <script type='text/javascript' src='/jsclient/#{Feel.clientRegeneratorHash}/regenerator'></script>"
    end+=
      @addModuleJs('lib/jquery')+
      @addModuleJs('lib/jquery/plugins')+
      @addModuleJs('lib/q')+
      @addModuleJs('lib/event_emitter')+
      @addModuleJs('lib/jade')+
      @addModuleJs('lib/lodash')+
      @addModuleJs('lib/object_hash')
      #@site.moduleJsTag('lib/materialize')+
    end +=
      '
      <script id="feel-js-client">
      "use strict";
      '+('
          window.EE = EventEmitter;
          var $Feel = {};
          $Feel.version = "'+Feel.version+'";
          $Feel.oldversion = $.localStorage.get("coreVersion");
          if ($Feel.oldversion != $Feel.version)
          {
            $.localStorage.removeAll();
            $.localStorage.set("coreVersion",$Feel.version);
          }
          $Feel.root = {
              "tree" : '+json_tree+ #InfiniteJSON.parse(decodeURIComponent("'+encodeURIComponent(json_tree)+'"))
          '};
          $Feel.constJson = '+@site.constJson+';
          $Feel.user = {};
          $Feel.servicesIp = '+@site.servicesIp+';
          $Feel.user.id = "'+(@req.user.id||666)+'";
          $Feel.user.type = '+JSON.stringify(@req.user.type ? {})+';
          $Feel.user.sessionpart = "'+(@req.session.substr(0,8))+'";
          $Feel.modules = {};
          $Feel.urlforms = {};')+
      '</script>'+
      "<script type='text/javascript' src='/jsclient/#{Feel.clientJsHash}/client'></script>"+
      '<script id="feed-js-modules">
      "use strict";
          console.log("Feel",$Feel); 
      '+@jsModules+'</script>'
    end += @site.urldataFilesStr
    for modname of @modules
      continue if @state.page_tags['skip:'+modname]
      if @site.modules[modname]?.allCoffee
        end += "<script>window._FEEL_that = $Feel.modules['#{modname}'] = {};</script>"
        names =  @site.modules[modname].jsNames()
        for n in names
          end += @site.moduleJsFileTag modname,n
    end +=  '<script id="feel-js-startFeel">
      "use strict";
      Feel.init().done();</script>'+
     ' </body></html>'
    @time "end str finish"
    sha1 = require('crypto').createHash('sha1')
    sha1.update end
    resHash = sha1.digest('hex').substr 0,8
    @time "create hash"
    _sent = false
    if resHash == @reqEtag
      @res.statusCode = 304
      _sent = true
      #  console.log "state #{@statename}",304
      @res.end()
    unless _sent
      _max_age = @getMaxAge @req,@res
      @res.setHeader 'Access-Control-Allow-Origin', '*'
      @res.setHeader 'Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE'
      @res.setHeader 'Access-Control-Allow-Headers', 'X-Requested-With,content-type'
      @res.setHeader 'Access-Control-Allow-Credentials', true
      @res.setHeader 'Vary', 'Accept-Encoding'
      @res.setHeader 'ETag',resHash
      @res.setHeader 'Cache-Control', 'public, max-age='+10
      @res.setHeader 'content-encoding', 'gzip'
      @res.setHeader 'content-type','text/html; charset=UTF-8'
      #@res.statusCode = 200
      d = new Date()
      d.setTime d.getTime()+10*1000
      @res.setHeader 'Expires',d.toGMTString()
    #@res.writeHead @res.statusCode||200
    zlib    = require 'zlib'
    zlib.gzip end,{level:9},(err,resdata)=> Q.spawn =>
      if err?
        console.error 'gzip',err,Exception err
        yield Feel.res500 @req,@res,err unless _sent
        return
      unless _sent
        @res.setHeader 'content-length',resdata.length
        @res.end resdata
        @time 'zlib'
        console.log process.pid+":state #{@statename}",@res.statusCode||200,resdata.length/1024,end.length/1024,Math.ceil((resdata.length/end.length)*100)+"%"
      if _production
        Q.spawn => @site.redis_cache.set @req.uniqHash,resdata,_max_age,resHash,'gzip'
  addModuleJs : (name)=>
    unless @state.page_tags['skip:'+name]
      return @site.moduleJsTag(name)
    else
      return ""
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
  cssModuleExt    : (modname,exts)=> do Q.async =>
    css = yield @site.modules[modname].getAllCssExt exts
    @css += "<style id=\"f-css-#{modname}-exts\">#{css}</style>"
  parse : (now,uniq,module,state,_pnode,_pkey)=> do Q.async =>
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
        yield @parse val,uniq,new_module,new_state,now,key
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
      
      filetag = @site.modules[now._name]?.coffeenr?['parse.coffee']
      if filetag
        tempGThis = {}
        try
          eval "(function(){#{filetag}}).apply(tempGThis);"
        catch e
          console.error "failed eval parse.coffee in #{now._name}".red
          console.error Exception e
        try
          tempGThis.parse = $W tempGThis.parse
          o.value = yield tempGThis.parse o.value
        catch e
          console.error "failed parse.coffee:parse() value:'#{o.value}' in #{now._name}".red
          console.error Exception e
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
          save_ = ret[key]._html.replace "m-#{idn}", "m-#{idn}\" uniq=\"#{uniq}:#{ret[key]._uniq}\" class=\"m-#{uniq}-#{idn}"
          save_[k_] = v_ for k_,v_ of ret[key]
          ret[key] = save_
    return ret
  redirect : (req,res,val)=> do Q.async =>
    if @site.state[val]?
      val = @site.state[val].class::route
    unless val
      return Feel.res403 req,res
    val = yield req.udataToUrl val
    res.statusCode = 301
    res.setHeader 'location', val
    res.setHeader 'Cache-Control','no-cache'
    res.end()

module.exports = RouteState


