




class @main
  constructor : ->
    Wrap @
    @now = []
  show : =>
    Feel.urlData.on 'change',@reshow.out
  reshow : =>
    linked  = yield Feel.urlData.get 'mainFilter','linked'
    linked  = Object.keys(linked ? {}) ? []
    preps   = yield Feel.dataM.getTutor linked
    arr = for i in linked then preps[i]
    @found.list.empty()
    for p in @now
      p.dom.remove()
      @now = []
    @left = 0
    @right = 0
    for p in arr
      o = yield @createDom p
      @push o
      @found.list.append o.dom
    if arr.length
      @dom.show()
    else
      @dom.hide()
  push : (p)=>
    left = 6
    top = @left+8
    if @right < @left
      left = 96
      top  = @right+8
      @right += p.h+16
    else
      @left += p.h+16
    p.dom.css {
      top : top
      left : left
    }
    @found.list.height Math.max @left,@right

  createDom : (prep)=>
    cl = yield @tree.tutors[0].class.$clone()
    o = {}
    o.cl = cl
    o.dom = $("<div class='tutors'></div>")
    o.dom.append cl.dom
    ret = yield cl.setValue prep
    o.h = ret.h
    @now.push o
    return o
