


class @PBar
  constructor : ->
    $W @
    @p = 0
    @inc  = 0.05
    @tinc = 0.01
    @tt   = 500
    setInterval @timer,@tt
  init : =>
    @div = $('<div id="pbar"><div class="dt"></div><div class="dd"></div></div>')
    @div.css 'opacity',1
    @div.hide()
    @div.width 0
    @div.appendTo $('body')
  start : =>
    @div.stop true,true
    @div.css {'opacity':1}
    @div.show()
    @p = 0.1 unless @p > 0
    @div.width @p*$(window).width()
  stop : =>
    @p = 1
    @div.width $(window).width()
    setTimeout =>
      @div.css {'opacity':0}
      setTimeout =>
        @div.stop(true,true)
        @p = 0
        @div.hide()
        @div.width 0
        @div.css 'opacity',1
      ,1000
    ,400
  set  : (x=0.001)=>
    @start() if @p<=0
    if @p > 1
      @p = 1
    inc = Math.pow(1-@p,2)*@inc
    d = x - @p
    if x < @p
      @p += inc
    else
      @p = x
    if @p > 1
      @p = 1
    return @stop() if @p>=1
    @div.width @p*$(window).width()
  timer : =>
    return unless 0 < @p < 1
    @p += Math.pow(1-@p,1/8)*@tinc
    @div.width @p*$(window).width()



