

class Cursor extends EE
  constructor : (@dom,@l,@r)->
  init : (@lb,@rb)=>
    @px @pos()
  x : (x)=>
    return @_x unless x?
    @_x = x if x?
    lb = @lb?.x?()
    lb ?= @lb
    rb = @rb?.x?()
    rb ?= @rb
    @_x = lb if @_x < lb
    @_x = rb if @_x > rb
    @_px = @_x*(@r()-@l())+@l()
    return @_x
  px : (px)=>
    @_px = px if px?
    @x (@_px-@l())/(@r()-@l())
    return @_px
  down : (e)=>
    @sm   = e.pageX
    @spx  = @px()
    Feel.unselect true
    $('body').on 'mousemove.slider', @move
    $('body').one 'mouseup.slider', =>
      Feel.unselect false
      $('body').off ".slider"
    $('body').one 'mouseleave.slider', => 
      Feel.unselect false
      $('body').off ".slider"
  drag : (dx)=>
    @pos @px @px()+Math.sign(@r()-@l())*dx
  move : (e)=>
    @m = e.pageX
    @pos @px Math.sign(@r()-@l())*(@m-@sm)+@spx

  set : (x)->
    console.log 'set',x
    @x(x)
    @pos @px()


class @main extends EE
  show : =>
    console.log 'show slider'
  Dom : =>
    @box_slider = @dom.find ".box_slider"
    @slider     = @box_slider.find ".slider"
    @division_box = @found.division_box
    @d_line     = @found.d_line
    @dom_left   = @slider.find '.icon_cursor_left'
    @dom_right  = @slider.find '.icon_cursor_right'
    @box_slider.on 'mousedown',@mouseDown
    @width = =>
      l = @dom_left?.outerWidth?()
      r = @dom_right?.outerWidth?()
      sw = 0 # сумарная ширина ползунков
      sw += l if l?
      sw += r if r?
      2*@box_slider.width()-@box_slider.outerWidth()-sw
    @left   = new Cursor @dom_left,(=>0),@width  if @dom_left.length
    @right  = new Cursor @dom_right,@width,(=>0) if @dom_right.length
    @left?.pos   = (px)=>
      return +@slider.css('margin-left').replace('px','') unless px?
      @slider.css('margin-left',px)
      setTimeout =>
        @emit 'left_slider_move', @left.x()
      ,1
      return px
    @right?.pos  = (px)=>
      return +@slider.css('margin-right').replace('px','') unless px?
      @slider.css('margin-right',px)
      setTimeout =>
        @emit 'right_slider_move', @right.x()
      ,1
      return px
    r = null
    l = null
    r = @right
    r?= 1
    l = @left
    l?= 0

    @left?.init?(0,r)
    @right?.init?(l,1)
  mouseDown : (e)=>
    left  =  e.pageX-(@dom_left.offset().left+@dom_left.outerWidth()/2)   if @left?
    right =  e.pageX-(@dom_right.offset().left+@dom_right.outerWidth()/2) if @right?
    if (@left? && !@right?) || ((Math.abs(left)<Math.abs(right)) && @left?)
      target = @left
      dx     = left
    else if @right?
      target = @right
      dx     = right
    if target?
      target.drag dx
      target.down e


  setLine: (pos)=>
    pos+="%"
    new_line = $(@d_line).clone()
    new_line.css("left", pos)
    $(@division_box).append(new_line)

  getType : =>
    if @tree.type?
      return @tree.type
    else
      return false

###


class @main extends EE
  show: =>
    @padding = 4
    @cursor_width = 14
    @box_slider = @dom.find ".box_slider"
    @box_slider_width = @box_slider.width()
    @slider = @box_slider.find ".slider"
    @cursor_left = @slider.find '.icon_cursor_left'
    @cursor_right = @slider.find '.icon_cursor_right'

    @cursor_left.on 'mousedown', =>
      console.log event
      @e_left = event
      @start_cursor_position_left = @e_left.pageX
      $('body').on 'mousemove.slider', =>
        @left_cursor_move(event.pageX - @start_cursor_position_left)
        @start_cursor_position_left = event.pageX
      $('body').one 'mouseup', =>
        $('body').off ".slider"

    @cursor_right.on 'mousedown', =>
      @e_right = event
      @start_cursor_position_right = @e_right.pageX
      $('body').on 'mousemove.slider', =>
        @right_cursor_move(event.pageX - @start_cursor_position_right)
        @start_cursor_position_right = event.pageX
      $('body').one 'mouseup', =>
        $('body').off ".slider"

  left_cursor_move: (delta)=>
    @set_left_cursor delta
    @emit 'left_cursor_move'


  set_left_cursor: (delta)=>
    current_cursor_left_pos = @cursor_left.position().left
    @slider_width_left = @slider.width()
    if delta < 0
      delta = Math.abs(delta)
      if current_cursor_left_pos == @padding then return 0
      if ( current_cursor_left_pos - delta ) < @padding
        @box_slider.css("padding-left", @padding )
        @slider.width(@slider_width_left + +@box_slider.css("padding-left").replace('px', '') - @padding)
      else
        @box_slider.css("padding-left", (+@box_slider.css("padding-left").replace('px', '') - delta))
        @slider.width(@slider_width_left + delta)
    else
      if (current_cursor_left_pos + delta < @cursor_right.position().left - @cursor_width )
        @slider.width(@slider_width_left - delta)
        new_padding = +@box_slider.css("padding-left").replace('px', '') + delta
        console.log new_padding
        console.log @box_slider.css("padding-left")
        @box_slider.css("padding-left", new_padding)
        console.log @box_slider.css("padding-left")
      else
        @box_slider.css("padding-left", @cursor_right.position().left - @cursor_width)
        console.log '!!!!'
        @slider.width(2*@cursor_width)
        console.log @slider.width()

  right_cursor_move: (delta)=>
    @set_right_cursor delta
    @emit 'right_cursor_move'

  set_right_cursor: (delta)=>
    current_cursor_right_pos = @cursor_right.position().left
    @slider_width_right = @slider.width()
    if delta < 0
      delta = Math.abs(delta)
      if (current_cursor_right_pos - delta < @cursor_left.position().left + @cursor_width)
        @slider.width(2*@cursor_width)
        #@box_slider.css("padding-right", +@box_slider.css("padding-right").replace('px', '') + (@cursor_right.position().left - @cursor_left.position().left))
      else
        @slider.width(@slider_width_right - delta)
        #@box_slider.css("padding-right", +@box_slider.css("padding-right").replace('px', '') + delta)

    else
      if ((current_cursor_right_pos + delta) < (@box_slider_width - @padding))
        console.log @slider.width()
        @slider.width(@slider_width_right + delta)
        console.log @slider.width()
        console.log 'aaa'
        #@box_slider.css("padding-right",  +@box_slider.css("padding-right").replace('px', '') - delta)
      else
        console.log @slider.width()
        @slider.width(@slider_width_right + (@box_slider_width - @padding - current_cursor_right_pos))
        console.log @slider.width()
        console.log 'bbb'
        #@box_slider.css("padding-right", @padding)









###
























###
  slider_body_click: (e)=>
    pos_x = e.position().left
    console.log pos_x
    @slider_offset_left = @slider.position().left
    console.log @slider_offset_left
    #console.log pos_x - @slider_offset_left - @cursor_width
###

###
    if @determine_cursor(pos_x) == 'left'
      @set_left_cursor()
      @emit 'left_cursor_move', pos_x
    else
      @set_right_cursor()
      @emit 'right_cursor_move', pos_x
  determine_cursor: ()=>
    if
  set_left_cursor:  ()=>
  set_right_cursor: ()=>

  current_position: =>
  @slider.position()
###
