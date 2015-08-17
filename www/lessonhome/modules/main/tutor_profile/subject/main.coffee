
class @main
  Dom: =>
    @header  = @found.header
    @content = @found.content
    @icon_wrap    = @found.icon_wrap
  show: =>
    $(@header).on 'click', =>
      @content.toggle()
      @icon_wrap.toggleClass('active')
