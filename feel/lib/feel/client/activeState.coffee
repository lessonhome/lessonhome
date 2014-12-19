


class @activeState
  constructor : (@tree)->
    @classes  = {}
    @order    = []
    @watchDown @tree, (node,key,val)=>
      if val._isModule
        if Feel.modules[val._name]?.main?
          @classes[val._uniq] = new Feel.modules[val._name].main()
          @classes[val._uniq].tree = val
          @classes[val._uniq].__isClass = true
          @order.push val._uniq
          @classes[val._uniq].tree?.class = @classes[val._uniq]
    @dom = {}
    @uniq_pref = ""
    @parseTree @tree
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
        dom = @dom.parent.find ".m-#{uniq_pref}"+node._name.replace(/\//g,"-")
      if obj?
        obj.dom = dom
        obj.dom_parent = @dom.parent
        obj.Dom? dom
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

    


