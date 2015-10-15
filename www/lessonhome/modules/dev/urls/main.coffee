

class Viewer
  constructor : (@state,@parent)->
    $W @
    @dom = $('<div class="viewer"><div class="left"><div class="in"></div><iframe></iframe></div><div class="right"><div class="in"></div><div class="img"><img /></div></div></div>')
    @frame = @dom.find 'iframe'
    @img   = @dom.find '.img'
    @rimg  = @img.find 'img'
    @rimg.attr 'src', @state.src
    @scroll = $(window).scrollTop()
    $('body').addClass 'g-fixed'
    @frame.attr 'src', @state.route
    @x = 0
    @y = 0
    @nx = 0
    @ny = 0
    @ix = 0
    @iy = 0
    @inx = 0
    @iny = 0
    @sc = 0.5
    @nsc = 0.6
    @mx = $(window).width()/2
    @my = 80
    @onmm()
    @x = @nx
    @y = @ny
    @ix = @inx
    @iy = @iny
    @timer()
    @dom.find('.in').click @parent.remove
  remove : =>
    $('body').removeClass 'g-fixed'
    $(window).scrollTop @scroll
    @dom.remove()
  mousemove : (e)=>
    @mx = e.clientX
    @my = e.clientY
    @onmm()
  onmm : =>
    x = @mx
    y = @my
    fw = @frame.width()
    fh = @frame.height()
    Iw = @img.width()
    Ih = @img.height()
    fw = 1500 if fw < 100
    fh = 3000 if fh < 100
    Iw = 1500 if Iw < 100
    Ih = 3000 if Ih < 100
    ww = $(window).width()
    wh = $(window).height()
    w = fw*@nsc+600
    h = fh*@nsc
    iw = Iw*@nsc+600
    ih = Ih*@nsc
    W = ww
    H = wh
    
    dx = fw*(@nsc-1)/2
    dy = fh*(@nsc-1)/2
    idx = Iw*(@nsc-1)/2
    idy = Ih*(@nsc-1)/2

    cx = (x-W)/W+1
    cy = (y-(H))/(H)+1
    #h += 100
    #ih += 100
    @nx = (W/2-w)*cx+350
    @ny = (H/2-h)*cy+200
    @inx = (W/2-iw)*cx+350
    @iny = (H/2-ih)*cy+200
    #if @ny > 150
    #  @ny = 150
    #if @iny > 150
    #  @iny = 150
    @nx += dx
    @ny += dy
    @inx += idx
    @iny += idy
  mousewheel : (e)=>
    @nsc *= 1+0.1 * e.deltaY
    mx = 1.4
    c = @nsc/@sc
    if c > 1
      @nsc = @sc*mx
    if c < 1
      @nsc = @sc/mx
  timer : =>
    @x += (@nx-@x)/10
    @y += (@ny-@y)/10
    @ix += (@inx-@ix)/10
    @iy += (@iny-@iy)/10
    @sc += (@nsc-@sc)/10
    yield @onmm()
    rheight = @rimg.height()
    rheight = 3000 if rheight < 100
    riw = @rimg.width()
    riw = 1500 if riw < 100
    @frame.css {
      transform : "translate(#{@x}px,#{@y}px) scale(#{@sc},#{@sc})"
      height : rheight
    }
    @img.css {
      transform : "translate(#{@ix}px,#{@iy}px) scale(#{@sc},#{@sc})"
      width : riw
    }


class @main
  constructor : ->
    $W @
  show : =>
    @models = @dom.find 'a.model'
    @models.click @open
    @node = {}
    for name,state of @tree.states
      if state.model
        @node["#{state.model}"] = state
    $(window).mousemove (e)=> @viewer?.mousemove? e
    $(window).mousewheel (e)=> @viewer?.mousewheel? e
    $(window).keydown @remove
    setInterval @timer, 1000/60
    yield @setSort()
    @fixeddiv = @dom.find '.fixed *'

    titles = @dom.find('.state .title')
    names = @dom.find('.state .name')
    routes = @dom.find('.state .route')
    models = @dom.find('.state .model')

    T = 0
    N = 0
    R = 0
    M = 0
    width = (d)=> @fixeddiv.text($(d).text()).outerWidth()
    for title, i in titles
      t = width title
      n = width names[i]
      r = width routes[i]
      m = width models[i]
      T = t if t>T
      N = n if n>N
      R = r if r>R
      M = m if m>M

    S= (T+N+R+M)
    console.log S,T,R,N,M
    T = T*100.0/S
    R = R*100.0/S
    N = N*100.0/S
    M = M*100.0/S
    console.log S,T,R,N,M
    @dom.find('.state .title').css "width",T+"%"
    @dom.find('.state .name').css "width",N+"%"
    @dom.find('.state .route').css "width", R+"%"
    @dom.find('.state .model').css "width",M+"%"
  remove : =>
    yield @viewer?.remove?()
    delete @viewer

  open : (e)=>
    e.preventDefault()
    @dom.find('.state.active').removeClass 'active'
    $(e.target).parent().addClass 'active'
    model = $(e.target).attr 'href'
    m =model.match /^\/file\/\w+\/models\/(.*)\.\w+$/
    console.log model
    return false unless m
    state = @node[m[1]]
    state.src = model
    return false unless state

    if @viewer?
      yield @viewer.remove()
      delete @viewer
    @viewer = new Viewer state,@
    @dom.append @viewer.dom
    return false
  timer : => @viewer?.timer?()
  setSort : =>
    divs = @dom.find '.state.top *'
    for d in divs
      d = $ d
      cl = d.attr 'class'
      do (d,cl)=>
        d.click =>
          @sort cl
    divs = @dom.find '.state'
    arr = []
    for d,i in divs
      continue unless i
      d = $ d
      o  = {
        dom : d
      }
      sub = d.find 'a'
      for s in sub
        s = $ s
        cl = s.attr 'class'
        text = s.html()
        o[cl] = text
      arr.push o
    @arr = arr
    @lastCl = "model"
    @setSorted @lastCl
  sort : (cl)=>
    cmp = (a,b)=> a>b
    if @lastCl == cl
      cmp = (a,b)=> a<b
      @lastCl = ""
    else
      @lastCl = cl
    for i in [0...@arr.length-1]
      for j in [i...@arr.length]
        if cmp @arr[i][cl],@arr[j][cl]
          k = @arr[i]
          @arr[i] = @arr[j]
          @arr[j] = k
          yield @place @arr,i
          yield @place @arr,j
    @setSorted cl
  setSorted : (cl)=>
    @dom.find('.top .sorted').removeClass 'sorted'
    @dom.find('.top .'+cl).addClass 'sorted'

  place : (arr,i)=>
    if i != 0
      arr[i].dom.insertAfter arr[i-1].dom
    else
      arr[i].dom.insertBefore arr[1].dom


