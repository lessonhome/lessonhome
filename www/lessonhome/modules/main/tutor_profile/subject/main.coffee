
class @main
  Dom: =>
    @header  = @found.header
    @content = @found.content
    @icon_wrap    = @found.icon_wrap
    @subject = @found.subject
    @comment = @found.comment
  show: =>
    $(@header).on 'click', =>
      @content.toggle()
      @icon_wrap.toggleClass('active')

  setValue: (data)=>
    @subject.text("#{value.subject ? ""}")
    # TODO: training directions
    @comment.text("#{value.comment ? ""}")
    # TODO: price