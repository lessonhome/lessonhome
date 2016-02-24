class @main

  show: ->
    $(window).scroll (e) =>
      scroll = $(e.currentTarget).scrollTop()

      if scroll < 600
        @found.btn_up.fadeOut(150, => @found.btn_up.removeClass('fixed'))
      else
        @found.btn_up.addClass('fixed').fadeIn()

    @found.btn_up.click ->
      $('html, body').animate {scrollTop: 0}, 300
      return false