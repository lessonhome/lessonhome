

class @activeState
  init : =>
  constructor : (@tree)->
    @classes  = {}
    @order    = []
    @initClasses  @tree
    @initDoms     @tree
  initDoms : (node)=>
    obj = tree:node
    @dom = {
      root  : (node.dom ? $('body'))
    }
    dom = @dom.root.filter('[id^=m-]')
    dom = dom.add @dom.root.find('[id^=m-]')
    @dom.root = dom.first()
    @uniq_pref = ""
    @parseTree node
    @watchUp obj,'tree', (node,key,val)=>
      return unless node[key]?._isModule
      mod = node[key]
      return unless @classes[mod._uniq]?
      cl  = @classes[mod._uniq]
      if cl.dom?
        try
          retdom = cl.Dom? cl.dom
          if Q.isPromise retdom
            retdom.catch (e)->
              Feel.error Exception(e)," #{mod._name}.Dom() failed"
            .done()
        catch e then return Feel.error e, " #{mod._name}.Dom() failed"
    @watchUp obj,'tree', (node,key,val)=>
      return unless node[key]?._isModule
      mod = node[key]
      return unless @classes[mod._uniq]?
      cl  = @classes[mod._uniq]
      try
        retshow = cl.show?()
        if Q.isPromise retshow
          retshow.catch (e)->
            Feel.error Exception(e)," #{mod._name}.show() failed"
          .done()
      catch e then return Feel.error e, " #{mod._name}.show() failed"
  parseError : (e,obj,foo)=>
  initClasses : (node)=>
    obj = tree:node
    @watchDown obj,'tree', (node,key,val)=>
      if val?._isModule
        mainClass = Feel.modules[val._name]?.main
        for _i,ext_mod of val._extends_modules
          if Feel.modules[ext_mod]?.main?
            mainClass = Feel.modules[ext_mod]?.main
        if mainClass
          try @classes[val._uniq] = new mainClass()
          catch e then return Feel.error e, "new #{val._name}() failed"
          cl = @classes[val._uniq]
          cl.tree = val
          do (val)=>
            cl.$send = (args...)=> Feel.send "modules/"+val._name,args...
          cl.$clone = (new_tree)=> @clone cl.tree,new_tree
          cl._smart = true
          cl.__isClass = true
          @order.push val._uniq
          cl.tree?.class = cl
          if cl.tree?.default?
            unless typeof cl.tree.default == 'object'
              cl.tree.value ?= cl.tree.default
            else for _key,_val of cl.tree.default
              v = _setKey cl.tree.value,_key
              _setKey cl.tree.value, _key,_val unless v?
          cl.js ?= {}
          for key_,val_ of Feel.modules[val._name]
            cl.js[key_] = val_
          for _i,ext_mod of val._extends_modules
            for  key_,val_ of Feel.modules[ext_mod]
              cl.js[key_] = val_
          cl.register = (name,obj=cl)->
            #throw new Error "can't register module #{name} in Feel, already exists" if Feel[name]?
            #return if Feel[name]?
            Feel[name] = obj
          if cl.tree.$urlforms && Object.keys?(cl?.tree?.$urlforms)?.length
            if cl.getValue?
              cl?.on 'change', => Q.spawn funconchange = =>
                cl.__w8change ?= 0
                return if cl.__ulock
                if cl.__ulock2
                  if cl.__w8change < 2
                    cl.__w8change = 2
                    yield _waitFor cl,'w8change'
                    cl.__w8change = 0
                    return Q.spawn funconchange
                  else return
                cl.__w8change = 1
                cl.__ulock2 = true
                v = cl.getValue()
                for part,form of cl.tree.$urlforms
                  nv = _setKey v,part
                  yield Feel.urlData.set form.form,form.key,nv
                cl.__ulock2 = false
                cl.__w8change = 0
                cl.emit 'w8change'
              if cl.setValue?
                Feel.urlData.on 'change',=> Q.spawn funconchange2 = =>
                  #return if cl.__ulock2
                  #return if cl.__ulock
                  cl.__w8change2 ?= 0
                  if cl.__ulock
                    if cl.__w8change2 < 2
                      cl.__w8change2 = 2
                      yield _waitFor cl,'w8change2'
                      return Q.spawn funconchange2
                    else return
                  if cl.__ulock2
                    if cl.__w8change2 < 2
                      cl.__w8change2 = 2
                      yield _waitFor cl,'w8change'
                      return Q.spawn funconchange2
                    else return
                  cl.__w8change2 = 1
                  cl.__ulock = true
                  v = {value:yield cl.getValue()}
                  nv = {}
                  v2 = {}
                  for part,form of cl.tree.$urlforms
                    _setKey nv,"value."+part,(yield Feel.urlData.get(form.form,form.key))
                    _setKey v2,"value."+part,(_setKey(v,"value."+part))
                  if JSON.stringify(v2) != JSON.stringify(nv)
                    if nv.value && (typeof nv.value == 'object')
                      for key,val of nv.value
                        _setKey v.value,key, val
                    cl.setValue _setKey(v,'value')
                  cl.__w8change2 = 0
                  cl.__ulock = false
                  cl.emit 'w8change2'
          Wrap cl,null,false
          Wrap cl.js,null,false if cl?.js?
  parseTree : (node,statename)=>
    return if node._parseIn
    if node._statename?
      statename = node._statename
    return if node?.__isClass || node._smart
    node._parseIn = true
    uniq_pref = @uniq_pref
    if node._isModule?
      if @classes[node._uniq]?
        obj = @classes[node._uniq]
      if !@dom.root?
        @dom.root = $('body>#m-'+node._name.replace(/\//g,"-"))
        dom = @dom.root
      if !@dom.parent?
        @dom.parent = @dom.root.parent() #$('body')
        dom = @dom.root
      if !dom?
        dom = @dom.parent.filter("[uniq$=\"#{node._uniq}\"]")
        dom = dom.add @dom.parent.find("[uniq$=\"#{node._uniq}\"]")
        dom = dom.first()
      dom.attr 'state', statename
      dom.attr 'module', node._name if node._isModule
      if obj?
        obj.dom = dom
        obj.pdom = @dom.parent
        obj.found ?= {}
        if node._domregx? then for _js_sel of node._domregx
          obj.found[_js_sel] = obj.dom.filter ".js-#{_js_sel}--#{node._uniq}"
          obj.found[_js_sel] = obj.found[_js_sel].add obj.dom.find ".js-#{_js_sel}--#{node._uniq}"
          
      @uniq_pref = node._uniq+"-"
      dom_parent = @dom.parent
      @dom.parent = dom
    for key,val of node
      if typeof val == 'object' && val!=null
        @parseTree val,statename
    if node._isModule
      @dom.parent = dom_parent
      @uniq_pref  = uniq_pref
    delete node._parseIn

  watchDown : (nparent,nkey,sparent,foo,tparent)=>
    unless foo?
      foo = sparent
      sparent = undefined
    node = nparent[nkey]
    snode = sparent?[nkey]
    tnode = tparent?[nkey]
    return unless node? # && typeof node == 'object'
    #return unless node? && !node?.__isClass
    #if node == @tree
    #  foo? @,'tree',@tree
    foo? nparent,nkey,node,sparent,snode,tparent,tnode
    #unless node._smart then for key,val of node
      #continue if node[key]?.__isClass
      #foo? node,key,val
    if node && (!node._smart) && ((typeof node == 'object') || (typeof node == 'function'))
      for key,val of node
        @watchDown node,key,snode,foo,tnode
  watchUp : (nparent,nkey,sparent,foo,tparent)=>
    unless foo?
      foo = sparent
      sparent = undefined
    node = nparent[nkey]
    snode = sparent?[nkey]
    tnode = tparent?[nkey]
    foo? nparent,nkey,node,sparent,snode,tparent,tnode
    if node && (!node._smart) && ((typeof node == 'object') || (typeof node == 'function'))
      for key,val of node
        @watchUp node,key, snode,foo,tnode
    #return if node?.__isClass
    # unless node._smart then for key,val of node
    #for key,val of node
    #  if typeof val == 'object' && typeof foo =='function'
    #    @watchUp node,key,foo
    #for key,val of node
    #  continue if node[key]?.__isClass
    #  foo? node,key,val
    #if node == @tree
    #  foo? @,'tree',@tree

  clone : (tree)=>
    obj = {tree}
    ntree = _.cloneDeep tree
    nobj = {tree:ntree}
    ndom = tree.class?.dom?.clone()
    ntree.dom = ndom
    ntree.dom._smart = true
    foo = (node,key,val,snode,sval)=>
      if sval?._isModule
        delete sval.class
        delete sval.found
        sval._uniq += _.uniqueId()
        doms = ndom.find("[class*='m-#{val._uniq}-']").add ndom.filter "[class*='m-#{val._uniq}-']"
        doms.each ->
          that = $ @
          that.attr 'class', that.attr('class').replace 'm-'+val._uniq+'-','m-'+sval._uniq+'-'
        doms = ndom.find("[class*='--#{val._uniq}']").add ndom.filter "[class*='--#{val._uniq}']"
        doms.each ->
          that = $ @
          _clcl = that.attr('class').split ' '
          for a,i in _clcl
            if a.match new RegExp "--#{val._uniq}$"
              _clcl[i] = a.replace val._uniq,sval._uniq
          that.attr 'class', _clcl.join ' '
        doms = ndom.find("[uniq^='#{val._uniq}:']").add ndom.filter "[uniq^='#{val._uniq}:']"
        doms.each ->
          that = $ @
          that.attr 'uniq', that.attr('uniq').replace val._uniq+':',sval._uniq+':'
        doms = ndom.find("[uniq$=':#{val._uniq}']").add ndom.filter "[uniq$=':#{val._uniq}']"
        doms.each ->
          that = $ @
          that.attr 'uniq', that.attr('uniq').replace ':'+val._uniq,':'+sval._uniq
        ###
        mainClass = Feel.modules[sval._name]?.main
        for _i,ext_mod of sval._extends_modules
          if Feel.modules[ext_mod]?.main?
            mainClass = Feel.modules[ext_mod]?.main
        
        if mainClass
          try @classes[sval._uniq] = new mainClass()
          catch e then return Feel.error e, "new #{sval._name}() failed"
          cl = @classes[sval._uniq]
          cl.tree = sval
          do (sval)=>
            cl.$send = (args...)=> Feel.send "modules/"+sval._name,args...
          cl.$clone = (new_tree)=> @clone cl.tree,new_tree
          cl._smart = true
          cl.__isClass = true
          @order.push sval._uniq
          cl.tree?.class = cl
          if cl.tree?.default?
            unless typeof cl.tree.default == 'object'
              cl.tree.value ?= cl.tree.default
            else for _key,_val of cl.tree.default
              v = _setKey cl.tree.value,_key
              _setKey cl.tree.value,_key,_val unless v?
          cl.js ?= {}
          for key_,val_ of Feel.modules[sval._name]
            cl.js[key_] = val_
          for _i,ext_mod of sval._extends_modules
            for key_,val_ of Feel.modules[ext_mod]
              cl.js[key_] = val_
          if cl.tree.$urlforms && Object.keys?(cl?.tree?.$urlforms)?.length
            if cl.getValue?
              cl?.on 'change', => Q.spawn =>
                v = cl.getValue()
                for part,form of cl.tree.$urlforms
                  nv = _setKey v,part
                  yield Feel.urlData.set form.form,form.key,nv
          Wrap cl,null,false
          Wrap cl.js,null,false if cl?.js?
          ###
    @watchDown obj,'tree',nobj,foo
    @initClasses ntree
    @initDoms ntree
    return ntree?.class











