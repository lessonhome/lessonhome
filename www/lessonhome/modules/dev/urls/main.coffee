


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
    @onmm $(window).width()/2,300
    @timer()
    @dom.find('.in').click @parent.remove
  remove : =>
    $('body').removeClass 'g-fixed'
    $(window).scrollTop @scroll
    @dom.remove()
  mousemove : (e)=>
    x = e.clientX
    y = e.clientY
    @onmm x,y
  onmm : (x,y)=>
    w = @frame.width()*@sc+300
    h = @frame.height()*@sc
    iw = @img.width()*@sc+300
    ih = @img.height()*@sc
    W = $(window).width()
    H = $(window).height()
    
    dx = @frame.width()*(@sc-1)/2
    dy = @frame.height()*(@sc-1)/2
    idx = @img.width()*(@sc-1)/2
    idy = @img.height()*(@sc-1)/2

    cx = (x-W)/W+1
    cy = (y-(H))/(H)+1
    h += 300
    ih += 300
    @nx = (W/2-w)*cx+150
    @ny = (H/2-h)*cy+400
    @inx = (W/2-iw)*cx+150
    @iny = (H/2-ih)*cy+400
    if @ny > 100
      @ny = 100
    if @iny > 100
      @iny = 100
    @nx += dx
    @ny += dy
    @inx += idx
    @iny += idy
  mousewheel : (e)=>
    @nsc *= 1+0.1 * e.deltaY
    mx = 1.2
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
    rheight = @rimg.height()
    rheight = 3000 if rheight < 100
    @frame.css {
      transform : "translate(#{@x}px,#{@y}px) scale(#{@sc},#{@sc})"
      height : rheight
    }
    @img.css {
      transform : "translate(#{@ix}px,#{@iy}px) scale(#{@sc},#{@sc})"
      width : @rimg.width()
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

