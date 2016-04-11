class @main
  constructor : ->
    @height_footer = $('footer:first').outerHeight(true)
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
              top : $(document).height() - @dom.offset().top - @height_footer - @bottom - @found.btn_up.outerHeight(true)  + 'px'
              bottom : ''
            }

        else

          if @found.btn_up.is('.abs')
            @found.btn_up.removeClass('abs').css {
              bottom : @bottom
              top: ''
            }


    @found.btn_up
    .click ->
      $('html, body').scrollTop(200).animate {scrollTop: 0}, 300
      return false
    .css {
      bottom : @bottom
    }