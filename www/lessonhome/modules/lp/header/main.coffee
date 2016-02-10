class @main
  constructor : ->
    $W @
  Dom : =>
    @menuButton = @found.show_menu
    @fixedMenu  = @found.fixed_nav
    @offset_block = @found.offset_block
    @top_offset = $(@offset_block).offset().top + $(@offset_block).outerHeight()
    @fixedMenu.pushpin(
      {
        top: @top_offset
      }
    )
  show: =>
    $(window).resize =>
      showMenu = @offset_block.css 'display'
      if showMenu == 'block'
        @fixedMenu.pushpin(
          {
            top: @top_offset
          }
        )
      else
        @fixedMenu.pushpin(
          {
            top: 0
          }
        )

    @menuButton.sideNav()
    #@found.attach?.on? 'click', -> Feel.root.tree.class.attached.showForm()
    
    @found.demo_modal?.on? 'click', => Q.spawn =>
      #передать параметр 'fullBid' для открытия полной формы
      yield Feel.jobs.solve 'openBidPopup', null, 'menu'
