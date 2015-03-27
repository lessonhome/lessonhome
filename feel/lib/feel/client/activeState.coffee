

class @activeState
  constructor : (@tree)->
    @classes  = {}
    @order    = []
    @watchDown @,'tree', (node,key,val)=>
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
          cl._smart = true
          cl.__isClass = true
          @order.push val._uniq
          cl.tree?.class = cl
          cl.js ?= {}
          for key_,val_ of Feel.modules[val._name]
            cl.js[key_] = val_
          for _i,ext_mod of val._extends_modules
            for  key_,val_ of Feel.modules[ext_mod]
              cl.js[key_] = val_
          cl.register = (name,obj=cl)->
            throw new Error "can't register module #{name} in Feel, already exists" if Feel[name]?
            Feel[name] = obj
    @dom = {}
    @uniq_pref = ""
    @parseTree @tree
    @watchUp @,'tree', (node,key,val)=>
      return unless node[key]?._isModule
      mod = node[key]
      return unless @classes[mod._uniq]?
      cl  = @classes[mod._uniq]
      if cl.dom?
        try cl.Dom? cl.dom
        catch e then return Feel.error e, " #{mod._name}.Dom() failed"
    @watchUp @,'tree', (node,key,val)=>
      return unless node[key]?._isModule
      mod = node[key]
      return unless @classes[mod._uniq]?
      cl  = @classes[mod._uniq]
      try cl.show?()
      catch e then return Feel.error e, " #{mod._name}.show() failed"
  parseTree : (node,statename)=>
    if node._statename?
      statename = node._statename
    return if node?.__isClass
    uniq_pref = @uniq_pref
    if node._isModule?
      if @classes[node._uniq]?
        obj = @classes[node._uniq]
      if !@dom.root?
        @dom.root = $('body>#m-'+node._name.replace(/\//g,"-"))
        dom = @dom.root
      if !@dom.parent?
        @dom.parent = $('body')
      if !dom?
        dom = @dom.parent.find "[uniq$=\"#{node._uniq}\"]"
      dom.attr 'state', statename
      dom.attr 'module', node._name if node._isModule
      if obj?
        obj.dom = dom
        obj.pdom = @dom.parent
        obj.found ?= {}
        if node._domregx? then for _js_sel of node._domregx
          obj.found[_js_sel] = obj.dom.find ".js-#{_js_sel}--#{node._uniq}"
          
      @uniq_pref = node._uniq+"-"
      dom_parent = @dom.parent
      @dom.parent = dom
    for key,val of node
      if typeof val == 'object'
        @parseTree val,statename
    if node._isModule
      @dom.parent = dom_parent
      @uniq_pref  = uniq_pref

  watchDown : (nparent,nkey,foo)=>
    node = nparent[nkey]
    return unless node? # && typeof node == 'object'
    #return unless node? && !node?.__isClass
    #if node == @tree
    #  foo? @,'tree',@tree
    foo? nparent,nkey,node
    #unless node._smart then for key,val of node
      #continue if node[key]?.__isClass
      #foo? node,key,val
    if (!node._smart) && ((typeof node == 'object') || (typeof node == 'function'))
      for key,val of node
        @watchDown node,key, foo
  watchUp : (nparent,nkey,foo)=>
    node = nparent[nkey]
    foo? nparent,nkey,node
    if (!node._smart) && ((typeof node == 'object') || (typeof node == 'function'))
      for key,val of node
        @watchUp node,key, foo
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

    


