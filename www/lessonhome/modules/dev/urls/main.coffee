


class Viewer
  constructor : (@state,@parent)->
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
    @onmm()
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
  show : =>
    @models = @dom.find '.model'
    @models.click @open
    @node = {}
    for name,state of @tree.states
      if state.model
        @node["#{state.model}"] = state
    $(window).mousemove (e)=> @viewer?.mousemove? e
    $(window).mousewheel (e)=> @viewer?.mousewheel? e
    $(window).keydown @remove
    setInterval @timer, 1000/60
  remove : =>
    @viewer?.remove?()
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
      @viewer.remove()
      delete @viewer
    @viewer = new Viewer state,@
    @dom.append @viewer.dom
    return false
  timer : => @viewer?.timer?()

