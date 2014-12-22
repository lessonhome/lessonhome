

class @activeState
  constructor : (@tree)->
    @classes  = {}
    @order    = []
    @watchDown @tree, (node,key,val)=>
      if val._isModule
        if Feel.modules[val._name]?.main?
          try @classes[val._uniq] = new Feel.modules[val._name].main()
          catch e then return Feel.error e, "new #{val._name}() failed"
          cl = @classes[val._uniq]
          cl.tree = val
          cl.__isClass = true
          @order.push val._uniq
          cl.tree?.class = cl
    @dom = {}
    @uniq_pref = ""
    @parseTree @tree
    @watchUp @tree, (node,key,val)=>
      return unless node[key]._isModule
      mod = node[key]
      return unless @classes[mod._uniq]?
      cl  = @classes[mod._uniq]
      if cl.dom?
        try cl.Dom? cl.dom
        catch e then return Feel.error e, "#{mod._name}.Dom() failed"
    @watchUp @tree, (node,key,val)=>
      return unless node[key]._isModule
      mod = node[key]
      return unless @classes[mod._uniq]?
      cl  = @classes[mod._uniq]
      try cl.show?()
      catch e then return Feel.error e, "#{mod._name}.init() failed"
  parseTree : (node)=>
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
      if obj?
        obj.dom = dom
        obj.pdom = @dom.parent
      @uniq_pref = node._uniq+"-"
      dom_parent = @dom.parent
      @dom.parent = dom
    for key,val of node
      if typeof val == 'object'
        @parseTree val
    if node._isModule
      @dom.parent = dom_parent
      @uniq_pref  = uniq_pref

  watchDown : (node,foo)=>
    return if node?.__isClass
    if node == @tree
      foo @,'tree',@tree
    for key,val of node
      continue if node[key]?.__isClass
      foo node,key,val
    for key,val of node
      if typeof val == 'object'
        @watchDown val, foo
  watchUp : (node,foo)=>
    return if node?.__isClass
    for key,val of node
      if typeof val == 'object'
        @watchUp val, foo
    for key,val of node
      continue if node[key]?.__isClass
      foo node,key,val
    if node == @tree
      foo @,'tree',@tree

    


