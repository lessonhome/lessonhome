
class @main
  Dom: =>
    @header  = @found.header
    @content = @found.content
    @icon_wrap    = @found.icon_wrap
    @subject = @found.subject
    @comment = @found.comment
    @v60  = @found.v60
    @v90  = @found.v90
    @v120 = @found.v120
  show: =>
    $(@header).on 'click', =>
      @content.toggle()
      @icon_wrap.toggleClass('active')

  setValue: (key, val)=>
    @subject.text("#{key ? ""}")
    # TODO: training directions
    @comment.text("#{val.description ? ""}")
    p1 = val.price.left
    p2 = val.price.right
    t1 = val.duration.left
    t2 = val.duration.right
    k = (p2 - p1)/(t2 - t1)
    if (k > 200 || k < 4) then k = 14
    v60  = k*(60 - t1)  + p1
    v90  = k*(90 - t1)  + p1
    v120 = k*(120 - t1) + p1
    @v60.text("60 минут : "+v60+" руб.")
    @v90.text("90 минут : "+v90+" руб.")
    @v120.text("120 минут : "+v120+" руб.")
