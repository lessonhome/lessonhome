class @main
  constructor : ->
    $W @
  Dom : =>
    @rightMenu = @found.right_link
    @qBlock    = @found.questions_block
  show: =>
    @rightMenu.on 'click', (e) =>
      thisLink = $(e.currentTarget)
      thisActive = thisLink.hasClass 'active'
      section = thisLink.attr('data-section')
      if thisActive == false
        @rightMenu.filter('.' + section).removeClass 'active'
        @qBlock.find('.' + section + '.active').fadeOut( =>
          @qBlock.find('#' + thisLink.attr('data-id')).fadeIn().addClass 'active'
          ).removeClass 'active'
        thisLink.addClass 'active'
