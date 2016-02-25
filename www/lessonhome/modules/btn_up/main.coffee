class @main
  constructor : ->
    @height_footer = 170
    @bottom = 70
  show: ->

    $(window)
    .scroll (e) =>
      scroll = $(e.currentTarget).scrollTop()

      if scroll < 600
        @found.btn_up.fadeOut(150, => @found.btn_up.removeClass('fixed'))
      else
        @found.btn_up.addClass('fixed').fadeIn()

        if $(document).height() - scroll - $(e.currentTarget).height() < @height_footer

          unless @found.btn_up.is('.abs')
            @found.btn_up.addClass('abs').css {
              top : $(document).height() - @height_footer - @bottom - @found.btn_up.outerHeight(true)  + 'px'
              bottom : ''
            }

        else

          if @found.btn_up.is('.abs')
            @found.btn_up.removeClass('abs').css {
              bottom : @bottom
              top: ''
            }

    .resize @reSize

    @found.btn_up
    .click ->
      $('html, body').animate {scrollTop: 0}, 300
      return false
    .appendTo($('html:first'))
    .css {
      bottom : @bottom
    }

    @reSize()

  reSize : =>
    @found.btn_up.css {
      width : @dom.width()
      height : @dom.height()
      left : @dom.offset().left
    }